import 'package:challenge/database/users_database.dart';
import 'package:challenge/models/user/user_model.dart';

class UserService {
  UsersDatabase userDatabase = UsersDatabase();

  Future<void> createUser({required String id, email, username, name}) async {
    final user =
        UserModel(id: id, email: email, username: username, name: name);
    await userDatabase.createUser(user);
  }
}
