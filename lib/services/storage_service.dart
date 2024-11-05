import 'dart:io';

import 'package:challenge/collections/group_challenges_collection.dart';
import 'package:challenge/collections/users_collection.dart';
import 'package:challenge/exceptions/could_not_delete_file_exception.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadFile(File file, String path) async {
    final ref = firebaseStorage.ref().child(path);
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> deleteFileByUrl(String url) async {
    try {
      await firebaseStorage.refFromURL(url).delete();
    } on Exception catch (e) {
      throw CouldNotDeleteFileException(e.toString());
    }
  }

  Future<void> deleteFileByPath(String path) async {
    try {
      await firebaseStorage.ref(path).delete();
    } on Exception catch (e) {
      throw CouldNotDeleteFileException(e.toString());
    }
  }

  Future<void> deleteFolderByPath(String path) async {
    try {
      ListResult files = await firebaseStorage.ref(path).listAll();
      for (var file in files.items) {
        await file.delete();
      }
    } on Exception catch (e) {
      throw CouldNotDeleteFileException(e.toString());
    }
  }

  deleteUserFiles(String currentUserId) async {
    final groupChallengesCollection = getIt<GroupChallengesCollection>();
    await deleteFolderByPath(
        '${UsersCollection.collectionName}/$currentUserId');

    List<GroupChallengeModel> groupChallenges =
        await groupChallengesCollection.getAllByUserId(userId: currentUserId);
    for (var groupChallenge in groupChallenges) {
      await deleteFolderByPath(
          '${GroupChallengesCollection.collectionName}/${groupChallenge.id}/$currentUserId');
    }
  }
}
