import 'package:challenge/database/search_challenges_database.dart';
import 'package:challenge/models/challenge/challenge_model.dart';

class SearchChallengesService {
  final SearchChallengesDatabase searchChallengesDatabase =
      SearchChallengesDatabase();

  Future<void> createMany(List<ChallengeModel> challenges) async {
    await searchChallengesDatabase.createMany(challenges);
  }

  Future<List<ChallengeModel>> getAll() async {
    return await searchChallengesDatabase.getAll();
  }
}
