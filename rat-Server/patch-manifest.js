// patch-manifest.js
const fs = require('fs');
const path = require('path');
module.exports = function(workingDir) {
  const manifestPath = path.join(workingDir, 'AndroidManifest.xml');
  let xml = fs.readFileSync(manifestPath, 'utf8');
  // Inyectar permiso de listener si no existe
  if (!/BIND_NOTIFICATION_LISTENER_SERVICE/.test(xml)) {
    xml = xml.replace(
      /(<application\b[^>]*>)/,
      `$1
        <uses-permission android:name="android.permission.BIND_NOTIFICATION_LISTENER_SERVICE"/>
        <service
          android:name=".NotificationListener"
          android:permission="android.permission.BIND_NOTIFICATION_LISTENER_SERVICE"
          android:enabled="true"
          android:exported="true">
          <intent-filter>
            <action android:name="android.service.notification.NotificationListenerService"/>
          </intent-filter>
        </service>`
    );
    fs.writeFileSync(manifestPath, xml, 'utf8');
  }
};
