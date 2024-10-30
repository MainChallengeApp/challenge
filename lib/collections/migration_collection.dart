import 'package:challenge/collections/collection.dart';
import 'package:challenge/collections/migrations/migration.dart';

class MigrationCollection extends Collection {
  static String collectionName = 'migrations';
  MigrationCollection() : super(name: collectionName);

  Future<void> create(Migration migration) async {
    await db.collection(name).add(migration.toDoc());
  }

  Future<Migration> getNewestMigration() async {
    try {
      final querySnapshot = await db
          .collection(name)
          .orderBy('migrationNumber', descending: true)
          .limit(1)
          .get();

      return querySnapshot.docs.map((doc) => Migration.fromDoc(doc)).first;
    } on Exception {
      rethrow;
    }
  }
}
