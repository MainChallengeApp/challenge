import 'dart:developer';

import 'package:challenge/collections/migrations/migration.dart';
import 'package:challenge/collections/search_challenges_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RemoveStartDataFromSearchChallenges extends Migration {
  RemoveStartDataFromSearchChallenges()
      : super(
            migrationNumber: 5,
            description: 'Remove startData from search_challenges',
            appVersion: '1.5.3');

  @override
  Future<void> run() async {
    final querySnapshot =
        await db.collection(SearchChallengesCollection.collectionName).get();

    final Map<String, dynamic> idDataMap = {};

    for (DocumentSnapshot doc in querySnapshot.docs) {
      log('[${DateTime.now()}] migrating search challenge ${doc.id}');

      final data = doc.data() as Map<String, dynamic>;

      if (data.containsKey('startData')) {
        data.remove('startData');
        log('${DateTime.now()}] startData removed from search challenge ${doc.id}');
      } else {
        log('${DateTime.now()}] no startData found in search challenge ${doc.id}. Already good.');
      }

      if (data['startDate'] is DateTime) {
        continue;
      } else if (data['startDate'] == 'null') {
        data['startDate'] = null;
      } else if (data['startDate'] is String) {
        data['startDate'] = DateTime.parse(data['startDate']);
      } else {
        log('${DateTime.now()}] migration user challenge ${doc.id} failed and skipped');
      }

      idDataMap[doc.id] = data;
    }

    await updateMany(SearchChallengesCollection.collectionName, idDataMap);
  }
}
