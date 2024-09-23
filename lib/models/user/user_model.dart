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

  List<String> outgoingConnectionIds;
  static const String outgoingConnectionIdsField = 'outgoingConnectionIds';

  List<String> incomingConnectionIds;
  static const String incomingConnectionIdsField = 'incomingConnectionIds';

  UserModel({
    required this.id,
    required this.username,
    this.pictureUrl,
    this.bio,
    List<String>? outgoingConnectionIds,
    List<String>? incomingConnectionIds,
  })  : outgoingConnectionIds = outgoingConnectionIds ?? [],
        incomingConnectionIds = incomingConnectionIds ?? [];

  UserModel.empty()
      : id = '',
        username = '',
        pictureUrl = null,
        bio = null,
        outgoingConnectionIds = [],
        incomingConnectionIds = [];

  static UserModel fromDoc(DocumentSnapshot doc) {
    try {
      return UserModel(
          id: doc.id,
          username: doc[usernameField],
          pictureUrl: (doc.data() as Map).containsKey(pictureUrlField)
              ? doc[pictureUrlField]
              : null,
          bio: (doc.data() as Map).containsKey(bioField) ? doc[bioField] : null,
          outgoingConnectionIds:
              (doc.data() as Map).containsKey(outgoingConnectionIdsField)
                  ? List.from(doc[outgoingConnectionIdsField])
                  : [],
          incomingConnectionIds:
              (doc.data() as Map).containsKey(incomingConnectionIdsField)
                  ? List.from(doc[incomingConnectionIdsField])
                  : []);
    } on Exception {
      rethrow;
    }
  }

  Map<String, dynamic> toDoc() {
    return {
      usernameField: username,
      pictureUrlField: pictureUrl,
      bioField: bio,
      outgoingConnectionIdsField: outgoingConnectionIds,
      incomingConnectionIdsField: incomingConnectionIds
    };
  }

  UserModel copy() {
    return UserModel(
        id: id,
        username: username,
        pictureUrl: pictureUrl,
        bio: bio,
        outgoingConnectionIds: List<String>.from(outgoingConnectionIds));
  }

  hasPicture() {
    return pictureUrl != null;
  }

  bool searchInUser(String searchBarText) {
    return username.toLowerCase().contains(searchBarText.toLowerCase());
  }

  void connect(UserModel user) {
    outgoingConnectionIds.add(user.id);
    user.incomingConnectionIds.add(id);
  }

  void disconnect(String userId) {
    outgoingConnectionIds.remove(userId);
    incomingConnectionIds.remove(userId);
  }

  bool isConnectedWith(String userId) {
    return outgoingConnectionIds.contains(userId);
  }
}
