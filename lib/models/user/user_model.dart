import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  static const String idField = 'id';

  String email;
  static const String emailField = 'email';

  String username;
  static const String usernameField = 'username';

  String? profilePictureUrl;
  static const String profilePictureUrlField = 'profilePictureUrl';

  String? bio;
  static const String bioField = 'bio';

  List<String> connectionIds;
  static const String connectionIdsField = 'connectionIds';

  UserModel(
      {required this.id,
      required this.email,
      required this.username,
      this.profilePictureUrl,
      this.bio,
      this.connectionIds = const []});

  static UserModel fromDoc(DocumentSnapshot doc) {
    try {
      return UserModel(
          id: doc.id,
          email: doc[emailField],
          username: doc[usernameField],
          profilePictureUrl:
              (doc.data() as Map).containsKey(profilePictureUrlField)
                  ? doc[profilePictureUrlField]
                  : null,
          bio: (doc.data() as Map).containsKey(bioField) ? doc[bioField] : null,
          connectionIds: (doc.data() as Map).containsKey(connectionIdsField)
              ? doc[connectionIdsField]
              : []);
    } on Exception {
      rethrow;
    }
  }

  Map<String, dynamic> toDoc() {
    return {
      emailField: email,
      usernameField: username,
      profilePictureUrlField: profilePictureUrl,
      bioField: bio,
      connectionIdsField: connectionIds
    };
  }

  UserModel copy() {
    return UserModel(
        id: id,
        email: email,
        username: username,
        profilePictureUrl: profilePictureUrl,
        bio: bio,
        connectionIds: List<String>.from(connectionIds));
  }
}
