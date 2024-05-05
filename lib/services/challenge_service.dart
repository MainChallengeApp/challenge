import 'package:challenge/globals.dart';
import 'package:challenge/json_file_controller/challenge_controller.dart';
import 'package:challenge/models/challenge_model.dart';

class ChallengeService {
  ChallengeController challengeController = ChallengeController();

  void startChallenge(ChallengeModel challenge) {
    if (challenge.isInBacklog()) {
      challenge.start();
    }
    if (challenge.getCurrentRepetition() != null &&
        challenge.getCurrentRepetition()!.isInBacklog()) {
      challenge.getCurrentRepetition()!.start();
    }
    allChallengesList = allChallengesList.map((e) {
      return e.id == challenge.id ? challenge : e;
    }).toList();
    challengeList =
        challengeList.map((e) => e.id == challenge.id ? challenge : e).toList();
    challengeController.writeFile(allChallengesList);
  }

  void endRepetition(ChallengeModel challenge) {
    challenge.endRepetition();
    allChallengesList = allChallengesList.map((e) {
      return e.id == challenge.id ? challenge : e;
    }).toList();
    challengeList =
        challengeList.map((e) => e.id == challenge.id ? challenge : e).toList();
    challengeController.writeFile(allChallengesList);
  }
}
