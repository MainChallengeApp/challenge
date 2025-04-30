# Challenge

The app for finding new challenges, tracking and completing them!

## Contents

1. [Getting Started](#getting-started)
2. [Setup Emulator](#setup-emulator)
3. [Testing](#testing)
   1. [Run all tests](#run-all-tests)
   2. [Run all tests in watch mode](#run-all-tests-in-watch-mode)
   3. [Upload to TestFlight](#upload-to-testflight)
4. [Updating Version](#updating-version)
5. [Release new Version](#release-new-version)
   1. [Apple AppStore](#apple-appstore)
   2. [Google PlayStore](#google-playstore)
6. [CI/CD or just Pipelines](#cicd-or-just-pipelines)
7. [Adding an Index](#adding-an-index)
8. [Common Errors](#common-errors)
   1. [Module 'camera_avfoundation' not found](#module-camera_avfoundation-not-found)

## Getting Started

1. git clone
2. install recommended vs code extensions
3. run `copy .env.local .env` and fill out credentials
4. install flutter
5. run `npm install -g firebase-tools` to install firebase
6. run `firebase login`to login into firebase
7. run `dart pub global activate flutterfire_cli` to install flutterfire
8. run `flutterfire configure` to configure the Firebase project
9. [setup firebase emulator](#setup-emulator)
10. open and select iPhone Simulator
11. run `flutter run`

## Setup Emulator

1. run `cd firebase`
2. run `npm i`
3. run `npm run generate:firestore:rules`
4. run `npm emulator:reset`
5. run `cd functions`
6. run `npm i`
7. run `npm run build`
8. run `cd ..`
9. run `npm run emulator`

## Testing

### Run all test

run `flutter test`

### Run all tests in watch mode (workaround)

run `./scripts/test_watch.sh`

### Upload to TestFlight

1. [update the version](#updating-version)
2. push to test

## Updating Version

1. run `./scripts/update_version.sh <'major' | 'minor' | 'patch'| 'build'>`

## Release new Version

### Apple AppStore

1. [update the version](#updating-version)
2. push to prod
3. login to [AppStore Connect](https://appstoreconnect.apple.com/)
4. create new version
5. select the new build version (this can take a while)
6. adjust every other field

### Google PlayStore

1. to be implemented...

## CI/CD or just Pipelines

We use [CodeMagic](https://codemagic.io/)

## Adding an Index

Firebase throws an error if an index is needed. The error contains a link to create the index. After creation run:

1. `cd firebase`
2. `firebase login`
3. `firebase use dev`
4. `firebase firestore:indexes > firestore.indexes.json`
5. `firebase deploy --only firestore:indexes --project=test`
6. `firebase deploy --only firestore:indexes --project=prod`

## Common Errors

### Module 'camera_avfoundation' not found

> This error appears sometimes in Xcode.

first: try opening the xcode project with the file **ios/Runner.xcworkspace**.

else: [StackOverflow](https://stackoverflow.com/questions/76595364/flutter-parse-issue-xcode-module-camera-avfoundation-not-found)

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
