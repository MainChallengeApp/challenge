import 'package:challenge/collections/collection.dart';
import 'package:challenge/enums/challenge_category_enum.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchChallengesCollection extends Collection {
  static String collectionName = 'search_challenges';

  SearchChallengesCollection() : super(name: collectionName);

  Future<List<ChallengeModel>> getSearchedPaginated(
      {ChallengeModel? lastSearchChallenge,
      int limit = 10,
      String searchText = '',
      List<ChallengeCategoryEnum> categories = const []}) async {
    try {
      final querySnapshot = await db
          .collection(name)
          .orderBy(ChallengeModel.titleLowerCaseField)
          .where(ChallengeModel.categoriesField,
              arrayContainsAny: categories.isEmpty
                  ? ChallengeCategoryEnum.toDocs(ChallengeCategoryEnum.values)
                  : ChallengeCategoryEnum.toDocs(categories))
          .where(ChallengeModel.titleLowerCaseField,
              isGreaterThanOrEqualTo: searchText.toLowerCase())
          .where(ChallengeModel.titleLowerCaseField,
              isLessThanOrEqualTo: '${searchText.toLowerCase()}z')
          .startAfter([lastSearchChallenge?.titleLowerCase ?? ''])
          .limit(limit)
          .get();
      return querySnapshot.docs
          .map((doc) => ChallengeModel.fromDoc(doc))
          .toList();
    } on Exception {
      rethrow;
    }
  }

  Future<List<ChallengeModel>> getRandomPaginated(
      {required int limit, ChallengeModel? lastSearchChallenge}) async {
    final querySnapshot = await db
        .collection(name)
        .orderBy(FieldPath.documentId)
        .startAfter([lastSearchChallenge?.id ?? '0'])
        .limit(limit)
        .get();
    List<ChallengeModel> challenges =
        querySnapshot.docs.map((doc) => ChallengeModel.fromDoc(doc)).toList();
    challenges.shuffle();
    return challenges;
  }

  Future<List<ChallengeModel>> refresh(
      {required List<ChallengeModel> loadedSearchChallenges}) async {
    try {
      final idsToFetch =
          loadedSearchChallenges.take(10).map((e) => e.id).toList();

      final querySnapshot = await db
          .collection(name)
          .where(FieldPath.documentId, whereIn: idsToFetch)
          .get();

      // Create a map of id to ChallengeModel for quick lookup
      final challengesMap = {
        for (var doc in querySnapshot.docs) doc.id: ChallengeModel.fromDoc(doc)
      };

      // Reconstruct the list in the original order
      return idsToFetch
          .map((id) => challengesMap[id])
          .where((challenge) => challenge != null)
          .cast<ChallengeModel>()
          .toList();
    } on Exception {
      rethrow;
    }
  }
}
