import 'package:challenge/collections/users_collection.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/services/media_service.dart';
import 'package:flutter/material.dart';

class UsersProvider with ChangeNotifier {
  UsersCollection usersCollection = UsersCollection();
  AuthService authService = AuthService();
  MediaService mediaService = MediaService();

  UserModel _user = UserModel.empty();
  UserModel get user => _user;

  Future<void> createUser({required String email, username}) async {
    final user = UserModel(
      id: authService.getCurrentUserId(),
      email: email,
      username: username,
    );
    _user = user;
    usersCollection.create(user);
    notifyListeners();
  }

  Future<UserModel> getUser() async {
    final user = await usersCollection.getById(authService.getCurrentUserId());
    _user = user;
    notifyListeners();
    return user;
  }

  update(UserModel user) async {
    user.profilePictureUrl = await mediaService.uploadLocalProfilePicture(user);
    _user = user;
    usersCollection.update(user);
    notifyListeners();
  }
}
