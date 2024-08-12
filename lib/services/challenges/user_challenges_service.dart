import 'package:challenge/database/user_challenges_database.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/user_challenge_model.dart';
import 'package:challenge/services/auth/auth_service.dart';

class UserChallengesService {
  final userChallengesDatabase = UserChallengesDatabase();
  final authService = AuthService();

  Future<void> create(ChallengeModel challenge) async {
    final userChallenge = UserChallengeModel.fromChallengeModel(
      challenge: challenge,
      userId: authService.getCurrentUserId(),
    );

    try {
      await userChallengesDatabase.create(userChallenge);
    } on Exception {
      rethrow;
    }
  }

  Future<List<UserChallengeModel>> getAllOfUser() async {
    try {
      return await userChallengesDatabase.getAllByUserId(
          userId: authService.getCurrentUserId());
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
    } catch (e) {
      rethrow;
    }
  }

  // delete user challenge
  Future<void> delete(UserChallengeModel userChallenge) async {
    try {
      await userChallengesDatabase.delete(userChallenge);
    } on Exception {
      rethrow;
    }
  }
}
