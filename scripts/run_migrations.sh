#!/bin/bash
xcrun simctl boot "macos"
flutter run -d "macos" lib/collections/migrations/run_migrations.dart --dart-define=MIGRATION_USER_EMAIL=$MIGRATION_USER_EMAIL --dart-define=MIGRATION_USER_PASSWORD=$MIGRATION_USER_PASSWORD
xcrun simctl shutdown "macos"
