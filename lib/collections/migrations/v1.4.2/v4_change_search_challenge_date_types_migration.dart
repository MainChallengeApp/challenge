import 'dart:developer';

import 'package:challenge/collections/migrations/migration.dart';
import 'package:challenge/collections/search_challenges_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChangeSearchChallengeDateTypesMigration extends Migration {
  ChangeSearchChallengeDateTypesMigration()
      : super(
            migrationNumber: 4,
            description:
                'Change search challenge date types from String to DateTime',
            appVersion: '1.5.3');

  @override
  Future<void> run() async {
    final querySnapshot =
        await db.collection(SearchChallengesCollection.collectionName).get();

    final Map<String, dynamic> idDataMap = {};

    DateTime now = DateTime.now();

    for (DocumentSnapshot doc in querySnapshot.docs) {
      log('[${DateTime.now()}] migration search challenge ${doc.id}');

      final data = doc.data() as Map<String, dynamic>;

      if (data['endDate'] is DateTime) {
        continue;
      } else if (data['endDate'] == 'null') {
        data['endDate'] = null;
      } else if (data['endDate'] is String) {
        data['endDate'] = DateTime.parse(data['endDate']);
      } else {
        log('${DateTime.now()}] migration user challenge ${doc.id} failed and skipped');
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

      data['createdAt'] = now;

      idDataMap[doc.id] = data;
    }

    await updateMany(SearchChallengesCollection.collectionName, idDataMap);
  }
}
