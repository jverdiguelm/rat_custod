#!/bin/bash
# Build wrapper script for rat-Client
# Ensures JDK 11 is used for building to avoid reflection access errors

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "RAT Custod Android Client Build Script"
echo "======================================="
echo ""

# Check if we're in the rat-Client directory
if [ ! -f "gradlew" ]; then
    echo "Error: This script must be run from the rat-Client directory"
    exit 1
fi

# Determine JDK 11 location
JDK11_LOCATIONS=(
    "/usr/lib/jvm/temurin-11-jdk-amd64"
    "/usr/lib/jvm/java-11-openjdk-amd64"
    "/usr/lib/jvm/java-11-openjdk"
    "/usr/local/opt/openjdk@11"
    "/Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Home"
    "$HOME/.sdkman/candidates/java/11"
)

# Try to find JDK 11
JDK11_PATH=""
for path in "${JDK11_LOCATIONS[@]}"; do
    if [ -d "$path" ] && [ -f "$path/bin/java" ]; then
        JDK11_PATH="$path"
        break
    fi
done

if [ -z "$JDK11_PATH" ]; then
    echo -e "${YELLOW}Warning: Could not auto-detect JDK 11 installation${NC}"
    echo "Please ensure JDK 11 is installed and set JAVA_HOME manually:"
    echo "  export JAVA_HOME=/path/to/jdk-11"
    echo "  ./gradlew assembleRelease"
    echo ""
    echo "Or install JDK 11:"
    echo "  - macOS: brew install openjdk@11"
    echo "  - Ubuntu/Debian: sudo apt install openjdk-11-jdk"
    echo "  - Download: https://adoptium.net/temurin/releases/?version=11"
    exit 1
fi

# Set JAVA_HOME
export JAVA_HOME="$JDK11_PATH"
echo -e "${GREEN}✓ Using JDK 11: $JAVA_HOME${NC}"
echo ""

# Verify Java version
JAVA_VERSION=$("$JAVA_HOME/bin/java" -version 2>&1 | head -n 1)
echo "Java version: $JAVA_VERSION"
echo ""

# Stop any existing Gradle daemons to ensure clean state
echo "Stopping existing Gradle daemons..."
./gradlew --stop
echo ""

# Run the build
echo "Building APK..."
echo "Command: ./gradlew clean assembleRelease"
echo ""

./gradlew clean assembleRelease "$@"

BUILD_EXIT_CODE=$?

echo ""
if [ $BUILD_EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}✓ Build successful!${NC}"
    echo ""
    echo "APK locations:"
    echo "  - build/outputs/apk/release/"
    if [ -f "../Output/app.apk" ]; then
        echo "  - ../Output/app.apk (automatic copy)"
        echo ""
        echo "Install on device:"
        echo "  adb install ../Output/app.apk"
    fi
else
    echo "Build failed with exit code $BUILD_EXIT_CODE"
    echo ""
    echo "Troubleshooting:"
    echo "  1. Check Java version: java -version"
    echo "  2. Verify Android SDK: check local.properties"
    echo "  3. Review error logs above"
    echo "  4. See BUILD_SETUP.md for detailed setup instructions"
fi
echo ""

exit $BUILD_EXIT_CODE
