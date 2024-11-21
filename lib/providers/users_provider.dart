import 'dart:async';

import 'package:challenge/collections/users_collection.dart';
import 'package:challenge/enums/notification_type_enum.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/notifications_provider.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/services/media_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersProvider with ChangeNotifier {
  UsersCollection usersCollection = UsersCollection();
  AuthService authService = AuthService();
  MediaService mediaService = MediaService();

  UserModel _user = UserModel.empty();
  UserModel get user => _user;

  final List<UserModel> _searchUsers = [];
  List<UserModel> get searchUsers => _searchUsers;
  bool _isEndOfSearchedListReached = false;
  bool get isEndOfSearchedListReached => _isEndOfSearchedListReached;

  List<UserModel> _confirmedConnections = [];
  List<UserModel> get confirmedConnections => _confirmedConnections;

  List<UserModel> _openConnectionRequests = [];
  List<UserModel> get openConnectionRequests => _openConnectionRequests;

  List<UserModel> _openConnectionResponses = [];
  List<UserModel> get openConnectionResponses => _openConnectionResponses;

  List<UserModel> _blockedUsers = [];
  List<UserModel> get blockedUsers => _blockedUsers;

  final int paginationLimit = 10;

  final BuildContext context;

  late final notificationsProvider =
      Provider.of<NotificationsProvider>(context);

  UsersProvider({required this.context});

  Future<void> createUser() async {
    final user = UserModel(
      id: authService.getCurrentUserId(),
      username: '',
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

  Future<UserModel> getUserById(String id) async {
    return await usersCollection.getById(id);
  }

  Future<List<UserModel>> getUsersByIds(List<String> userIds) async {
    return await usersCollection.getByUserIds(userIds);
  }

  update(UserModel user) async {
    user.pictureUrl = await mediaService.uploadLocalUserPicture(user);
    _user = user;
    await usersCollection.update(_user);
    notifyListeners();
  }

  updateUsername(UserModel editUser) async {
    if (!(await usersCollection.isUsernameUnique(editUser.username))) {
      return false;
    }
    _user.username = editUser.username;
    await usersCollection.update(_user);
    notifyListeners();
    return true;
  }

  void resetLocalUser() {
    _user = UserModel.empty();
    notifyListeners();
  }

  Future<void> connectToUser(String otherUserId) async {
    _user.connect(otherUserId);
    await usersCollection.update(_user);
    await getConnections();

    await notificationsProvider.deleteNotificationsBetweenUsers(
        currentUserId: _user.id,
        otherUserId: otherUserId,
        type: NotificationTypeEnum.connectionRequest);
    UserModel otherUser = await usersCollection.getById(otherUserId);
    if (otherUser.connectionIds.contains(_user.id)) {
      await notificationsProvider.sendConnectionAcceptedNotification(
          otherUser, _user);
    } else {
      await notificationsProvider.sendConnectionRequestNotification(
          otherUser, _user);
    }
    notifyListeners();
  }

  Future<void> disconnectFromUser(String id) async {
    UserModel otherUser = await usersCollection.getById(id);

    _user.disconnect(id);
    otherUser.disconnect(_user.id);

    await usersCollection.update(_user);
    await usersCollection.update(otherUser);

    await notificationsProvider.deleteNotificationsBetweenUsers(
        currentUserId: _user.id,
        otherUserId: id,
        type: NotificationTypeEnum.connectionAccepted);

    await notificationsProvider.deleteNotificationsBetweenUsers(
        currentUserId: _user.id,
        otherUserId: id,
        type: NotificationTypeEnum.connectionRequest);

    await getConnections();
    notifyListeners();
  }

  Future<void> getConnections({bool notify = true}) async {
    await getUser(notify: false);

    List<UserModel> outgoingConnections =
        await usersCollection.getByUserIds(_user.connectionIds);
    List<UserModel> incomingConnections = await usersCollection
        .getIncomingConnections(_user.id, user.blockedUserIds);
    incomingConnections.removeWhere((user) => user.isEmpty());

    _confirmedConnections = outgoingConnections
        .where((connection) => connection.isConnectedWith(_user))
        .toList();

    _openConnectionRequests = outgoingConnections
        .where((connection) => !connection.isConnectedWith(_user))
        .toList();

    _openConnectionResponses = incomingConnections
        .where((connection) => !_user.isConnectedWith(connection))
        .toList();

    if (notify) {
      notifyListeners();
    }
  }

  Future<void> getSearchedPaginated(
      {String? searchText, bool isInit = false}) async {
    try {
      if (!_isEndOfSearchedListReached || isInit) {
        final fetchedSearchUsers = await usersCollection.getSearchedPaginated(
            blockedUserIds: _user.blockedUserIds,
            limit: paginationLimit,
            userId: _user.id,
            lastSearchedUser:
                isInit || _searchUsers.isEmpty ? null : _searchUsers.last,
            searchText: searchText ?? '');

        _isEndOfSearchedListReached =
            fetchedSearchUsers.length < paginationLimit;

        if (isInit) {
          _searchUsers.clear();
        }

        fetchedSearchUsers.removeWhere((user) => user.isEmpty());

        _searchUsers.addAll(fetchedSearchUsers);

        notifyListeners();
      }
    } on Exception {
      rethrow;
    }
  }

  Future<void> initSearchUsers({String? searchText}) async {
    _searchUsers.clear();
    _isEndOfSearchedListReached = false;
    await getSearchedPaginated(searchText: searchText);
  }

  Future<void> blockUser(String userId) async {
    await disconnectFromUser(userId);

    _user.blockUser(userId);
    await usersCollection.update(_user);

    blockedUsers.add(await usersCollection.getById(userId));
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

  void logout() {
    resetLocalUser();
    authService.logout();
  }
}
