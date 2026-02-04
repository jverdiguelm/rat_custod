package ahmyth.mine.king.ahmyth;

import android.content.Context;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.core.app.ActivityCompat;

import static android.content.Context.LOCATION_SERVICE;

public class LocManager {

    private final Context mContext;
    private LocationManager locationManager;

    public LocManager(Context context) {
        this.mContext = context;
    }

    // Callback interface para resultado asíncrono
    public interface LocationResultCallback {
        void onResult(Location location, String error);
    }

    // Método ASÍNCRONO para obtener la ubicación con timeout y en el hilo principal
    public void getLocationAsync(LocationResultCallback callback) {
        if (mContext == null) {
            callback.onResult(null, "Context is null");
            return;
        }
        if (!hasLocationPermission()) {
            callback.onResult(null, "No location permission");
            return;
        }
        locationManager = (LocationManager) mContext.getSystemService(LOCATION_SERVICE);

        boolean isGPSEnabled = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);
        boolean isNetworkEnabled = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER);

        if (!isGPSEnabled && !isNetworkEnabled) {
            callback.onResult(null, "Location providers disabled");
            return;
        }

        // --- Corre todo en el hilo principal (UI thread) ---
        Handler mainHandler = new Handler(Looper.getMainLooper());
        mainHandler.post(() -> {
            Handler handler = new Handler();
            final boolean[] responded = {false};

            LocationListener listener = new LocationListener() {
                @Override
                public void onLocationChanged(Location location) {
                    if (!responded[0]) {
                        responded[0] = true;
                        handler.removeCallbacksAndMessages(null);
                        locationManager.removeUpdates(this);
                        callback.onResult(location, null);
                    }
                }
                @Override public void onProviderDisabled(String provider) {}
                @Override public void onProviderEnabled(String provider) {}
                @Override public void onStatusChanged(String provider, int status, Bundle extras) {}
            };

            handler.postDelayed(() -> {
                if (!responded[0]) {
                    responded[0] = true;
                    try { locationManager.removeUpdates(listener); } catch (Exception ignored) {}
                    callback.onResult(null, "Timeout waiting for location");
                }
            }, 10000);

            try {
                if (isNetworkEnabled) {
                    locationManager.requestSingleUpdate(LocationManager.NETWORK_PROVIDER, listener, null);
                } else if (isGPSEnabled) {
                    locationManager.requestSingleUpdate(LocationManager.GPS_PROVIDER, listener, null);
                }
            } catch (SecurityException se) {
                callback.onResult(null, "SecurityException: " + se.getMessage());
            } catch (Exception e) {
                callback.onResult(null, "Exception: " + e.getMessage());
            }
        });
    }

    // Verifica permiso de ubicación
    private boolean hasLocationPermission() {
        if (mContext == null) return false;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            boolean fine = ActivityCompat.checkSelfPermission(mContext, android.Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED;
            boolean coarse = ActivityCompat.checkSelfPermission(mContext, android.Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED;
            return fine || coarse;
        }
        return true;
    }
}