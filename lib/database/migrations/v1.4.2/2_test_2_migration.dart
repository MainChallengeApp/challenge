import 'package:challenge/database/migrations/migration_model.dart';
import 'package:challenge/database/user_challenges_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Test2Migration extends MigrationModel {
  Test2Migration()
      : super(
            migrationNumber: 2,
            description: 'Change startDate type from String to DateTime');

  @override
  Future<void> run() async {
    final querySnapshot =
        await db.collection(UserChallengesDatabase.collectionName).get();

    for (DocumentSnapshot doc in querySnapshot.docs) {
      print('[${DateTime.now()}] migration user challenge ${doc['title']}');
      final data = doc.data() as Map<String, dynamic>;
      if (data['startDate'] is DateTime) {
        continue;
      } else if (data['startDate'] == 'null') {
        data['startDate'] = null;
      } else if (data['startDate'] is String) {
        data['startDate'] = DateTime.parse(data['startDate']);
      } else {
        print(
            '${DateTime.now()}] migration user challenge ${doc['title']} failed');
      }
      await db
          .collection(UserChallengesDatabase.collectionName)
          .doc(doc.id)
          .update(data);
    }
  }

  // Future<void> updateMany(List<Object> userChallenges) async {
  //   final batch = db.batch();
  //   for (var userChallenge in userChallenges) {
  //     final ref = db.collection(UserChallengesDatabase.collectionName).doc();
  //     batch.set(userChallenge.id, userChallenge.toDoc());
  //   }
  //   await batch.commit();
  // }
}
