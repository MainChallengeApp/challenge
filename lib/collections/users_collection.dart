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

  Future<List<UserModel>> getAll() async {
    try {
      final querySnapshot = await db.collection(name).get();
      return querySnapshot.docs.map((doc) => UserModel.fromDoc(doc)).toList();
    } on Exception {
      rethrow;
    }
  }

  Future<List<UserModel>> getAllByUsernameContains(String username) async {
    try {
      final querySnapshot = await db.collection(name).get();
      return querySnapshot.docs
          .where((doc) =>
              (doc[UserModel.usernameField] as String).contains(username))
          .map((doc) => UserModel.fromDoc(doc))
          .toList();
    } on Exception {
      rethrow;
    }
  }

  Future<void> update(UserModel userCopy) async {
    await db.collection(name).doc(userCopy.id).update(userCopy.toDoc());
  }

  Future<List<UserModel>> getByUserIds(List<String> userIds) async {
    List<UserModel> users = [];
    try {
      for (String userId in userIds) {
        final doc = await db.collection(name).doc(userId).get();
        users.add(UserModel.fromDoc(doc));
      }
      return users;
    } on Exception {
      rethrow;
    }
  }

  Future<List<UserModel>> getSearchedPaginated(
      {required int limit,
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
      return querySnapshot.docs.map((doc) => UserModel.fromDoc(doc)).toList();
    } on Exception {
      rethrow;
    }
  }

  Future<List<UserModel>> refresh(
      {required List<UserModel> loadedSearchUsers}) async {
    try {
      final idsToFetch = loadedSearchUsers.take(10).map((e) => e.id).toList();

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
}
