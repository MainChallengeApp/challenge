import 'package:challenge/globals.dart';
import 'package:challenge/json_file_controller/challenge_controller.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/progress_model.dart';
import 'package:challenge/models/challenge/repetition_model.dart';
import 'package:challenge/models/challenge/user_challenge_model.dart';

class ChallengeService {
  ChallengeController challengeController = ChallengeController();

  void startChallenge(ChallengeModel challenge) {
    if (challenge.isInBacklog()) {
      challenge.start();
    } else if (challenge.getCurrentRepetition() != null &&
        challenge.getCurrentRepetition()!.isInBacklog()) {
      challenge.getCurrentRepetition()!.start();
    }
    allChallengesList = allChallengesList.map((e) {
      return e.id == challenge.id ? challenge : e;
    }).toList() as List<UserChallengeModel>;
    challengeList = challengeList
        .map((e) => e.id == challenge.id ? challenge : e)
        .toList() as List<UserChallengeModel>;
    challengeController.writeFile(allChallengesList);
  }

  void nextRepetition(ChallengeModel challenge) {
    challenge.endRepetition();
    allChallengesList = allChallengesList.map((e) {
      return e.id == challenge.id ? challenge : e;
    }).toList() as List<UserChallengeModel>;
    challengeList = challengeList
        .map((e) => e.id == challenge.id ? challenge : e)
        .toList() as List<UserChallengeModel>;
    challengeController.writeFile(allChallengesList);
  }

  void endChallenge(ChallengeModel challenge) {
    challenge.end();
    allChallengesList = allChallengesList.map((e) {
      return e.id == challenge.id ? challenge : e;
    }).toList() as List<UserChallengeModel>;
    challengeList = challengeList
        .map((e) => e.id == challenge.id ? challenge : e)
        .toList() as List<UserChallengeModel>;
    challengeController.writeFile(allChallengesList);
  }

  void addProgress() {
    // TODO: implement addProgress
  }

  void deleteProgress(ChallengeModel challenge, RepetitionModel repetition,
      ProgressModel progress) {
    repetition.deleteProgress(progress);
    allChallengesList = allChallengesList.map((e) {
      return e.id == challenge.id ? challenge : e;
    }).toList() as List<UserChallengeModel>;
    challengeList = challengeList
        .map((e) => e.id == challenge.id ? challenge : e)
        .toList() as List<UserChallengeModel>;
    challengeController.writeFile(allChallengesList);
  }
}
