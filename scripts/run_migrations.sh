#!/bin/bash
xcrun simctl boot "iPhone 14"
flutter run -d "iPhone 14" lib/collections/migrations/run_migrations.dart --dart-define=MIGRATION_USER_EMAIL=$MIGRATION_USER_EMAIL --dart-define=MIGRATION_USER_PASSWORD=$MIGRATION_USER_PASSWORD
xcrun simctl shutdown "iPhone 14"
