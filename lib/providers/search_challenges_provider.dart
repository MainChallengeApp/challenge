import 'package:challenge/collections/search_challenges_collection.dart';
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

  int paginationLimit = 20;

  Future<void> getSearchedPaginated({String searchText = ''}) async {
    try {
      if (!_isEndOfSearchedListReached) {
        final fetchedSearchChallenges =
            await searchChallengesCollection.getSearchedPaginated(
                limit: paginationLimit,
                lastSearchChallenge: _searchChallenges.isNotEmpty
                    ? _searchChallenges.last
                    : null,
                searchText: searchText);

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
    notifyListeners();
  }

  Future<void> refresh() async {
    try {
      _searchChallenges = await searchChallengesCollection.refresh(
          loadedSearchChallenges: _searchChallenges);
      notifyListeners();
    } on Exception {
      rethrow;
    }
  }
}
