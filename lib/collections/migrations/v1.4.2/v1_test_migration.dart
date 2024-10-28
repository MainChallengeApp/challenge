import 'package:challenge/collections/migrations/migration.dart';

class TestMigration extends Migration {
  TestMigration()
      : super(
            migrationNumber: 1,
            description: 'Create users table',
            appVersion: '1.5.3');

  @override
  Future<void> run() async {
    // var usersDatabase = UsersCollection();
    // List<UserModel> users = await usersDatabase.getAll();
    // log(users.map((u) => u.email).toString());
  }
}
