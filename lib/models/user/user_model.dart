import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String email;
  String username;
  String name;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.username,
  });

  static UserModel fromDoc(DocumentSnapshot doc) {
    try {
      return UserModel(
          id: doc.id,
          email: doc['email'],
          username: doc['username'],
          name: doc['name']);
    } on Exception {
      rethrow;
    }
  }

  Map<String, dynamic> toDoc() {
    return {
      'email': email,
      'username': username,
      'name': name,
    };
  }
}
