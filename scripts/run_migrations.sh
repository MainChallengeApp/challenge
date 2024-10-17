#!/bin/bash
xcrun simctl list devices
xcrun simctl boot "iPhone 16"
flutter run -d "iPhone 16" lib/collections/migrations/run_migrations.dart --dart-define=MIGRATION_USER_EMAIL=$MIGRATION_USER_EMAIL --dart-define=MIGRATION_USER_PASSWORD=$MIGRATION_USER_PASSWORD
xcrun simctl shutdown "iPhone 16"
