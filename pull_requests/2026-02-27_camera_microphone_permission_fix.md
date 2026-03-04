### Pull Request Title
[WIP] Camera and Microphone Permissions Fix

### Description
This pull request fixes issues related to dynamic permission handling and API compatibility for the camera and microphone modules. Changes include:
- Implemented runtime permission requests for `CAMERA` and `RECORD_AUDIO`.
- Migrated Camera API usage from deprecated `android.hardware.Camera` to `Camera2` for better compatibility.
- Improved logging and error handling for SMS and Contacts modules.

Additional improvements were made for better Android 6+ support.