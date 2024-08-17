// ignore_for_file: avoid_print

import 'dart:developer';
import 'dart:io';

import 'package:challenge/database/migrations/migration_database.dart';
import 'package:challenge/database/migrations/migration_model.dart';
import 'package:challenge/database/migrations/v1.4.2/v1_test_migration.dart';
import 'package:challenge/database/migrations/v1.4.2/v2_test_2_migration.dart';
import 'package:challenge/database/migrations/v1.4.2/v3_change_end_date_type_migration.dart';
import 'package:challenge/database/migrations/v1.4.2/v4_change_search_challenge_date_types_migration.dart';
import 'package:challenge/database/migrations/v1.4.2/v5_remove_start_data_from_search_challenges.dart';
import 'package:challenge/database/migrations/v1.4.2/v6_test_ci_cd_migration.dart';
import 'package:challenge/services/backend_service.dart';

List<MigrationModel> migrationScripts = [
  TestMigration(),
  Test2Migration(),
  ChangeEndDateTypeMigration(),
  ChangeSearchChallengeDateTypesMigration(),
  RemoveStartDataFromSearchChallenges(),
  TestCiCdMigration()
];

void main() async {
  log('[${DateTime.now()}]: start database migration...');

  await BackendService.initializeBackend();

  MigrationDatabase migrationDatabase = MigrationDatabase();
  int newestMigrationNumber =
      await migrationDatabase.getNewestMigrationNumber();

  log('newestMigrationNumber: $newestMigrationNumber');
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
