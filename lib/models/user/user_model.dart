import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  static const String idField = 'id';

  String email;
  static const String emailField = 'email';

  String username;
  static const String usernameField = 'username';

  String name;
  static const String nameField = 'name';

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
          email: doc[emailField],
          username: doc[usernameField],
          name: doc[nameField]);
    } on Exception {
      rethrow;
    }
  }

  Map<String, dynamic> toDoc() {
    return {
      emailField: email,
      usernameField: username,
      nameField: name,
    };
  }
}
