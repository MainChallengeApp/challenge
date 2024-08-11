import 'package:challenge/database/database.dart';
import 'package:challenge/models/challenge/user_challenge_model.dart';

class UserChallengesDatabase extends Database {
  UserChallengesDatabase() {
    collection = 'user_challenges';
  }

  Future<void> create(UserChallengeModel userChallenge) async {
    await db.collection(collection).add(userChallenge.toDoc());
  }

  Future<void> createMany(List<UserChallengeModel> userChallenges) async {
    final batch = db.batch();
    for (var userChallenge in userChallenges) {
      final ref = db.collection(collection).doc();
      batch.set(ref, userChallenge.toDoc());
    }
    await batch.commit();
  }

  Future<List<UserChallengeModel>> getAllByUserId(
      {required String userId}) async {
    try {
      final querySnapshot = await db
          .collection(collection)
          .where('userId', isEqualTo: userId)
          .get();
      return querySnapshot.docs
          .map((doc) => UserChallengeModel.fromDoc(doc))
          .toList();
    } on Exception {
      rethrow;
    }
  }

  Future<UserChallengeModel> getById(String id) async {
    try {
      final doc = await db.collection(collection).doc(id).get();
      return UserChallengeModel.fromDoc(doc);
    } on Exception {
      rethrow;
    }
  }
}
