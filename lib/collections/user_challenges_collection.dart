import 'package:challenge/collections/collection.dart';
import 'package:challenge/models/challenge/user_challenge_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserChallengesCollection extends Collection {
  static String collectionName = 'user_challenges';

  late CollectionReference<UserChallengeModel> collection = db
      .collection(collectionName)
      .withConverter<UserChallengeModel>(
          fromFirestore: (snapshot, _) => UserChallengeModel.fromDoc(snapshot),
          toFirestore: (userChallenge, _) => userChallenge.toDoc());

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
      final querySnapshot = await collection
          .where(UserChallengeModel.userIdField, isEqualTo: userId)
          .get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
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

  Future<int> getAmountOfChallengesByUserId(String userId) async {
    try {
      final querySnapshot = await db
          .collection(name)
          .where(UserChallengeModel.userIdField, isEqualTo: userId)
          .get();
      return querySnapshot.docs.length;
    } on Exception {
      rethrow;
    }
  }
}
