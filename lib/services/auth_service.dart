import 'package:challenge/services/database_service.dart';
import 'package:challenge/services/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final auth = FirebaseAuth.instance;
  final storageService = StorageService();
  final databaseService = DatabaseService();

  User? getCurrentUser() => auth.currentUser;
  String getCurrentUserId() => auth.currentUser!.uid;

  Future<UserCredential> loginEmailPassword(
      String email, String password) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<UserCredential> registerEmailPassword(
      String email, String password) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> logout() async {
    await auth.signOut();
  }

  Future<void> deleteUser() async {
    try {
      await storageService.deleteUserFiles(getCurrentUserId());
      await databaseService.deleteUserDocuments(getCurrentUserId());
      await auth.currentUser!.delete();
    } on FirebaseAuthException {
      rethrow;
    }
  }

  bool isValidEmail(String text) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(text);
  }

  bool isValidPassword(String text) {
    return text.length >= 6;
  }

  String? getPasswordErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'Password is too weak';
      case 'wrong-password':
        return 'Invalide Credentials';
      case 'invalid-credential':
        return 'Invalid Credential';
      default:
        return null;
    }
  }

  String? getEmailErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Email already in use';
      case 'wrong-password':
        return 'Invalide Credentials';
      case 'user-not-found':
        return 'User not found';
      case 'user-disabled':
        return 'User disabled';
      case 'operation-not-allowed':
        return 'Operation not allowed';
      case 'invalid-email':
        return 'Invalid Email';
      case 'invalid-credential':
        return 'Invalid Credential';
      case 'too-many-requests':
        return 'Too many requests. Try again later';
      case 'network-request-failed':
        return 'Network request failed. Connect to the internet';
      default:
        return null;
    }
  }
}
