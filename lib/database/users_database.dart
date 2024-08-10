import 'package:challenge/database/database.dart';
import 'package:challenge/models/user/user_model.dart';

class UsersDatabase extends Database {
  UsersDatabase() {
    collection = 'users';
  }

  Future<void> createUser(UserModel user) async {
    await db.collection(collection).doc(user.id).set(user.toMap());
  }

  Future<UserModel> getUser(String id) async {
    try {
      final doc = await db.collection(collection).doc(id).get();
      return UserModel.fromMap(doc.data()!);
    } on Exception {
      rethrow;
    }
  }
}
