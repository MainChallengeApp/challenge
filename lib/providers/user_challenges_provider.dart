import 'package:challenge/database/user_challenges_database.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/user_challenge_model.dart';
import 'package:challenge/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class UserChallengesProvider with ChangeNotifier {
  final userChallengesDatabase = UserChallengesDatabase();
  final authService = AuthService();

  List<UserChallengeModel> _userChallenges = [];
  List<UserChallengeModel> get userChallenges => _userChallenges;

  Future<UserChallengeModel> create(ChallengeModel challenge) async {
    final userChallenge = UserChallengeModel.fromChallengeModel(
      challenge: challenge,
      userId: authService.getCurrentUserId(),
    );
    try {
      UserChallengeModel userChallengeInDb =
          await userChallengesDatabase.create(userChallenge);
      _userChallenges = await getAllOfUser();
      notifyListeners();
      return userChallengeInDb;
    } on Exception {
      rethrow;
    }
  }

  getAllOfUser() async {
    try {
      _userChallenges = await userChallengesDatabase.getAllByUserId(
          userId: authService.getCurrentUserId());
      sortLocalList();
      notifyListeners();
      return _userChallenges;
    } on Exception {
      rethrow;
    }
  }

  Future<UserChallengeModel> getById(String id) async {
    try {
      return await userChallengesDatabase.getById(id);
    } on Exception {
      rethrow;
    }
  }

  Future<void> update(UserChallengeModel userChallenge) async {
    try {
      await userChallengesDatabase.update(userChallenge);
      _userChallenges = await getAllOfUser();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // delete user challenge
  Future<void> delete(UserChallengeModel userChallenge) async {
    try {
      await userChallengesDatabase.delete(userChallenge);
      int index = _userChallenges.indexWhere((uc) => uc.id == userChallenge.id);
      if (index != -1) {
        _userChallenges.removeAt(index);
        notifyListeners();
      }
    } on Exception {
      rethrow;
    }
  }

  startChallenge(UserChallengeModel userChallenge) async {
    userChallenge.start();
    await update(userChallenge);
  }

  void insertToLocalList(ChallengeModel challengeCopy) {
    _userChallenges.insert(
        0,
        UserChallengeModel.fromChallengeModel(
          challenge: challengeCopy,
          userId: authService.getCurrentUserId(),
        ));
    sortLocalList();
    notifyListeners();
  }

  void updateLocalList(UserChallengeModel userChallenge) {
    int index = _userChallenges.indexWhere((uc) => uc.id == userChallenge.id);
    if (index != -1) {
      _userChallenges[index] = userChallenge;
      sortLocalList();
      notifyListeners();
    }
  }

  void sortLocalList() {
    _userChallenges =
        ChallengeModel.sortChallengeList(challenges: _userChallenges)
            as List<UserChallengeModel>;
    notifyListeners();
  }

  getLocalIndex(String userChallengeId) {
    return _userChallenges.indexWhere((uc) => uc.id == userChallengeId);
  }
}
