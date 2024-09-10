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

  List<UserModel> _searchUsers = [];
  List<UserModel> get searchUsers => _searchUsers;

  Future<void> createUser({required String email, username}) async {
    final user = UserModel(
      id: authService.getCurrentUserId(),
      username: username,
    );
    _user = user;
    await usersCollection.create(user);
    notifyListeners();
  }

  Future<UserModel> getUser() async {
    final user = await usersCollection.getById(authService.getCurrentUserId());
    _user = user;
    notifyListeners();
    return user;
  }

  update(UserModel user) async {
    user.pictureUrl = await mediaService.uploadLocalUserPicture(user);
    _user = user;
    usersCollection.update(user);
    notifyListeners();
  }

  void resetLocalUser() {
    _user = UserModel.empty();
    notifyListeners();
  }

  Future<List<UserModel>> searchUsersByUsername(String username) async {
    _searchUsers.clear();
    _searchUsers
        .addAll(await usersCollection.getAllByUsernameContains(username));
    notifyListeners();
    return _searchUsers;
  }

  void getAll() async {
    _searchUsers = await usersCollection.getAll();
    _searchUsers
        .removeWhere((user) => user.id == authService.getCurrentUserId());
    notifyListeners();
  }
}
