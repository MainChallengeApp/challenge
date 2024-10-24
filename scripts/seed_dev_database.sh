#!/bin/bash
xcrun simctl boot "iPhone 16"
flutter run -d "iPhone 16" lib/collections/seeds/seed_dev_database.dart
xcrun simctl shutdown "iPhone 16"
