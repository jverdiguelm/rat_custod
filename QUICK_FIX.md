# Quick Start Guide - Fixing the Build Error

## The Problem

When building the Android APK, you encountered this error:

```
Execution failed for task ':app:processReleaseMainManifest'.
> Unable to make field private final java.lang.String java.io.File.path accessible: 
  module java.base does not "opens java.io" to unnamed module
```

## The Solution (TL;DR)

**Use JDK 11 instead of JDK 17+**

## Quick Fix Steps

### Option 1: Use the Build Script (Easiest)

```bash
cd rat-Client
./build-apk.sh
```

Done! The script handles everything automatically.

### Option 2: Set JAVA_HOME Manually

```bash
# Install JDK 11 if you don't have it
# macOS:
brew install openjdk@11

# Ubuntu/Debian:
sudo apt install openjdk-11-jdk

# Then build:
cd rat-Client
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64  # Adjust path for your system
./gradlew clean assembleRelease
```

### Option 3: Update gradle.properties (Already Done)

The project already has this configured in `rat-Client/gradle.properties`:

```properties
org.gradle.java.home=/usr/lib/jvm/temurin-11-jdk-amd64
```

Just update the path to match your JDK 11 installation, then:

```bash
cd rat-Client
./gradlew --stop  # Stop any old daemons
./gradlew clean assembleRelease
```

## Why This Happens

| Component | Version | Issue |
|-----------|---------|-------|
| Your JDK | 17 or higher | Has strict module encapsulation |
| Android Gradle Plugin | 4.1.3 | Uses reflection to access internal APIs |
| Result | ❌ | Reflection blocked by Java module system |

**Solution**: Use JDK 11 or JDK 8, which don't have these restrictions.

## Verify Your Setup

Run this to check your configuration:

```bash
cd rat-Client
java -version           # Should show 11.x or 1.8.x
./gradlew --version     # Check what JDK Gradle will use
```

## Finding Your JDK Installation

### macOS
```bash
# Homebrew installations
ls /usr/local/opt/openjdk@*/

# System installations
/usr/libexec/java_home -V
```

### Linux
```bash
ls /usr/lib/jvm/
```

### Windows
```
C:\Program Files\Eclipse Adoptium\jdk-11.*
C:\Program Files\Java\jdk-11.*
```

## Still Having Issues?

1. **Check your local.properties**: 
   ```bash
   cat rat-Client/local.properties
   # Should have: sdk.dir=/path/to/android/sdk
   ```

2. **Clear Gradle cache**:
   ```bash
   cd rat-Client
   ./gradlew --stop
   rm -rf ~/.gradle/caches/
   ./gradlew clean
   ```

3. **Check detailed logs**:
   ```bash
   cd rat-Client
   ./gradlew assembleRelease --stacktrace --info
   ```

## More Information

- **Detailed Setup**: See [BUILD_SETUP.md](BUILD_SETUP.md)
- **Troubleshooting**: See README.md → Troubleshooting section
- **Test Your Setup**: Run `./test-build-setup.sh`

## Expected Output

When building successfully:

```
BUILD SUCCESSFUL in 2m 15s
45 actionable tasks: 45 executed

✓ Build successful!

APK locations:
  - build/outputs/apk/release/app-release.apk
  - ../Output/app.apk (automatic copy)

Install on device:
  adb install ../Output/app.apk
```

## Summary

The build error is caused by JDK 17's module system restrictions. The fix is simple: **use JDK 11**. The project has been configured to handle this automatically, but you need to ensure JDK 11 is installed on your system.
