import 'package:challenge/database/migrations/migration_model.dart';
import 'package:challenge/database/search_challenges_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChangeSearchChallengeDateTypesMigration extends MigrationModel {
  ChangeSearchChallengeDateTypesMigration()
      : super(
            migrationNumber: 4,
            description:
                'Change search challenge date types from String to DateTime');

  @override
  Future<void> run() async {
    final querySnapshot =
        await db.collection(SearchChallengesDatabase.collectionName).get();

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

    await updateMany(SearchChallengesDatabase.collectionName, idDataMap);
  }
}
