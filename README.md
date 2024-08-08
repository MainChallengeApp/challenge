# Challenge

The app for finding new challenges, tracking and completing them!

## Getting Started

1. install flutter
2. run `flutterfire configure` to configure the Firebase project
3. run `flutter run`

## Testing

### Run all test

run `flutter test`

### Run all tests in watch mode (workaround)

run `./scripts/test_watch.sh`

## Updating Version

1. run `./scripts/update_version.sh <'major' | 'minor' | 'patch'| 'build'>`

## Release new Version

### Apple AppStore

1. open the project in Xcode
2. select 'Any iOS Device (arm64)' as Runner
3. click on Product>Archive
4. click through and wait till its done
5. login to https://appstoreconnect.apple.com/
6. create new version
7. select the new build version (this can take a while)
8. adjust every other field

### Google PlayStore

1. to be implemented...

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
