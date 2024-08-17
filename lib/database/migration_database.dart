import 'package:challenge/database/database.dart';
import 'package:challenge/database/migrations/migration.dart';

class MigrationDatabase extends Database {
  MigrationDatabase() : super(collection: 'migrations');

  Future<void> create(Migration migration) async {
    await db.collection(collection).add(migration.toDoc());
  }

  Future<int> getNewestMigrationNumber() async {
    try {
      final querySnapshot = await db
          .collection(collection)
          .orderBy('migrationNumber', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return 0;
      }

      return querySnapshot.docs
          .map((doc) => Migration.fromDoc(doc))
          .first
          .migrationNumber;
    } on Exception {
      rethrow;
    }
  }
}
