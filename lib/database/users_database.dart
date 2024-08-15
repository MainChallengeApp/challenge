import 'package:challenge/database/database.dart';
import 'package:challenge/models/user/user_model.dart';

class UsersDatabase extends Database {
  static String collectionName = 'users';

  UsersDatabase() : super(collection: collectionName);

  Future<void> create(UserModel user) async {
    await db.collection(collection).doc(user.id).set(user.toDoc());
  }

  Future<UserModel> getById(String id) async {
    try {
      final doc = await db.collection(collection).doc(id).get();
      return UserModel.fromDoc(doc);
    } on Exception {
      rethrow;
    }
  }

  Future<List<UserModel>> getAll() async {
    try {
      final querySnapshot = await db.collection(collection).get();
      return querySnapshot.docs.map((doc) => UserModel.fromDoc(doc)).toList();
    } on Exception {
      rethrow;
    }
  }
}
