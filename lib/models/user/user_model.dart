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

  List<String> connectionIds;
  static const String connectionIdsField = 'connectionIds';

  List<String> blockedUserIds;
  static const String blockedUserIdsField = 'blockedUserIds';

  UserModel({
    required this.id,
    required this.username,
    this.pictureUrl,
    this.bio,
    List<String>? connectionIds,
    List<String>? blockedUserIds,
  })  : connectionIds = connectionIds ?? [],
        blockedUserIds = blockedUserIds ?? [];

  UserModel.empty()
      : id = '',
        username = '',
        pictureUrl = null,
        bio = null,
        connectionIds = [],
        blockedUserIds = [];

  static UserModel fromDoc(DocumentSnapshot doc) {
    try {
      var user = UserModel(
          id: doc.id,
          username: doc[usernameField],
          pictureUrl: (doc.data() as Map).containsKey(pictureUrlField)
              ? doc[pictureUrlField]
              : null,
          bio: (doc.data() as Map).containsKey(bioField) ? doc[bioField] : null,
          connectionIds: (doc.data() as Map).containsKey(connectionIdsField)
              ? List.from(doc[connectionIdsField])
              : [],
          blockedUserIds: (doc.data() as Map).containsKey(blockedUserIdsField)
              ? List.from(doc[blockedUserIdsField])
              : []);
      return user;
    } on Exception {
      rethrow;
    }
  }

  Map<String, dynamic> toDoc() {
    return {
      usernameField: username,
      pictureUrlField: pictureUrl,
      bioField: bio,
      connectionIdsField: connectionIds,
      blockedUserIdsField: blockedUserIds
    };
  }

  UserModel copy() {
    return UserModel(
        id: id,
        username: username,
        pictureUrl: pictureUrl,
        bio: bio,
        connectionIds: List<String>.from(connectionIds),
        blockedUserIds: List<String>.from(blockedUserIds));
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

  bool isBlocked(String userId) {
    return blockedUserIds.contains(userId);
  }

  void blockUser(String userId) {
    blockedUserIds.add(userId);
  }

  void unblockUser(String userId) {
    blockedUserIds.remove(userId);
  }

  bool isEmpty() {
    // used for filtering out blocked users
    return id.isEmpty;
  }
}
