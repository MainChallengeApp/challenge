import 'package:challenge/collections/collection.dart';
import 'package:challenge/models/user/user_model.dart';

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

  void update(UserModel userCopy) {
    db.collection(name).doc(userCopy.id).set(userCopy.toDoc());
  }
}
