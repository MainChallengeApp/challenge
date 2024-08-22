import 'dart:developer';
import 'dart:io';

import 'package:challenge/collections/migrations/migration.dart';
import 'package:challenge/collections/search_challenges_collection.dart';
import 'package:challenge/services/storage_service.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class V7UploadSearchChallengesThumbnailsMigration extends Migration {
  final storageService = StorageService();
  final searchChallengesCollection = SearchChallengesCollection();

  V7UploadSearchChallengesThumbnailsMigration()
      : super(
            migrationNumber: 11,
            description: 'upload search challenges thumbnails 2.0');

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
        final path = 'search_challenges/${doc.id}/thumbnail';
        File file = await getImageFileFromAssets(data['thumbnail']['url']);
        final imageUrl = await storageService.uploadFile(file, path);
        data['thumbnail']['url'] = imageUrl;
      }
      idDataMap[doc.id] = data;
    }

    await updateMany(SearchChallengesCollection.collectionName, idDataMap);
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load(path);

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
}
