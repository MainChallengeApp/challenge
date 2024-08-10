import 'package:challenge/database/database.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/user/user_model.dart';

class SearchChallengesDatabase extends Database {
  SearchChallengesDatabase() {
    collection = 'search_challenges';
  }

  Future<void> createSearchChallenge(ChallengeModel challenge) async {
    await db.collection(collection).doc(challenge.id).set(challenge.toDoc());
  }

  Future<UserModel> getUser(String id) async {
    try {
      final doc = await db.collection(collection).doc(id).get();
      return UserModel.fromMap(doc.data()!);
    } on Exception {
      rethrow;
    }
  }
}
