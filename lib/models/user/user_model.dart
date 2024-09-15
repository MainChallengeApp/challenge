import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  static const String idField = 'id';

  String username;
  static const String usernameField = 'username';

  String? pictureUrl;
  static const String pictureUrlField = 'pictureUrl';

  String? bio;
  static const String bioField = 'bio';

  Set<String> connectionIds;
  static const String connectionIdsField = 'connectionIds';

  UserModel(
      {required this.id,
      required this.username,
      this.pictureUrl,
      this.bio,
      this.connectionIds = const {}});

  UserModel.empty()
      : id = '',
        username = '',
        pictureUrl = null,
        bio = null,
        connectionIds = {};

  static UserModel fromDoc(DocumentSnapshot doc) {
    try {
      return UserModel(
          id: doc.id,
          username: doc[usernameField],
          pictureUrl: (doc.data() as Map).containsKey(pictureUrlField)
              ? doc[pictureUrlField]
              : null,
          bio: (doc.data() as Map).containsKey(bioField) ? doc[bioField] : null,
          connectionIds: (doc.data() as Map).containsKey(connectionIdsField)
              ? Set.from(doc[connectionIdsField])
              : {});
    } on Exception {
      rethrow;
    }
  }

  Map<String, dynamic> toDoc() {
    return {
      usernameField: username,
      pictureUrlField: pictureUrl,
      bioField: bio,
      connectionIdsField: connectionIds
    };
  }

  UserModel copy() {
    return UserModel(
        id: id,
        username: username,
        pictureUrl: pictureUrl,
        bio: bio,
        connectionIds: Set<String>.from(connectionIds));
  }

  hasPicture() {
    return pictureUrl != null;
  }

  bool searchInUser(String searchBarText) {
    return username.toLowerCase().contains(searchBarText.toLowerCase());
  }

  void connect(String userId) {
    connectionIds.add(userId);
  }

  void disconnect(String userId) {
    connectionIds.remove(userId);
  }

  bool isConnectedWith(String userId) {
    return connectionIds.contains(userId);
  }
}
