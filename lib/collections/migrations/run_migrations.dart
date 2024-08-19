import 'dart:developer';
import 'dart:io';

import 'package:challenge/collections/migration_collection.dart';
import 'package:challenge/collections/migrations/migration.dart';
import 'package:challenge/collections/migrations/v1.4.2/v1_test_migration.dart';
import 'package:challenge/collections/migrations/v1.4.2/v2_test_2_migration.dart';
import 'package:challenge/collections/migrations/v1.4.2/v3_change_end_date_type_migration.dart';
import 'package:challenge/collections/migrations/v1.4.2/v4_change_search_challenge_date_types_migration.dart';
import 'package:challenge/collections/migrations/v1.4.2/v5_remove_start_data_from_search_challenges.dart';
import 'package:challenge/collections/migrations/v1.4.2/v6_test_ci_cd_migration.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/services/backend_service.dart';

List<Migration> migrationScripts = [
  TestMigration(),
  Test2Migration(),
  ChangeEndDateTypeMigration(),
  ChangeSearchChallengeDateTypesMigration(),
  RemoveStartDataFromSearchChallenges(),
  TestCiCdMigration()
];

Future<void> main() async {
  log('[${DateTime.now()}]: start database migration...');

  await BackendService.initializeBackend();

  // TODO: create migration users for dev, test and prod
  // and add there credentials to .env and code magic security env vars
  // and add .env to .gitignore
  // and adjust uid in firebase security rules
  var authService = AuthService();
  await authService.loginEmailPassword(
      'migration@user.db', 'migration@user.db');

  MigrationCollection migrationDatabase = MigrationCollection();
  int newestMigrationNumber =
      await migrationDatabase.getNewestMigrationNumber();

  log('[${DateTime.now()}]: newestMigrationNumber is $newestMigrationNumber');
  migrationScripts
      .sort((a, b) => a.migrationNumber.compareTo(b.migrationNumber));
  migrationScripts.removeWhere(
      (migration) => migration.migrationNumber <= newestMigrationNumber);

  if (migrationScripts.isEmpty) {
    log('[${DateTime.now()}]: no migration scripts to run.');
    exit(0);
  }

  for (var migration in migrationScripts) {
    log('[${DateTime.now()}]: running migration script ${migration.migrationNumber}: ${migration.description}');
    await migration.run();
    migration.createdAt = DateTime.now();
    await migrationDatabase.create(migration);
  }

  log('[${DateTime.now()}] end database migration');
  exit(0);
}
