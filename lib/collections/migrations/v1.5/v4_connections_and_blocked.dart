import 'dart:developer';

import 'package:challenge/collections/migrations/migration.dart';
import 'package:challenge/collections/users_collection.dart';

class V4ConnectionsAndBlocked extends Migration {
  V4ConnectionsAndBlocked()
      : super(
            migrationNumber: 4,
            description: 'add connections and blocked to users',
            appVersion: '1.5.3');

  @override
  Future<void> run() async {
    final querySnapshot =
        await db.collection(UsersCollection.collectionName).get();

    final Map<String, dynamic> idDataMap = {};

    for (var doc in querySnapshot.docs) {
      log('[${DateTime.now()}] migrating user ${doc.id}');
      final data = doc.data();

      if (data.containsKey('outgoingConnectionIds')) {
        data['connectionIds'] =
            List<String>.from(data['outgoingConnectionIds']);
      } else {
        data['connectionIds'] = [];
      }
      data.remove('outgoingConnectionIds');
      data.remove('incomingConnectionIds');
      data['blockedUserIds'] = [];

      idDataMap[doc.id] = data;
    }

    await updateMany(UsersCollection.collectionName, idDataMap);
  }
}
