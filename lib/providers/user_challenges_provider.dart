import 'package:challenge/collections/user_challenges_collection.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/user_challenge_model.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/services/storage_service.dart';
import 'package:flutter/material.dart';

class UserChallengesProvider with ChangeNotifier {
  final userChallengesCollection = UserChallengesCollection();
  final authService = AuthService();
  final storageService = StorageService();
  final mediaService = MediaService();

  List<UserChallengeModel> _userChallenges = [];

  List<UserChallengeModel> get userChallenges => _userChallenges;

  Future<UserChallengeModel> create(ChallengeModel challenge) async {
    final userChallenge = UserChallengeModel.fromChallengeModel(
      challenge: challenge,
      userId: authService.getCurrentUserId(),
    );
    _userChallenges.insert(0, userChallenge);
    sortLocalList();
    try {
      return await createOnline(userChallenge);
    } on Exception {
      rethrow;
    }
  }

  Future<UserChallengeModel> createOnline(
      UserChallengeModel userChallenge) async {
    try {
      UserChallengeModel newUserChallenge =
          await userChallengesCollection.create(userChallenge);

      if (newUserChallenge.hasThumbnail() &&
          mediaService.isUrlLocal(newUserChallenge.thumbnail!.url)) {
        newUserChallenge.thumbnail!.url =
            await mediaService.uploadLocalThumbnail(
                newUserChallenge.id, newUserChallenge.thumbnail!.url);
        update(newUserChallenge);
      }

      _userChallenges = await getAllOfUser();
      sortLocalList();
      return newUserChallenge;
    } on Exception {
      rethrow;
    }
  }

  getAllOfUser() async {
    try {
      _userChallenges = await userChallengesCollection.getAllByUserId(
          userId: authService.getCurrentUserId());
      sortLocalList();
      return _userChallenges;
    } on Exception {
      rethrow;
    }
  }

  Future<UserChallengeModel> getById(String id) async {
    try {
      return await userChallengesCollection.getById(id);
    } on Exception {
      rethrow;
    }
  }

  update(UserChallengeModel userChallenge) async {
    try {
      if (userChallenge.hasThumbnail() &&
          mediaService.isUrlLocal(userChallenge.thumbnail!.url)) {
        userChallenge.thumbnail!.url = await mediaService.uploadLocalThumbnail(
            userChallenge.id, userChallenge.thumbnail!.url);
      }

      for (var media in userChallenge.media) {
        if (media.isLocal()) {
          mediaService.uploadLocalMedia(media, userChallenge).then((newMedia) {
            if (newMedia != null) {
              media.source = newMedia.source;
              update(userChallenge);
            }
          });
        }
      }

      int index = _userChallenges.indexWhere((uc) => uc.id == userChallenge.id);
      if (index != -1) {
        _userChallenges[index] = userChallenge;
        sortLocalList();
      }

      userChallengesCollection.update(userChallenge);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(UserChallengeModel userChallenge) async {
    try {
      int index = _userChallenges.indexWhere((uc) => uc.id == userChallenge.id);
      if (index != -1) {
        _userChallenges.removeAt(index);
        notifyListeners();
      }
      userChallengesCollection.delete(userChallenge);
      storageService.deleteFolderByPath(
          '${UserChallengesCollection.collectionName}/${userChallenge.id}');
    } on Exception {
      rethrow;
    }
  }

  start(UserChallengeModel userChallenge) {
    userChallenge.start();
    update(userChallenge);
  }

  end(UserChallengeModel userChallenge) {
    userChallenge.end();
    update(userChallenge);
  }

  void insertToLocalList(ChallengeModel challengeCopy) {
    _userChallenges.insert(
        0,
        UserChallengeModel.fromChallengeModel(
          challenge: challengeCopy,
          userId: authService.getCurrentUserId(),
        ));
    sortLocalList();
  }

  void sortLocalList() {
    _userChallenges =
        ChallengeModel.sortChallengeList(challenges: _userChallenges)
            as List<UserChallengeModel>;
    notifyListeners();
  }

  Future<int> getAmountOfChallengesByUserId(String userId) async {
    return await userChallengesCollection.getAmountOfChallengesByUserId(userId);
  }
}
