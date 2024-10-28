import 'dart:io';

import 'package:challenge/collections/migration_collection.dart';
import 'package:challenge/collections/migrations/migration.dart';
import 'package:challenge/collections/migrations/v1.4.14/v2_add_title_lower_case_search_challenges.dart';
import 'package:challenge/collections/migrations/v1.4.14/v3_add_title_lower_case_user_challenges.dart';
import 'package:challenge/collections/migrations/v1.4.7/v1_use_thumbnail_model.dart';
import 'package:challenge/collections/migrations/v1.5/v4_connections_and_blocked.dart';
import 'package:challenge/collections/migrations/v1.5/v5_add_app_version_to_migrations.dart';
import 'package:challenge/dotenv.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/services/backend_service.dart';
import 'package:flutter/material.dart';

List<Migration> migrationScripts = [
  V1UseThumbnailModel(),
  V2AddTitleLowerCaseSearchChallenges(),
  V3AddTitleLowerCaseUserChallenges(),
  V4ConnectionsAndBlocked(),
  V5AddAppVersionToMigrations(),
];

MigrationCollection migrationCollection = MigrationCollection();

Future<void> main() async {
  try {
    debugPrint('[${DateTime.now()}]: start database migration...');

    await BackendService.initializeBackend();

    Dotenv dotenv = await Dotenv.create();
    var authService = AuthService();
    await authService.loginEmailPassword(
        dotenv.migrationUserEmail, dotenv.migrationUserPassword);

    await filterMigrationsToRun();

    for (var migrationScript in migrationScripts) {
      debugPrint(
          '[${DateTime.now()}]: running migration script ${migrationScript.migrationNumber}: ${migrationScript.description}');
      await migrationScript.run();
      migrationScript.createdAt = DateTime.now();
      await migrationCollection.create(migrationScript);
    }

    debugPrint('[${DateTime.now()}] end database migration');
  } finally {
    exit(0);
  }
}

filterMigrationsToRun() async {
  int newestMigrationNumber = 0;
  Migration? newestMigration = await migrationCollection.getNewestMigration();
  if (newestMigration != null) {
    newestMigrationNumber = newestMigration.migrationNumber;
  }

  debugPrint(
      '[${DateTime.now()}]: newestMigrationNumber is $newestMigrationNumber');
  migrationScripts
      .sort((a, b) => a.migrationNumber.compareTo(b.migrationNumber));
  migrationScripts.removeWhere(
      (migration) => migration.migrationNumber <= newestMigrationNumber);

  if (migrationScripts.isEmpty) {
    debugPrint('[${DateTime.now()}]: no migration scripts to run.');
    exit(0);
  }
}
