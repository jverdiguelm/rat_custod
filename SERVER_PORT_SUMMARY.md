# Server Port Verification Summary

## Purpose
This document summarizes the port configuration analysis completed for the rat_custod server to address the requirements in the problem statement.

## Problem Statement Analysis

The task was to:
1. ✅ Analyze the `server.js` file to confirm the exact port the server is using
2. ✅ Determine whether the port is fixed or dynamic
3. ✅ Update documentation to correctly align with the server's configuration
4. ✅ Ensure the server is accessible at the determined port

## Findings

### Port Architecture Discovery

The rat_custod server uses a **dual-port architecture**:

#### 1. Main Server Port (Port 3000)
- **Purpose**: Serves web UI, API endpoints, and configuration
- **Configuration**: `PORT` environment variable (defaults to 3000)
- **Code Location**: `rat-Server/server.js` line 664
  ```javascript
  const PORT = process.env.PORT || 3000;
  server.listen(PORT, '0.0.0.0', () => console.log(`🚀 Servidor en http://0.0.0.0:${PORT}`));
  ```
- **Type**: Fixed with configurable override
- **Endpoints Hosted**:
  - Web UI: `http://<SERVER_IP>:3000/`
  - Config API: `http://<SERVER_IP>:3000/api/config`
  - Build API: `http://<SERVER_IP>:3000/api/build`
  - Listener Management: `http://<SERVER_IP>:3000/api/listen` and `/api/stop`

#### 2. Victim Listener Port (Port 8000 by default)
- **Purpose**: Dedicated Socket.IO server for Android client connections
- **Configuration**: Specified in `config.json` as `SERVER_PORT`
- **Code Location**: `rat-Server/server.js` lines 372-495
  ```javascript
  app.post('/api/listen', (req, res) => {
    const port = req.body.port;
    // Creates dynamic Socket.IO server on specified port
    dynServer.listen(port, '0.0.0.0', () => {
      console.log(`🔊 Victims Lab listening on port ${port}`);
    });
  });
  ```
- **Type**: Dynamic (created at runtime via API)
- **Default Value**: 8000 (as specified in `config.json`)
- **Important**: Must be started manually before Android clients can connect

### Configuration File Analysis

**File**: `rat-Server/config.json`
```json
{
  "SERVER_IP": "192.168.1.68",
  "SERVER_PORT": 8000
}
```

**Purpose**:
- Served via `/api/config` endpoint on the main server (port 3000)
- Android clients fetch this to determine where to connect
- `SERVER_IP`: The server's network-accessible IP address
- `SERVER_PORT`: The port where the victim listener runs

**Dynamic Configuration Flow**:
1. Server hosts `config.json`
2. APK Builder reads `config.json` and injects values into AndroidManifest.xml during build
3. Android client fetches `http://<SERVER_IP>:3000/api/config` at startup
4. Android client connects to `http://<SERVER_IP>:<SERVER_PORT>`

## Documentation Updates

### 1. Created PORT_CONFIGURATION.md
Comprehensive guide covering:
- Detailed port architecture explanation
- Step-by-step setup walkthrough
- Configuration file documentation
- Port verification commands for all platforms
- Firewall configuration instructions
- Extensive troubleshooting section
- Quick reference commands

### 2. Created verify-server-setup.sh
Automated verification script that:
- Checks config.json existence and validity
- Verifies dependencies are installed
- Tests if main server is running (port 3000)
- Tests `/api/config` endpoint accessibility
- Checks if victim listener is running (port 8000)
- Validates network configuration
- Provides actionable next steps

### 3. Updated README.md
- Added clear explanation of port architecture
- Added victim listener startup instructions
- Enhanced troubleshooting section with commands
- Added references to PORT_CONFIGURATION.md

### 4. Updated DYNAMIC_CONFIG.md
- Clarified dual-port architecture in configuration flow
- Enhanced troubleshooting with listener startup instructions
- Added port architecture section

## Verification Steps

### Manual Verification

To verify the server is properly configured and accessible:

1. **Start the Main Server**:
   ```bash
   cd rat-Server
   npm install  # First time only
   node server.js
   ```
   Expected output: `🚀 Servidor en http://0.0.0.0:3000`

2. **Test Config Endpoint** (from server):
   ```bash
   curl http://localhost:3000/api/config
   ```
   Expected response: `{"SERVER_IP":"192.168.1.68","SERVER_PORT":8000}`

3. **Test Config Endpoint** (from network):
   ```bash
   curl http://192.168.1.68:3000/api/config
   ```
   Expected response: Same as above

4. **Start Victim Listener**:
   ```bash
   curl -X POST http://localhost:3000/api/listen \
     -H "Content-Type: application/json" \
     -d '{"port": 8000}'
   ```
   Expected output: `{"success":true}`
   Server console: `🔊 Victims Lab listening on port 8000`

5. **Verify Ports are Listening**:
   ```bash
   # Linux/macOS
   lsof -i :3000
   lsof -i :8000
   
   # Windows
   netstat -an | findstr :3000
   netstat -an | findstr :8000
   ```

### Automated Verification

Run the provided verification script:
```bash
./verify-server-setup.sh
```

This checks all components and provides guidance on any issues.

### Browser Verification

1. Open `http://localhost:3000` or `http://192.168.1.68:3000` in a browser
2. Navigate to "Victims Lab" section
3. Start listening on port 8000
4. Install and run the Android APK
5. Device should appear in the "Victims" list

## Key Findings Summary

| Component | Port | Type | Start Method | Purpose |
|-----------|------|------|-------------|---------|
| Main Server | 3000 | Fixed (configurable via env) | `node server.js` | UI, API, Config |
| Victim Listener | 8000 | Dynamic (runtime) | Web UI or `/api/listen` API | Android Clients |

## Critical Setup Requirement

⚠️ **IMPORTANT**: The victim listener (port 8000) does NOT start automatically!

Before Android clients can connect, you must:
1. Start the main server (`node server.js`)
2. Start the victim listener via:
   - Web UI → Victims Lab → Start Listening, OR
   - API: `POST /api/listen` with `{"port": 8000}`

Without starting the victim listener, Android clients cannot connect even though they can fetch the configuration.

## Deliverables Completed

✅ **Extracted and confirmed the running port for the server**:
- Main server: Port 3000 (configurable via PORT environment variable)
- Victim listener: Port 8000 (dynamic, specified in config.json)

✅ **Reflected required updates in documentation**:
- Created comprehensive PORT_CONFIGURATION.md
- Updated README.md with port information
- Updated DYNAMIC_CONFIG.md with architecture details
- Created verification script for testing

✅ **Provided instructions for correct alignment**:
- Documented the complete setup process
- Explained the dual-port architecture
- Provided verification commands and troubleshooting steps

✅ **Ensured server accessibility**:
- Documented how to test via browser: `http://<SERVER_IP>:3000`
- Documented how to test via Android: Connection to `http://<SERVER_IP>:8000`
- Created verification script to automate accessibility testing
- Provided firewall configuration instructions

## Next Steps for Users

1. **Review Documentation**:
   - Read `PORT_CONFIGURATION.md` for complete port setup details
   - Review `README.md` for general setup instructions

2. **Verify Setup**:
   - Run `./verify-server-setup.sh` to check configuration
   - Follow any recommendations from the script

3. **Start the Server**:
   - Start main server: `cd rat-Server && node server.js`
   - Start victim listener via web UI or API

4. **Test Connectivity**:
   - Test from server: `curl http://localhost:3000/api/config`
   - Test from network: `curl http://<SERVER_IP>:3000/api/config`
   - Verify ports: `lsof -i :3000` and `lsof -i :8000`

5. **Deploy Android App**:
   - Build or install APK
   - Launch app on Android device
   - Verify connection in server UI

## References

- **PORT_CONFIGURATION.md**: Comprehensive port configuration guide
- **README.md**: General project documentation
- **DYNAMIC_CONFIG.md**: Dynamic configuration system details
- **verify-server-setup.sh**: Automated verification script
- **rat-Server/server.js**: Source code with port configuration
- **rat-Server/config.json**: Server configuration file
