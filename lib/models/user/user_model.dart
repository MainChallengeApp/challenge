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

  String? profilePictureUrl;
  static const String profilePictureUrlField = 'profilePictureUrl';

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.username,
    this.profilePictureUrl,
  });

  static UserModel fromDoc(DocumentSnapshot doc) {
    try {
      return UserModel(
          id: doc.id,
          email: doc[emailField],
          username: doc[usernameField],
          name: doc[nameField],
          profilePictureUrl:
              (doc.data() as Map).containsKey(profilePictureUrlField)
                  ? doc[profilePictureUrlField]
                  : null);
    } on Exception {
      rethrow;
    }
  }

  Map<String, dynamic> toDoc() {
    return {
      emailField: email,
      usernameField: username,
      nameField: name,
      profilePictureUrlField: profilePictureUrl,
    };
  }
}
