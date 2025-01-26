import 'dart:io';
import 'dart:typed_data';

import 'package:challenge/collections/group_challenges_collection.dart';
import 'package:challenge/collections/users_collection.dart';
import 'package:challenge/exceptions/could_not_delete_file_exception.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/ui/dialogs/error_occurred_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class StorageService {
  final firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadFile(File file, String path,
      {bool compressed = true}) async {
    if (compressed) {
      File? compressedFile = await processImage(file);
      if (compressedFile != null) {
        file = compressedFile;
      }
    }
    final ref = firebaseStorage.ref().child(path);
    try {
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      ErrorOccurredDialog.show(errorText: e.toString());
      rethrow;
    }
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

  Future<File?> compressImageToSizeLimit(File file, int maxSizeInBytes) async {
    int quality = 1;
    Uint8List? result;

    try {
      result = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        quality: quality,
      );
    } catch (e) {
      rethrow;
    }

    if (result != null) {
      final tempDir = await getTemporaryDirectory();
      File compressedFile = File('${tempDir.path}/compressed_image.jpg')
        ..writeAsBytesSync(result);
      return compressedFile;
    }

    return null; // Couldn't compress to desired size
  }

  Future<bool> isFileSizeValid(File file, int maxSizeInBytes) async {
    try {
      if (!await file.exists()) {
        return false;
      }
      final int fileSize = await file.length();
      return fileSize <= maxSizeInBytes;
    } catch (e) {
      rethrow;
    }
  }

  Future<File?> processImage(File imageFile) async {
    const int maxSizeInBytes = 1024; // 1 KB

    if (await isFileSizeValid(imageFile, maxSizeInBytes)) {
      return imageFile;
    } else {
      File? compressedFile =
          await compressImageToSizeLimit(imageFile, maxSizeInBytes);
      if (compressedFile != null) {
        return compressedFile;
      } else {
        return null;
        // Handle case where image couldn't be compressed to desired size
      }
    }
  }
}
