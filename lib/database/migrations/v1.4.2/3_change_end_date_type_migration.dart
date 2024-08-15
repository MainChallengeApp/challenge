import 'package:challenge/database/migrations/migration_model.dart';
import 'package:challenge/database/user_challenges_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChangeEndDateTypeMigration extends MigrationModel {
  ChangeEndDateTypeMigration()
      : super(
            migrationNumber: 3,
            description: 'Change endDate type from String to DateTime');

  @override
  Future<void> run() async {
    final batch = db.batch();

    final querySnapshot =
        await db.collection(UserChallengesDatabase.collectionName).get();

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
          db.collection(UserChallengesDatabase.collectionName).doc(doc.id);
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
