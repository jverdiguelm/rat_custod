# Build Setup Guide for RAT Custod Android Client

This guide provides detailed instructions for setting up and building the Android client (`rat-Client`) for the RAT Custod project.

## Problem and Solution

### The Issue

When building the Android APK, you may encounter this error:

```
Execution failed for task ':app:processReleaseMainManifest'.
> Unable to make field private final java.lang.String java.io.File.path accessible: 
  module java.base does not "opens java.io" to unnamed module @a2623d9
```

### Root Cause

This error occurs due to incompatibility between:
- **JDK version**: JDK 17+ has strict module encapsulation
- **Android Gradle Plugin**: Version 4.1.3 used in this project
- **Gradle version**: 7.0

The Android Gradle Plugin 4.1.3 uses reflection to access internal Java APIs, which is restricted in JDK 17 and higher due to the Java Platform Module System (JPMS).

### Solution

Use **JDK 11** (or JDK 8) instead of JDK 17+. This project has been configured to use JDK 11 automatically.

## Prerequisites

### Required Software

1. **Java Development Kit (JDK) 11**
   - Download: [Eclipse Temurin 11](https://adoptium.net/temurin/releases/?version=11)
   - Alternative: Oracle JDK 11 or OpenJDK 11
   - **Note**: JDK 8 also works, but JDK 11 is recommended

2. **Android SDK**
   - Install via [Android Studio](https://developer.android.com/studio) or
   - Install command-line tools: [SDK Command-line Tools](https://developer.android.com/studio#command-tools)

3. **Gradle 7.0**
   - Included via Gradle Wrapper (no separate installation needed)

### Compatibility Matrix

| Component | Version | Compatible JDK |
|-----------|---------|----------------|
| Android Gradle Plugin | 4.1.3 | JDK 8, 11 |
| Gradle | 7.0 | JDK 8-16 |
| Target SDK | 30 | JDK 8+ |
| **Recommended** | - | **JDK 11** |

## Setup Instructions

### 1. Install and Configure JDK 11

#### On macOS (using Homebrew)
```bash
# Install JDK 11
brew install openjdk@11

# Set JAVA_HOME
echo 'export JAVA_HOME=/usr/local/opt/openjdk@11' >> ~/.zshrc
source ~/.zshrc
```

#### On Linux (Ubuntu/Debian)
```bash
# Install JDK 11
sudo apt update
sudo apt install openjdk-11-jdk

# Set JAVA_HOME
echo 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64' >> ~/.bashrc
source ~/.bashrc
```

#### On Windows
1. Download and install JDK 11 from [Adoptium](https://adoptium.net/)
2. Set `JAVA_HOME` environment variable:
   - Open System Properties → Advanced → Environment Variables
   - Add new System Variable: `JAVA_HOME` = `C:\Program Files\Eclipse Adoptium\jdk-11.x.x.x`
   - Add to Path: `%JAVA_HOME%\bin`

#### Verify Installation
```bash
java -version
# Expected output: openjdk version "11.0.x" or similar
```

### 2. Install and Configure Android SDK

#### Using Android Studio (Recommended)
1. Download and install [Android Studio](https://developer.android.com/studio)
2. Open Android Studio and go to SDK Manager
3. Install:
   - Android SDK Platform 30
   - Android SDK Build-Tools 30.0.x
   - Android SDK Platform-Tools

#### Using Command-Line Tools
```bash
# Download command-line tools from:
# https://developer.android.com/studio#command-tools

# Extract and set up
unzip commandlinetools-*.zip
mkdir -p ~/Android/Sdk/cmdline-tools/latest
mv cmdline-tools/* ~/Android/Sdk/cmdline-tools/latest/

# Install required components
~/Android/Sdk/cmdline-tools/latest/bin/sdkmanager "platform-tools" "platforms;android-30" "build-tools;30.0.3"
```

#### Set Environment Variables
```bash
# Add to ~/.bashrc or ~/.zshrc (Linux/macOS) or System Environment Variables (Windows)
export ANDROID_HOME=~/Android/Sdk
export ANDROID_SDK_ROOT=~/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools
```

### 3. Configure Project

#### Create/Update local.properties
Navigate to `rat-Client/` directory and create or update `local.properties`:

```bash
cd rat-Client
echo "sdk.dir=/path/to/your/android/sdk" > local.properties
```

Replace `/path/to/your/android/sdk` with your actual Android SDK path:
- macOS: `~/Library/Android/sdk` or `~/Android/Sdk`
- Linux: `~/Android/Sdk`
- Windows: `C:\\Users\\YourUsername\\AppData\\Local\\Android\\Sdk`

#### Verify gradle.properties Configuration
The `rat-Client/gradle.properties` file is already configured with:

```properties
# Configure Gradle to use JDK 11 for compatibility
org.gradle.java.home=/usr/lib/jvm/temurin-11-jdk-amd64
```

**Note**: Update this path to match your JDK 11 installation location if different.

## Building the APK

### Method 1: Using Gradle Wrapper (Recommended)

```bash
# Navigate to client directory
cd rat-Client

# Clean previous builds
./gradlew clean

# Build release APK
./gradlew assembleRelease

# The APK will be generated at:
# - build/outputs/apk/release/app-release.apk
# - And copied to: ../Output/app.apk (if build succeeds)
```

### Method 2: Using Android Studio

1. Open Android Studio
2. Open the `rat-Client` folder as a project
3. Wait for Gradle sync to complete
4. Build → Build Bundle(s) / APK(s) → Build APK(s)
5. Or click the "Run" button to build and install directly to a connected device

### Method 3: With Custom JDK Path

If you want to override the JDK without modifying gradle.properties:

```bash
JAVA_HOME=/path/to/jdk-11 ./gradlew assembleRelease
```

## Troubleshooting

### Error: "Unable to make field private final java.lang.String java.io.File.path accessible"

**Cause**: Using JDK 17 or higher

**Solution**:
1. Install JDK 11 (see Section 1)
2. Set `JAVA_HOME` environment variable to JDK 11 path
3. Or update `org.gradle.java.home` in `rat-Client/gradle.properties`
4. Run `./gradlew --stop` to stop any running Gradle daemons
5. Try building again

### Error: "SDK location not found"

**Cause**: Android SDK not properly configured

**Solution**:
1. Create/update `rat-Client/local.properties` with correct `sdk.dir`
2. Verify `ANDROID_HOME` environment variable is set
3. Ensure Android SDK is actually installed at the specified location

### Error: "Could not resolve com.android.tools.build:gradle:4.1.3"

**Cause**: Network connectivity issues or Maven repository unavailable

**Solution**:
1. Check internet connection
2. Try building with VPN if behind a firewall
3. Check if `jcenter()` and `google()` repositories are accessible
4. Consider updating to a newer Android Gradle Plugin version (may require Gradle upgrade)

### Build succeeds but APK fails to install

**Cause**: Signing configuration or device compatibility

**Solution**:
1. Check keystore configuration in `app/build.gradle`
2. Ensure device API level >= 21 (Android 5.0)
3. Enable "Install from unknown sources" on device
4. Check logcat for detailed error: `adb logcat | grep -i error`

### Gradle Daemon issues

If you encounter strange build issues:

```bash
# Stop all Gradle daemons
./gradlew --stop

# Clear Gradle caches
rm -rf ~/.gradle/caches/

# Try building again
./gradlew clean assembleRelease
```

## Build Options

### Debug Build
```bash
./gradlew assembleDebug
```
- Not signed for release
- Includes debugging information
- Faster build time

### Release Build
```bash
./gradlew assembleRelease
```
- Signed with release keystore
- Optimized and minified (if configured)
- Production-ready

### Build with Specific Configuration
```bash
# Build with stack trace for debugging
./gradlew assembleRelease --stacktrace

# Build with detailed info
./gradlew assembleRelease --info

# Build with debug logging
./gradlew assembleRelease --debug

# Build offline (using cached dependencies)
./gradlew assembleRelease --offline
```

## Customizing the Build

### Updating Server Configuration

To change the default server IP/port in the APK:

1. Edit `rat-Client/app/src/main/AndroidManifest.xml`
2. Find and update:
   ```xml
   <meta-data android:name="SERVER_IP" android:value="your.server.ip" />
   <meta-data android:name="SERVER_PORT" android:value="8000" />
   ```
3. Rebuild the APK

**Note**: With dynamic configuration enabled, the client will fetch the latest config from the server, so these are fallback values.

### Changing Package Name

To avoid conflicts with other apps:

1. Edit `rat-Client/app/build.gradle`
2. Change `applicationId`:
   ```gradle
   defaultConfig {
       applicationId "com.yourcompany.yourapp"
       // ...
   }
   ```
3. Rename Java package directories to match
4. Update all Java files with new package declaration

## Verification

After building, verify the APK:

```bash
# Check APK exists
ls -lh build/outputs/apk/release/

# Get APK info
aapt dump badging build/outputs/apk/release/app-release.apk

# Verify APK signature
jarsigner -verify -verbose -certs build/outputs/apk/release/app-release.apk
```

## Additional Resources

- [Android Gradle Plugin Release Notes](https://developer.android.com/studio/releases/gradle-plugin)
- [Gradle User Manual](https://docs.gradle.org/current/userguide/userguide.html)
- [Android Build Configuration](https://developer.android.com/studio/build)
- [JDK 11 Documentation](https://docs.oracle.com/en/java/javase/11/)

## Support

If you continue to experience build issues:

1. Review the complete build log: `./gradlew assembleRelease --stacktrace --info > build.log`
2. Check that all prerequisites are correctly installed
3. Verify version compatibility
4. Check GitHub issues for similar problems
5. Create a new issue with:
   - Your OS and version
   - Java version (`java -version`)
   - Android SDK version
   - Complete error message and stack trace
