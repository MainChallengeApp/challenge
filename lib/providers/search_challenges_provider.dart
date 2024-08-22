import 'package:challenge/collections/search_challenges_collection.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:flutter/material.dart';

class SearchChallengesProvider with ChangeNotifier {
  final searchChallengesDatabase = SearchChallengesCollection();
  final authService = AuthService();

  List<ChallengeModel> _searchChallenges = [];
  List<ChallengeModel> get searchChallenges => _searchChallenges;

  Future<List<ChallengeModel>> getAll() async {
    try {
      _searchChallenges = await searchChallengesDatabase.getAll();
      notifyListeners();
      return _searchChallenges;
    } on Exception {
      rethrow;
    }
  }
}
