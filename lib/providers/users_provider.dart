import 'package:challenge/collections/users_collection.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:flutter/material.dart';

class UsersProvider with ChangeNotifier {
  UsersCollection usersDatabase = UsersCollection();
  AuthService authService = AuthService();

  Future<void> createUser({required String email, username, name}) async {
    final user = UserModel(
        id: authService.getCurrentUserId(),
        email: email,
        username: username,
        name: name);
    await usersDatabase.create(user);
  }

  Future<UserModel> getUser() async {
    final user = await usersDatabase.getById(authService.getCurrentUserId());
    return user;
  }
}
