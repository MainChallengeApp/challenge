import 'dart:io';

import 'package:challenge/collections/user_challenges_collection.dart';
import 'package:challenge/collections/users_collection.dart';
import 'package:challenge/exceptions/could_not_delete_file_exception.dart';
import 'package:challenge/models/challenge/user_challenge_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final firebaseStorage = FirebaseStorage.instance;
  final userChallengesCollection = UserChallengesCollection();

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
    await deleteFolderByPath(
        '${UsersCollection.collectionName}/$currentUserId');

    List<UserChallengeModel> userChallenges =
        await userChallengesCollection.getAllByUserId(userId: currentUserId);
    for (var userChallenge in userChallenges) {
      await deleteFolderByPath(
          '${UserChallengesCollection.collectionName}/${userChallenge.id}');
    }
  }
}
