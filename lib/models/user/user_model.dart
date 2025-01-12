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

  List<String> recentSearches;
  static const String recentSearchesField = 'recentSearches';

  List<String> fcmTokens;
  static const String fcmTokensField = 'fcmTokens';

  bool allowNotifications;
  static const String allowNotificationsField = 'allowNotifications';

  UserModel({
    required this.id,
    required this.username,
    this.pictureUrl,
    this.bio,
    List<String>? connectionIds,
    List<String>? blockedUserIds,
    List<String>? recentSearches,
    List<String>? fcmTokens,
    bool? allowNotifications,
  })  : connectionIds = connectionIds ?? [],
        blockedUserIds = blockedUserIds ?? [],
        recentSearches = recentSearches ?? [],
        fcmTokens = fcmTokens ?? [],
        allowNotifications = allowNotifications ?? false;

  UserModel.empty()
      : id = '',
        username = '',
        pictureUrl = null,
        bio = null,
        connectionIds = [],
        blockedUserIds = [],
        recentSearches = [],
        fcmTokens = [],
        allowNotifications = false;

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
              : [],
          recentSearches: (doc.data() as Map).containsKey(recentSearchesField)
              ? List.from(doc[recentSearchesField])
              : [],
          fcmTokens: (doc.data() as Map).containsKey(fcmTokensField)
              ? List.from(doc[fcmTokensField])
              : [],
          allowNotifications:
              (doc.data() as Map).containsKey(allowNotificationsField)
                  ? doc[allowNotificationsField]
                  : false);
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
      blockedUserIdsField: blockedUserIds,
      recentSearchesField: recentSearches,
      fcmTokensField: fcmTokens,
      allowNotificationsField: allowNotifications,
    };
  }

  UserModel copy() {
    return UserModel(
        id: id,
        username: username,
        pictureUrl: pictureUrl,
        bio: bio,
        connectionIds: List<String>.from(connectionIds),
        blockedUserIds: List<String>.from(blockedUserIds),
        recentSearches: List.from(recentSearches),
        fcmTokens: List.from(fcmTokens),
        allowNotifications: allowNotifications);
  }

  hasPicture() {
    return pictureUrl != null;
  }

  bool searchInUser(String searchBarText) {
    return username.toLowerCase().contains(searchBarText.toLowerCase());
  }

  void connect(String userId) {
    if (connectionIds.contains(userId)) {
      return;
    }
    connectionIds.add(userId);
  }

  void disconnect(String userId) {
    connectionIds.remove(userId);
  }

  bool isConnectedWith(UserModel user) {
    return connectionIds.contains(user.id) && user.connectionIds.contains(id);
  }

  bool isBlocked(String userId) {
    return blockedUserIds.contains(userId);
  }

  void blockUser(String userId) {
    if (blockedUserIds.contains(userId)) {
      return;
    }
    blockedUserIds.add(userId);
  }

  void unblockUser(String userId) {
    blockedUserIds.remove(userId);
  }

  bool isEmpty() {
    // used for filtering out blocked users
    return id.isEmpty;
  }

  void addRecentSearch(String recentSearch) {
    if (recentSearches.contains(recentSearch)) {
      removeRecentSearch(recentSearch);
    }
    recentSearches.insert(0, recentSearch);

    const int maxRecentSearches = 20;
    recentSearches = recentSearches.take(maxRecentSearches).toList();
  }

  void removeRecentSearch(String recentSearch) {
    recentSearches
        .removeWhere((recentSearchEntry) => recentSearchEntry == recentSearch);
  }

  void addFcmToken(String? fcmToken) {
    if (fcmToken == null) {
      return;
    }

    if (fcmTokens.contains(fcmToken)) {
      return;
    }
    fcmTokens.add(fcmToken);
  }

  void removeFcmToken(String? fcmToken) {
    if (fcmToken == null) {
      return;
    }
    fcmTokens.removeWhere((fcmTokenEntry) => fcmTokenEntry == fcmToken);
  }
}
