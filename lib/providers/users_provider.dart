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
  bool _isEndOfSearchedListReached = false;
  bool get isEndOfSearchedListReached => _isEndOfSearchedListReached;

  List<UserModel> _outgoingConnections = [];
  List<UserModel> get outgoingConnections => _outgoingConnections;

  List<UserModel> _incomingConnections = [];
  List<UserModel> get incomingConnections => _incomingConnections;

  List<UserModel> _blockedUsers = [];
  List<UserModel> get blockedUsers => _blockedUsers;

  final int paginationLimit = 10;

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

  Future<void> connectToUser(String otherUserId) async {
    _user.connect(otherUserId);
    await usersCollection.update(_user);
    await getConnections(notify: false);

    RequestConnectionNotificationModel notification =
        RequestConnectionNotificationModel(
            title: '@${_user.username} wants to connect with you',
            userId: otherUserId,
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

    await getConnections();
    notifyListeners();
  }

  Future<void> getConnections({bool notify = true}) async {
    await getUser(notify: false);
    _outgoingConnections =
        await usersCollection.getByUserIds(_user.connectionIds);
    _incomingConnections = await usersCollection.getIncomingConnections(
        _user.id, _user.blockedUserIds);
    _incomingConnections.removeWhere((user) => user.isEmpty());
    if (notify) {
      notifyListeners();
    }
  }

  Future<void> getSearchedPaginated({String? searchText}) async {
    try {
      if (!_isEndOfSearchedListReached) {
        final fetchedSearchUsers = await usersCollection.getSearchedPaginated(
            blockedUserIds: _user.blockedUserIds,
            limit: paginationLimit,
            userId: _user.id,
            lastSearchedUser:
                _searchUsers.isNotEmpty ? _searchUsers.last : null,
            searchText: searchText ?? '');

        _isEndOfSearchedListReached =
            fetchedSearchUsers.length < paginationLimit;

        fetchedSearchUsers.removeWhere((user) => user.isEmpty());

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

  Future<void> blockUser(String userId) async {
    await disconnectFromUser(userId);

    _user.blockUser(userId);
    await usersCollection.update(_user);

    blockedUsers.add(await usersCollection.getById(userId));
    _searchUsers.removeWhere((user) => user.id == userId);
    notifyListeners();
  }

  Future<void> unblockUser(String userId) async {
    _user.unblockUser(userId);
    await usersCollection.update(_user);
    blockedUsers.removeWhere((user) => user.id == userId);
    notifyListeners();
  }

  // TODO: maybe paginate in future
  Future<void> getBlockedUser() async {
    await getUser(notify: false);
    _blockedUsers = await usersCollection.getByUserIds(_user.blockedUserIds);
    notifyListeners();
  }
}
