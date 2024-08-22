import 'dart:io';

import 'package:challenge/exceptions/could_not_delete_file_exception.dart';
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
}
