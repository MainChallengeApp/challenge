import 'package:challenge/collections/collection.dart';
import 'package:challenge/models/challenge/user_challenge_model.dart';

class UserChallengesCollection extends Collection {
  static String collectionName = 'user_challenges';

  UserChallengesCollection() : super(name: collectionName);

  Future<UserChallengeModel> create(UserChallengeModel userChallenge) async {
    final userChallengeDoc =
        await db.collection(name).add(userChallenge.toDoc());
    return UserChallengeModel.fromDoc(await userChallengeDoc.get());
  }

  Future<void> createMany(List<UserChallengeModel> userChallenges) async {
    final batch = db.batch();
    for (var userChallenge in userChallenges) {
      final ref = db.collection(name).doc();
      batch.set(ref, userChallenge.toDoc());
    }
    await batch.commit();
  }

  Future<List<UserChallengeModel>> getAllByUserId(
      {required String userId}) async {
    try {
      final querySnapshot =
          await db.collection(name).where('userId', isEqualTo: userId).get();
      return querySnapshot.docs
          .map((doc) => UserChallengeModel.fromDoc(doc))
          .toList();
    } on Exception {
      rethrow;
    }
  }

  Future<UserChallengeModel> getById(String id) async {
    try {
      final doc = await db.collection(name).doc(id).get();
      return UserChallengeModel.fromDoc(doc);
    } on Exception {
      rethrow;
    }
  }

  Future<void> update(UserChallengeModel userChallenge) async {
    try {
      await db
          .collection(name)
          .doc(userChallenge.id)
          .update(userChallenge.toDoc());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(UserChallengeModel userChallenge) {
    return db.collection(name).doc(userChallenge.id).delete();
  }
}
