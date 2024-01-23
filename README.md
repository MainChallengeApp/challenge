# Challenge

The app for finding new challenges, tracking and completing them!

## Getting Started

1. install flutter
2. run `flutter run`

## Testing

1. run `flutter test`

## Common Errors

### Module 'camera_avfoundation' not found

> This error appears sometimes in Xcode.

first: try opening the xcode project with the file **ios/Runner.xcworkspace**.

else: https://stackoverflow.com/questions/76595364/flutter-parse-issue-xcode-module-camera-avfoundation-not-found

- Backup the current native folders(renaming./android and ./iOS)
- Close Xcode
- Go to the root folder and run flutter create . (this will generate the native folders)
- Now your new profile contains all you need.
- Open Podfile and uncomment platform:ios,'11'. set it to 12
- Open the .workspace of the ./iOS
- Set the signing & capabilities
- Set deployment version
- Add to Info.plist
  - \<key>NSCameraUsageDescription\</key>
  - \<string>We need access to your camera to take photos and videos.\</string>
  - \<key>NSMicrophoneUsageDescription\</key>
  - \<string>We need access to your microphone for voice recording and audio features.\</string>
- Set App Icons
- Run flutter build iOS
- Then finally run flutter build ipa
