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
    final firebaseStorage = FirebaseStorage.instance;

    try {
      // List all files and folders in the given path
      ListResult listResult = await firebaseStorage.ref(path).listAll();

      // Delete all files
      for (var file in listResult.items) {
        await file.delete();
      }

      // Recursively delete all sub folders
      for (var folder in listResult.prefixes) {
        await deleteFolderByPath(folder.fullPath);
      }
    } on FirebaseException catch (e) {
      throw Exception('Failed to delete folder: $path, Error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
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
