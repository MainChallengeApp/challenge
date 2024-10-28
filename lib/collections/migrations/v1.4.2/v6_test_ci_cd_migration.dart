import 'dart:developer';

import 'package:challenge/collections/migrations/migration.dart';

class TestCiCdMigration extends Migration {
  TestCiCdMigration()
      : super(
            migrationNumber: 6,
            description: 'test ci cd migration',
            appVersion: '1.5.3');

  @override
  Future<void> run() async {
    log('${DateTime.now()}] test ci cd migration');
  }
}
