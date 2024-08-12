import 'package:challenge/database/search_challenges_database.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class SearchChallengesProvider with ChangeNotifier {
  final searchChallengesDatabase = SearchChallengesDatabase();
  final authService = AuthService();

  List<ChallengeModel> _searchChallenges = [];
  List<ChallengeModel> get searchChallenges => _searchChallenges;

  Future<void> getAll() async {
    try {
      _searchChallenges = await searchChallengesDatabase.getAll();
      notifyListeners();
    } on Exception {
      rethrow;
    }
  }
}
