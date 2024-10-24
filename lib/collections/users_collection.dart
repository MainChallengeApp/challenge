import 'package:challenge/collections/collection.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersCollection extends Collection {
  static String collectionName = 'users';

  UsersCollection() : super(name: collectionName);

  Future<void> create(UserModel user) async {
    await db.collection(name).doc(user.id).set(user.toDoc());
  }

  Future<UserModel> getById(String id) async {
    try {
      final doc = await db.collection(name).doc(id).get();
      return UserModel.fromDoc(doc);
    } on Exception {
      rethrow;
    }
  }

  Future<void> update(UserModel user) async {
    await db.collection(name).doc(user.id).update(user.toDoc());
  }

  Future<List<UserModel>> getByUserIds(List<String> userIds) async {
    try {
      List<DocumentSnapshot> docs = await Future.wait(
          userIds.map((id) => db.collection(name).doc(id).get()));
      return docs.map((doc) => UserModel.fromDoc(doc)).toList();
    } on Exception {
      rethrow;
    }
  }

  Future<List<UserModel>> getIncomingConnections(
      String userId, List<String> blockedUserIds) async {
    try {
      final querySnapshot = await db
          .collection(name)
          .where(UserModel.connectionIdsField, arrayContains: userId)
          .get();
      List<UserModel> users =
          querySnapshot.docs.map((doc) => UserModel.fromDoc(doc)).toList();
      return users.map((user) {
        // Filter out blocked users
        if (blockedUserIds.contains(user.id)) {
          return UserModel.empty();
        }
        return user;
      }).toList();
    } on Exception {
      rethrow;
    }
  }

  Future<List<UserModel>> getSearchedPaginated(
      {required List<String> blockedUserIds,
      required int limit,
      required String userId,
      UserModel? lastSearchedUser,
      required String searchText}) async {
    try {
      final querySnapshot = await db
          .collection(name)
          .orderBy(UserModel.usernameField)
          .where(FieldPath.documentId, isNotEqualTo: userId)
          .where(UserModel.usernameField, isGreaterThanOrEqualTo: searchText)
          .where(UserModel.usernameField, isLessThanOrEqualTo: '${searchText}z')
          .startAfter([lastSearchedUser?.username ?? ''])
          .limit(limit)
          .get();
      List<UserModel> users =
          querySnapshot.docs.map((doc) => UserModel.fromDoc(doc)).toList();
      return users.map((user) {
        // Filter out blocked users
        if (blockedUserIds.contains(user.id)) {
          return UserModel.empty();
        }
        return user;
      }).toList();
    } on Exception {
      rethrow;
    }
  }

  Future<List<UserModel>> refresh(
      {required List<UserModel> loadedSearchUsers}) async {
    try {
      final idsToFetch = loadedSearchUsers
          .take(10)
          .map((e) => e.id)
          .toList(); // 10 is the limit of firebase

      if (idsToFetch.isEmpty) {
        idsToFetch.add('123'); // Add an string to prevent an error
        idsToFetch.add('456'); // Add an string to prevent an error
      }

      final querySnapshot = await db
          .collection(name)
          .where(FieldPath.documentId, whereIn: idsToFetch)
          .get();

      // Create a map of id to ChallengeModel for quick lookup
      final usersMap = {
        for (var doc in querySnapshot.docs) doc.id: UserModel.fromDoc(doc)
      };

      // Reconstruct the list in the original order
      return idsToFetch
          .map((id) => usersMap[id])
          .where((user) => user != null)
          .cast<UserModel>()
          .toList();
    } on Exception {
      rethrow;
    }
  }

  // not used but maybe pagination for the future
  Future<List<UserModel>> getUsersByIdsPaginated(
      List<String> userIds, String? lastUserId) async {
    final idsToFetch =
        _getNextTenUsers(userIds, lastUserId); // 10 is the limit of firebase

    if (idsToFetch.isEmpty) {
      userIds.add('123'); // Add an string to prevent an error
      userIds.add('456'); // Add an string to prevent an error
    }

    try {
      final querySnapshot = await db
          .collection(name)
          .where(FieldPath.documentId, whereIn: userIds)
          .get();
      // Create a map of id to ChallengeModel for quick lookup
      final usersMap = {
        for (var doc in querySnapshot.docs) doc.id: UserModel.fromDoc(doc)
      };

      return idsToFetch
          .map((id) => usersMap[id])
          .where((user) => user != null)
          .cast<UserModel>()
          .toList();
    } on Exception {
      rethrow;
    }
  }

  List<String> _getNextTenUsers(List<String> userIds, String? lastUserId) {
    if (lastUserId == null || !userIds.contains(lastUserId)) {
      // If lastUserId is null or not in the list, return the first 10 entries (or less if the list is shorter)
      return userIds.take(10).toList();
    }

    int startIndex = userIds.indexOf(lastUserId) + 1;
    return userIds.skip(startIndex).take(10).toList();
  }
}
