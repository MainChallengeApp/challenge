import 'dart:developer';

import 'package:challenge/collections/migrations/migration.dart';
import 'package:challenge/collections/search_challenges_collection.dart';
import 'package:challenge/services/storage_service.dart';

class V8ChangeToThumbnailModelMigration extends Migration {
  final storageService = StorageService();
  final searchChallengesCollection = SearchChallengesCollection();

  V8ChangeToThumbnailModelMigration()
      : super(
            migrationNumber: 9,
            description: 'change search challenges thumbnail model');

  @override
  Future<void> run() async {
    log('${DateTime.now()}] upload search challenges thumbnails to cloud storage');

    final querySnapshot =
        await db.collection(SearchChallengesCollection.collectionName).get();

    final Map<String, dynamic> idDataMap = {};

    for (var doc in querySnapshot.docs) {
      log('[${DateTime.now()}] migrating search challenge ${doc.id}');
      final data = doc.data();
      if (data.containsKey('thumbnail')) {
        data['thumbnail']['fit'] = 'contain';
      }
      idDataMap[doc.id] = data;
    }

    await updateMany(SearchChallengesCollection.collectionName, idDataMap);
  }
}
