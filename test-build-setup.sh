#!/bin/bash
# Test script to verify JDK configuration for rat-Client build
# This script validates that the build environment is properly configured

set -e

echo "======================================"
echo "RAT Custod Build Environment Test"
echo "======================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Change to client directory
cd "$(dirname "$0")/rat-Client" || exit 1

echo "1. Checking Java Version..."
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | head -n 1)
    echo "   Found: $JAVA_VERSION"
    
    # Check if it's JDK 11 or 8
    if echo "$JAVA_VERSION" | grep -q "11\."; then
        echo -e "   ${GREEN}✓${NC} Using JDK 11 (Recommended)"
    elif echo "$JAVA_VERSION" | grep -q "1\.8"; then
        echo -e "   ${GREEN}✓${NC} Using JDK 8 (Compatible)"
    else
        echo -e "   ${YELLOW}⚠${NC} Warning: Not using JDK 11 or 8. Build may fail with JDK 17+"
    fi
else
    echo -e "   ${RED}✗${NC} Java not found in PATH"
    exit 1
fi
echo ""

echo "2. Checking JAVA_HOME..."
if [ -n "$JAVA_HOME" ]; then
    echo "   JAVA_HOME: $JAVA_HOME"
    if [ -f "$JAVA_HOME/bin/java" ]; then
        echo -e "   ${GREEN}✓${NC} JAVA_HOME is valid"
    else
        echo -e "   ${RED}✗${NC} JAVA_HOME does not point to a valid JDK"
    fi
else
    echo -e "   ${YELLOW}⚠${NC} JAVA_HOME not set (will use gradle.properties configuration)"
fi
echo ""

echo "3. Checking gradle.properties..."
if [ -f "gradle.properties" ]; then
    if grep -q "org.gradle.java.home" gradle.properties; then
        GRADLE_JAVA_HOME=$(grep "org.gradle.java.home" gradle.properties | cut -d'=' -f2)
        echo "   org.gradle.java.home: $GRADLE_JAVA_HOME"
        if [ -f "$GRADLE_JAVA_HOME/bin/java" ]; then
            GRADLE_JAVA_VERSION=$("$GRADLE_JAVA_HOME/bin/java" -version 2>&1 | head -n 1)
            echo "   Version: $GRADLE_JAVA_VERSION"
            echo -e "   ${GREEN}✓${NC} Gradle will use configured JDK"
        else
            echo -e "   ${RED}✗${NC} Configured JDK path not found"
            echo "   Please update org.gradle.java.home in gradle.properties"
        fi
    else
        echo -e "   ${YELLOW}⚠${NC} org.gradle.java.home not configured"
        echo "   Will use system Java ($JAVA_VERSION)"
    fi
else
    echo -e "   ${RED}✗${NC} gradle.properties not found"
fi
echo ""

echo "4. Checking Android SDK..."
if [ -f "local.properties" ]; then
    SDK_DIR=$(grep "sdk.dir" local.properties | cut -d'=' -f2)
    echo "   SDK Location: $SDK_DIR"
    if [ -d "$SDK_DIR" ]; then
        echo -e "   ${GREEN}✓${NC} Android SDK found"
    else
        echo -e "   ${RED}✗${NC} Android SDK not found at specified location"
        echo "   Please update sdk.dir in local.properties"
    fi
else
    echo -e "   ${YELLOW}⚠${NC} local.properties not found"
    if [ -n "$ANDROID_HOME" ]; then
        echo "   Will try using ANDROID_HOME: $ANDROID_HOME"
    elif [ -n "$ANDROID_SDK_ROOT" ]; then
        echo "   Will try using ANDROID_SDK_ROOT: $ANDROID_SDK_ROOT"
    else
        echo -e "   ${RED}✗${NC} No Android SDK configuration found"
    fi
fi
echo ""

echo "5. Checking Gradle Wrapper..."
if [ -f "gradlew" ]; then
    echo -e "   ${GREEN}✓${NC} Gradle wrapper found"
    if [ -x "gradlew" ]; then
        echo -e "   ${GREEN}✓${NC} Gradle wrapper is executable"
    else
        echo -e "   ${YELLOW}⚠${NC} Gradle wrapper is not executable"
        echo "   Run: chmod +x gradlew"
    fi
    
    # Check Gradle version
    echo "   Checking Gradle version..."
    GRADLE_VERSION=$(./gradlew --version 2>&1 | grep "Gradle " | head -n 1)
    echo "   $GRADLE_VERSION"
else
    echo -e "   ${RED}✗${NC} Gradle wrapper not found"
fi
echo ""

echo "6. Checking build.gradle configuration..."
if [ -f "build.gradle" ]; then
    AGP_VERSION=$(grep "com.android.tools.build:gradle:" build.gradle | grep -oP "[\d\.]+")
    echo "   Android Gradle Plugin: $AGP_VERSION"
    if [ "$AGP_VERSION" == "4.1.3" ]; then
        echo -e "   ${GREEN}✓${NC} AGP 4.1.3 requires JDK 8 or 11"
    fi
else
    echo -e "   ${RED}✗${NC} build.gradle not found"
fi
echo ""

echo "======================================"
echo "Summary"
echo "======================================"
echo ""
echo "Configuration for this project:"
echo "  - Gradle: 7.0"
echo "  - Android Gradle Plugin: 4.1.3"
echo "  - Required JDK: 11 or 8"
echo "  - Target SDK: 30"
echo ""
echo "To build the APK:"
echo "  cd rat-Client"
echo "  ./gradlew clean assembleRelease"
echo ""
echo "The APK will be generated at:"
echo "  build/outputs/apk/release/app-release.apk"
echo "  ../Output/app.apk (automatic copy)"
echo ""
