import 'dart:developer';

import 'package:challenge/database/migrations/migration_model.dart';

class TestCiCdMigration extends MigrationModel {
  TestCiCdMigration()
      : super(migrationNumber: 6, description: 'test ci cd migration');

  @override
  Future<void> run() async {
    log('${DateTime.now()}] test ci cd migration');
  }
}
