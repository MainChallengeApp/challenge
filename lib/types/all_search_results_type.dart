import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/user/user_model.dart';

class AllSearchResultsType {
  ChallengeModel? searchChallenge;
  UserModel? searchUser;

  AllSearchResultsType.challenge({
    required this.searchChallenge,
  });

  AllSearchResultsType.user({
    required this.searchUser,
  });

  get() => searchChallenge ?? searchUser;

  static sortList(List<dynamic> list) {
    list.sort((a, b) {
      if (a is ChallengeModel && b is ChallengeModel) {
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      } else if (a is UserModel && b is UserModel) {
        return a.username.toLowerCase().compareTo(b.username.toLowerCase());
      } else if (a is ChallengeModel && b is UserModel) {
        return a.title.toLowerCase().compareTo(b.username.toLowerCase());
      } else if (a is UserModel && b is ChallengeModel) {
        return a.username.toLowerCase().compareTo(b.title.toLowerCase());
      } else {
        return 0;
      }
    });
  }
}
