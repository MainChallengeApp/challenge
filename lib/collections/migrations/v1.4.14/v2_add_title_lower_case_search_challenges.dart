import 'dart:developer';

import 'package:challenge/collections/migrations/migration.dart';
import 'package:challenge/collections/search_challenges_collection.dart';

class V2AddTitleLowerCaseSearchChallenges extends Migration {
  V2AddTitleLowerCaseSearchChallenges()
      : super(
            migrationNumber: 2,
            description: 'add title lower case to search challenges',
            appVersion: '1.5.3');

  @override
  Future<void> run() async {
    final querySnapshot =
        await db.collection(SearchChallengesCollection.collectionName).get();

    final Map<String, dynamic> idDataMap = {};

    for (var doc in querySnapshot.docs) {
      log('[${DateTime.now()}] migrating search challenge ${doc.id}');
      final data = doc.data();
      data['titleLowerCase'] = (data['title'] as String).toLowerCase();
      idDataMap[doc.id] = data;
    }

    await updateMany(SearchChallengesCollection.collectionName, idDataMap);
  }
}
