import 'package:challenge/collections/collection.dart';
import 'package:challenge/models/challenge/challenge_model.dart';

class SearchChallengesCollection extends Collection {
  static String collectionName = 'search_challenges';

  SearchChallengesCollection() : super(name: collectionName);

  Future<void> create(ChallengeModel challenge) async {
    challenge.id = db.collection(name).doc().id;
    await db.collection(name).doc().set(challenge.toDoc());
  }

  Future<void> createMany(List<ChallengeModel> challenges) async {
    final batch = db.batch();
    for (var challenge in challenges) {
      final ref = db.collection(name).doc();
      batch.set(ref, challenge.toDoc());
    }
    await batch.commit();
  }

  Future<List<ChallengeModel>> getAll() async {
    try {
      final querySnapshot = await db.collection(name).get();
      return querySnapshot.docs
          .map((doc) => ChallengeModel.fromDoc(doc))
          .toList();
    } on Exception {
      rethrow;
    }
  }

  Future<ChallengeModel> getById(String id) async {
    try {
      final doc = await db.collection(name).doc(id).get();
      return ChallengeModel.fromDoc(doc);
    } on Exception {
      rethrow;
    }
  }
}
