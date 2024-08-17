#!/bin/bash
xcrun simctl boot "iPhone 14"
flutter run -d "iPhone 14" lib/collections/seeds/seed_dev_database.dart
xcrun simctl shutdown "iPhone 14"
