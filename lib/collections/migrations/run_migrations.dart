import 'dart:developer';
import 'dart:io';

import 'package:challenge/collections/migration_collection.dart';
import 'package:challenge/collections/migrations/migration.dart';
import 'package:challenge/collections/migrations/v1.4.7/v1_use_thumbnail_model.dart';
import 'package:challenge/dotenv.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/services/backend_service.dart';

List<Migration> migrationScripts = [V1UseThumbnailModel()];

MigrationCollection migrationCollection = MigrationCollection();

Future<void> main() async {
  log('[${DateTime.now()}]: start database migration...');

  await BackendService.initializeBackend();

  Dotenv dotenv = await Dotenv.create();
  var authService = AuthService();
  await authService.loginEmailPassword(
      dotenv.migrationUserEmail, dotenv.migrationUserPassword);

  await filterMigrationsToRun();

  for (var migrationScript in migrationScripts) {
    log('[${DateTime.now()}]: running migration script ${migrationScript.migrationNumber}: ${migrationScript.description}');
    await migrationScript.run();
    migrationScript.createdAt = DateTime.now();
    await migrationCollection.create(migrationScript);
  }

  log('[${DateTime.now()}] end database migration');
  exit(0);
}

filterMigrationsToRun() async {
  int newestMigrationNumber =
      await migrationCollection.getNewestMigrationNumber();

  log('[${DateTime.now()}]: newestMigrationNumber is $newestMigrationNumber');
  migrationScripts
      .sort((a, b) => a.migrationNumber.compareTo(b.migrationNumber));
  migrationScripts.removeWhere(
      (migration) => migration.migrationNumber <= newestMigrationNumber);

  if (migrationScripts.isEmpty) {
    log('[${DateTime.now()}]: no migration scripts to run.');
    exit(0);
  }
}
