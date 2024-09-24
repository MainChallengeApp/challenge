import 'package:challenge/collections/search_challenges_collection.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:flutter/material.dart';

class SearchChallengesProvider with ChangeNotifier {
  final searchChallengesCollection = SearchChallengesCollection();
  final authService = AuthService();

  List<ChallengeModel> _searchChallenges = [];
  List<ChallengeModel> get searchChallenges => _searchChallenges;

  bool _isEndOfListReached = false;
  bool get isEndOfListReached => _isEndOfListReached;

  Future<List<ChallengeModel>> getAll() async {
    try {
      _searchChallenges = await searchChallengesCollection.getAll();
      _isEndOfListReached = true;
      notifyListeners();
      return _searchChallenges;
    } on Exception {
      rethrow;
    }
  }

  Future<void> getAllPaginated({int limit = 10}) async {
    if (_isEndOfListReached) {
      return;
    }
    try {
      final fetchedSearchChallenges =
          await searchChallengesCollection.getAllPaginated(
              lastSearchChallenge:
                  searchChallenges.isNotEmpty ? searchChallenges.last : null);

      if (fetchedSearchChallenges.length < limit) {
        _isEndOfListReached = true;
      }

      _searchChallenges.addAll(fetchedSearchChallenges);
      notifyListeners();
    } on Exception {
      rethrow;
    }
  }

  Future<void> refresh() async {
    try {
      _searchChallenges = await searchChallengesCollection.refresh(
          lastSearchChallenge:
              _searchChallenges.isEmpty ? null : _searchChallenges.last);
      notifyListeners();
    } on Exception {
      rethrow;
    }
  }
}
