import 'package:challenge/collections/search_challenges_collection.dart';
import 'package:challenge/enums/challenge_category_enum.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:flutter/material.dart';

class SearchChallengesProvider with ChangeNotifier {
  final searchChallengesCollection = SearchChallengesCollection();
  final authService = AuthService();

  List<ChallengeModel> _searchChallenges = [];
  List<ChallengeModel> get searchChallenges => _searchChallenges;

  bool _isEndOfSearchedListReached = false;
  bool get isEndOfSearchedListReached => _isEndOfSearchedListReached;

  final int paginationLimit = 20;

  Future<void> getSearchedPaginated(
      {String searchText = '',
      List<ChallengeCategoryEnum> categories = const []}) async {
    try {
      if (!_isEndOfSearchedListReached) {
        final fetchedSearchChallenges =
            await searchChallengesCollection.getSearchedPaginated(
                limit: paginationLimit,
                lastSearchChallenge: _searchChallenges.isNotEmpty
                    ? _searchChallenges.last
                    : null,
                searchText: searchText,
                categories: categories);

        _isEndOfSearchedListReached =
            fetchedSearchChallenges.length < paginationLimit;

        _searchChallenges.addAll(fetchedSearchChallenges);

        notifyListeners();
      }
    } on Exception {
      rethrow;
    }
  }

  Future<void> getRandomPaginated() async {
    try {
      if (!_isEndOfSearchedListReached) {
        List<ChallengeModel> copySearchChallenges =
            List.from(_searchChallenges);
        copySearchChallenges.sort((a, b) => a.id.compareTo(b.id));
        final fetchedSearchChallenges =
            await searchChallengesCollection.getRandomPaginated(
                limit: paginationLimit,
                lastSearchChallenge: copySearchChallenges.isNotEmpty
                    ? copySearchChallenges.last
                    : null);

        _isEndOfSearchedListReached =
            fetchedSearchChallenges.length < paginationLimit;

        _searchChallenges.addAll(fetchedSearchChallenges);

        notifyListeners();
      }
    } on Exception {
      rethrow;
    }
  }

  resetEndOfSearchedList() {
    _isEndOfSearchedListReached = false;
  }

  emptySearchChallenges() {
    _searchChallenges.clear();
  }

  Future<void> refresh() async {
    try {
      resetEndOfSearchedList();
      _searchChallenges = await searchChallengesCollection.refresh(
          loadedSearchChallenges: _searchChallenges);
      notifyListeners();
    } on Exception {
      rethrow;
    }
  }
}
