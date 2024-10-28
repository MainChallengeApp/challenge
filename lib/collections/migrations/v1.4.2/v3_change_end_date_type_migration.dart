import 'dart:developer';

import 'package:challenge/collections/migrations/migration.dart';
import 'package:challenge/collections/user_challenges_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChangeEndDateTypeMigration extends Migration {
  ChangeEndDateTypeMigration()
      : super(
            migrationNumber: 3,
            description: 'Change endDate type from String to DateTime',
            appVersion: '1.5.3');

  @override
  Future<void> run() async {
    final batch = db.batch();

    final querySnapshot =
        await db.collection(UserChallengesCollection.collectionName).get();

    for (DocumentSnapshot doc in querySnapshot.docs) {
      log('[${DateTime.now()}] migration user challenge ${doc.id}');
      final data = doc.data() as Map<String, dynamic>;
      if (data['endDate'] is DateTime) {
        continue;
      } else if (data['endDate'] == 'null') {
        data['endDate'] = null;
      } else if (data['endDate'] is String) {
        data['endDate'] = DateTime.parse(data['endDate']);
      } else {
        log('${DateTime.now()}] migration user challenge ${doc.id} failed');
      }
      final ref =
          db.collection(UserChallengesCollection.collectionName).doc(doc.id);
      batch.set(ref, data);
    }

    await batch.commit();
  }

  // Future<void> updateMany(List<DocumentSnapshot> docs) async {
  //   final batch = db.batch();
  //   for (DocumentSnapshot doc in docs) {
  //     final ref = db.collection(UserChallengesDatabase.collectionName).doc(doc.id);
  //     batch.set(ref, doc.data());
  //   }
  //   await batch.commit();
  // }
}
