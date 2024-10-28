import 'dart:developer';

import 'package:challenge/collections/migrations/migration.dart';
import 'package:challenge/collections/search_challenges_collection.dart';
import 'package:challenge/services/storage_service.dart';

class V1UseThumbnailModel extends Migration {
  final storageService = StorageService();
  final searchChallengesCollection = SearchChallengesCollection();

  V1UseThumbnailModel()
      : super(
            migrationNumber: 1,
            description: 'use thumbnail model for search challenges',
            appVersion: '1.5.3');

  @override
  Future<void> run() async {
    final querySnapshot =
        await db.collection(SearchChallengesCollection.collectionName).get();

    final Map<String, dynamic> idDataMap = {};

    for (var doc in querySnapshot.docs) {
      log('[${DateTime.now()}] migrating search challenge ${doc.id}');
      final data = doc.data();
      if (data.containsKey('thumbnailPath')) {
        data['thumbnail'] = {
          'url': data['thumbnailPath'],
          'fit': 'contain',
          'scale': 0.8
        };
        data.remove('thumbnailPath');
      }
      idDataMap[doc.id] = data;
    }

    await updateMany(SearchChallengesCollection.collectionName, idDataMap);
  }
}
