#!/bin/bash
xcrun simctl boot "iPhone 14"
flutter run -d "iPhone 14" lib/database/migrations/run_migrations.dart
xcrun simctl shutdown "iPhone 14"
