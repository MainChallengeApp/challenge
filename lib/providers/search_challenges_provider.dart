import 'dart:async';

import 'package:async/async.dart';
import 'package:challenge/collections/search_challenges_collection.dart';
import 'package:challenge/enums/challenge_category_enum.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:flutter/material.dart';

class SearchChallengesProvider with ChangeNotifier {
  final searchChallengesCollection = SearchChallengesCollection();
  final authService = AuthService();

  final List<ChallengeModel> _searchChallenges = [];
  List<ChallengeModel> get searchChallenges => _searchChallenges;

  bool _isEndOfSearchedListReached = false;
  bool get isEndOfSearchedListReached => _isEndOfSearchedListReached;

  final int paginationLimit = 20;

  CancelableOperation? _operation;

  Future<void> getSearchedPaginated(
      {String searchText = '',
      List<ChallengeCategoryEnum> categories = const [],
      bool isInit = false}) async {
    try {
      if (!_isEndOfSearchedListReached || isInit) {
        final fetchedSearchChallenges =
            await searchChallengesCollection.getSearchedPaginated(
                limit: paginationLimit,
                lastSearchChallenge: isInit || _searchChallenges.isEmpty
                    ? null
                    : _searchChallenges.last,
                searchText: searchText,
                categories: categories);

        _isEndOfSearchedListReached =
            fetchedSearchChallenges.length < paginationLimit;

        if (isInit) {
          _searchChallenges.clear();
        }

        _searchChallenges.addAll(fetchedSearchChallenges);

        notifyListeners();
      }
    } on Exception {
      rethrow;
    }
  }

  Future<void> initSearchChallenges(
      {String? searchText, List<ChallengeCategoryEnum>? categories}) async {
    _operation?.cancel();

    _searchChallenges.clear();
    _isEndOfSearchedListReached = false;

    _operation = CancelableOperation.fromFuture(getSearchedPaginated(
        searchText: searchText ?? '', categories: categories ?? []));
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

  Future<void> initRandomChallenges() async {
    _searchChallenges.clear();
    _isEndOfSearchedListReached = false;
    await getRandomPaginated();
  }
}
