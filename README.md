# challenge

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## useful links

- Module 'camera_avfoundation' not found
  - https://stackoverflow.com/questions/76595364/flutter-parse-issue-xcode-module-camera-avfoundation-not-found
    Backup the current native folders(renaming./android and ./iOS)
    Close Xcode
    Go to the root folder and run flutter create . (this will generate the native folders)
    Now your new profile contains all you need.
    Open Podfile and uncomment platform:ios,'11'. set it to 12
    Open the .workspace of the ./iOS
    Set the signing & capabilities
    Set deployment version
    Add to Info.plist
    <key>NSCameraUsageDescription</key>
    <string>We need access to your camera to take photos and videos.</string>
    <key>NSMicrophoneUsageDescription</key>
    <string>We need access to your microphone for voice recording and audio features.</string>
    Set App Icons
    Run flutter build iOS
    Then finally run flutter build ipa
