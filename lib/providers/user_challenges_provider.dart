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

  Future<void> create(ChallengeModel challenge) async {
    final userChallenge = UserChallengeModel.fromChallengeModel(
      challenge: challenge,
      userId: authService.getCurrentUserId(),
    );
    _userChallenges.insert(0, userChallenge);
    sortLocalList();
    try {
      createOnline(userChallenge);
    } on Exception {
      rethrow;
    }
  }

  createOnline(UserChallengeModel userChallenge) async {
    try {
      await userChallengesDatabase.create(userChallenge);
      _userChallenges = await getAllOfUser();
      sortLocalList();
    } on Exception {
      rethrow;
    }
  }

  getAllOfUser() async {
    try {
      _userChallenges = await userChallengesDatabase.getAllByUserId(
          userId: authService.getCurrentUserId());
      sortLocalList();
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

  // TODO: replace raw updates with specific methods like in start and end
  update(UserChallengeModel userChallenge) {
    try {
      int index = _userChallenges.indexWhere((uc) => uc.id == userChallenge.id);
      if (index != -1) {
        _userChallenges[index] = userChallenge;
        sortLocalList();
      }

      userChallengesDatabase.update(userChallenge);
    } catch (e) {
      rethrow;
    }
  }

  // delete user challenge
  Future<void> delete(UserChallengeModel userChallenge) async {
    try {
      int index = _userChallenges.indexWhere((uc) => uc.id == userChallenge.id);
      if (index != -1) {
        _userChallenges.removeAt(index);
        notifyListeners();
      }
      userChallengesDatabase.delete(userChallenge);
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
}
