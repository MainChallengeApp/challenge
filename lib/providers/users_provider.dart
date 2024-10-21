import 'package:challenge/collections/users_collection.dart';
import 'package:challenge/models/notification/request_connection_notification_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/notifications_provider.dart';
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

  final List<UserModel> _outgoingConnections = [];
  List<UserModel> get outgoingConnections => _outgoingConnections;

  final List<UserModel> _incomingConnections = [];
  List<UserModel> get incomingConnections => _incomingConnections;

  bool _isEndOfSearchedListReached = false;
  bool get isEndOfSearchedListReached => _isEndOfSearchedListReached;

  final int paginationLimit = 5;

  NotificationsProvider notificationsProvider;

  UsersProvider({required this.notificationsProvider});

  Future<void> createUser({required String email, username}) async {
    final user = UserModel(
      id: authService.getCurrentUserId(),
      username: username,
    );
    _user = user;
    await usersCollection.create(user);
    notifyListeners();
  }

  Future<UserModel> getUser({bool notify = true}) async {
    final user = await usersCollection.getById(authService.getCurrentUserId());
    _user = user;
    if (notify) {
      notifyListeners();
    }
    return user;
  }

  update(UserModel user) async {
    user.pictureUrl = await mediaService.uploadLocalUserPicture(user);
    _user = user;
    usersCollection.update(_user);
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

  Future<void> connectToUser(String userId) async {
    UserModel otherUser = await usersCollection.getById(userId);
    _user.connect(otherUser);
    await usersCollection.update(_user);
    await usersCollection.update(otherUser);
    await getConnections(notify: false);

    RequestConnectionNotificationModel notification =
        RequestConnectionNotificationModel(
            title: '@${_user.username} wants to connect with you',
            userId: otherUser.id,
            fromUserId: _user.id);
    await notificationsProvider.createNotification(notification);

    notifyListeners();
  }

  Future<void> disconnectFromUser(String id) async {
    UserModel otherUser = await usersCollection.getById(id);

    _user.disconnect(id);
    otherUser.disconnect(_user.id);

    await usersCollection.update(_user);
    await usersCollection.update(otherUser);

    await getConnections(notify: false);
    notifyListeners();
  }

  Future<void> getConnections({bool notify = true}) async {
    await getUser(notify: false);
    _outgoingConnections.clear();
    _outgoingConnections.addAll(
        await usersCollection.getByUserIds(_user.outgoingConnectionIds));
    _incomingConnections.clear();
    _incomingConnections.addAll(
        await usersCollection.getByUserIds(_user.incomingConnectionIds));

    if (notify) {
      notifyListeners();
    }
  }

  Future<void> getSearchedPaginated({String searchText = ''}) async {
    try {
      if (!_isEndOfSearchedListReached) {
        final fetchedSearchUsers = await usersCollection.getSearchedPaginated(
            limit: paginationLimit,
            userId: _user.id,
            lastSearchedUser:
                _searchUsers.isNotEmpty ? _searchUsers.last : null,
            searchText: searchText);

        _isEndOfSearchedListReached =
            fetchedSearchUsers.length < paginationLimit;

        _searchUsers.addAll(fetchedSearchUsers);

        notifyListeners();
      }
    } on Exception {
      rethrow;
    }
  }

  void resetEndOfSearchedList() {
    _isEndOfSearchedListReached = false;
  }

  void emptySearchUsers() {
    _searchUsers.clear();
  }

  Future<void> refresh() async {
    try {
      resetEndOfSearchedList();
      _searchUsers =
          await usersCollection.refresh(loadedSearchUsers: _searchUsers);
      notifyListeners();
    } on Exception {
      rethrow;
    }
  }
}
