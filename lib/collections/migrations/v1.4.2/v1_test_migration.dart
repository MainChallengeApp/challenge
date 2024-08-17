import 'dart:developer';

import 'package:challenge/collections/migrations/migration.dart';
import 'package:challenge/collections/users_collection.dart';
import 'package:challenge/models/user/user_model.dart';

class TestMigration extends Migration {
  TestMigration()
      : super(migrationNumber: 1, description: 'Create users table');

  @override
  Future<void> run() async {
    var usersDatabase = UsersCollection();
    List<UserModel> users = await usersDatabase.getAll();
    log(users.map((u) => u.email).toString());
  }
}
