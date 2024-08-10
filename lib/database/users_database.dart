import 'package:challenge/database/database.dart';
import 'package:challenge/models/user/user_model.dart';

class UsersDatabase extends Database {
  UsersDatabase() {
    collection = 'users';
  }

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
}
