import 'package:challenge/database/user_challenges_database.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/user_challenge_model.dart';
import 'package:challenge/services/auth/auth_service.dart';

class UserChallengesService {
  final userChallengesDatabase = UserChallengesDatabase();
  final AuthService authService = AuthService();

  Future<void> create(ChallengeModel challenge) async {
    final userChallenge = UserChallengeModel(
      id: '',
      userId: authService.getCurrentUserId(),
      title: challenge.title,
      description: challenge.description,
      categories: challenge.categories,
      status: challenge.status,
      thumbnailPath: challenge.thumbnailPath,
      startDate: challenge.startDate,
      endDate: challenge.endDate,
      acceptanceCriteria: challenge.acceptanceCriteria,
      frequency: challenge.frequency,
      repetitions: challenge.repetitions,
      media: challenge.media,
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
}
