import 'package:challenge/database/database.dart';
import 'package:challenge/models/challenge/challenge_model.dart';

class SearchChallengesDatabase extends Database {
  static String collectionName = 'search_challenges';

  SearchChallengesDatabase() : super(collection: collectionName);

  Future<void> create(ChallengeModel challenge) async {
    challenge.id = db.collection(collection).doc().id;
    await db.collection(collection).doc().set(challenge.toDoc());
  }

  Future<void> createMany(List<ChallengeModel> challenges) async {
    final batch = db.batch();
    for (var challenge in challenges) {
      final ref = db.collection(collection).doc();
      batch.set(ref, challenge.toDoc());
    }
    await batch.commit();
  }

  Future<List<ChallengeModel>> getAll() async {
    try {
      final querySnapshot = await db.collection(collection).get();
      return querySnapshot.docs
          .map((doc) => ChallengeModel.fromDoc(doc))
          .toList();
    } on Exception {
      rethrow;
    }
  }

  Future<ChallengeModel> getById(String id) async {
    try {
      final doc = await db.collection(collection).doc(id).get();
      return ChallengeModel.fromDoc(doc);
    } on Exception {
      rethrow;
    }
  }
}
