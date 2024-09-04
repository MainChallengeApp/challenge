import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  static const String idField = 'id';

  String email;
  static const String emailField = 'email';

  String username;
  static const String usernameField = 'username';

  String? pictureUrl;
  static const String pictureUrlField = 'pictureUrl';

  String? bio;
  static const String bioField = 'bio';

  List<String> connectionIds;
  static const String connectionIdsField = 'connectionIds';

  UserModel(
      {required this.id,
      required this.email,
      required this.username,
      this.pictureUrl,
      this.bio,
      this.connectionIds = const []});

  UserModel.empty()
      : id = '',
        email = '',
        username = '',
        pictureUrl = null,
        bio = null,
        connectionIds = [];

  static UserModel fromDoc(DocumentSnapshot doc) {
    try {
      return UserModel(
          id: doc.id,
          email: doc[emailField],
          username: doc[usernameField],
          pictureUrl: (doc.data() as Map).containsKey(pictureUrlField)
              ? doc[pictureUrlField]
              : null,
          bio: (doc.data() as Map).containsKey(bioField) ? doc[bioField] : null,
          connectionIds: (doc.data() as Map).containsKey(connectionIdsField)
              ? List.from(doc[connectionIdsField])
              : []);
    } on Exception {
      rethrow;
    }
  }

  Map<String, dynamic> toDoc() {
    return {
      emailField: email,
      usernameField: username,
      pictureUrlField: pictureUrl,
      bioField: bio,
      connectionIdsField: connectionIds
    };
  }

  UserModel copy() {
    return UserModel(
        id: id,
        email: email,
        username: username,
        pictureUrl: pictureUrl,
        bio: bio,
        connectionIds: List<String>.from(connectionIds));
  }

  hasPicture() {
    return pictureUrl != null;
  }
}
