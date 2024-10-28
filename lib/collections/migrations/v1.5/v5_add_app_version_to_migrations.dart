import 'package:challenge/collections/migration_collection.dart';
import 'package:challenge/collections/migrations/migration.dart';

class V5AddAppVersionToMigrations extends Migration {
  V5AddAppVersionToMigrations()
      : super(
            migrationNumber: 5,
            description: 'add appVersion to migrations',
            appVersion: '1.5.3');

  @override
  Future<void> run() async {
    String collectionName = MigrationCollection.collectionName;

    final querySnapshot = await db.collection(collectionName).get();

    final Map<String, dynamic> idDataMap = {};

    for (var doc in querySnapshot.docs) {
      final data = doc.data();

      data['appVersion'] = '1.5.3';

      idDataMap[doc.id] = data;
    }

    await updateMany(collectionName, idDataMap);
  }
}
