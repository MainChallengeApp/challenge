import 'package:challenge/enums/challenge_status_enum.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParticipantModel {
  String? id; // the same as userId but i can not filter by FieldPath.documentId
  static const String idField = 'id';

  String userId;
  static const String userIdField = 'userId';

  List<AttemptModel> attempts;
  static const String attemptsField = 'attempts';

  ParticipantModel({
    this.id,
    required this.userId,
    this.attempts = const [],
  });

  static ParticipantModel fromChallengeModel(
      {required ChallengeModel challenge, required String userId}) {
    return ParticipantModel(
      userId: userId,
      attempts: [AttemptModel.fromChallengeModel(challenge: challenge)],
    );
  }

  Map<String, dynamic> toDoc() {
    return {
      userIdField: userId,
      attemptsField: attempts.map((attempt) => attempt.toDoc()).toList(),
    };
  }

  static ParticipantModel fromDoc(DocumentSnapshot doc) {
    try {
      return ParticipantModel(
          id: doc.id,
          userId: doc[userIdField],
          attempts: doc[attemptsField] != null
              ? List<AttemptModel>.from(doc[attemptsField]
                  .map((attempt) => AttemptModel.fromDoc(attempt)))
              : []);
    } on Exception {
      rethrow;
    }
  }

  AttemptModel getLatestAttempt() {
    if (attempts.isEmpty) throw Exception('No attempts found');
    attempts.sort((a, b) => a.number.compareTo(b.number));
    return attempts.last;
  }

  ParticipantModel copy() {
    return ParticipantModel(
      userId: userId,
      attempts: AttemptModel.copyList(attempts),
    );
  }

  static copyList(List<ParticipantModel> participants) {
    return participants.map((participant) => participant.copy()).toList();
  }

  void addAttempt(GroupChallengeModel groupChallenge) {
    AttemptModel lastAttempt = getLatestAttempt();
    attempts.add(AttemptModel(
      number: lastAttempt.number + 1,
      startDate: null,
      endDate: null,
      status: ChallengeStatusEnum.backlog,
      acceptanceCriteria:
          lastAttempt.getAcceptanceCriteria(groupChallenge).copy(),
      frequency: lastAttempt.getFrequency(groupChallenge).copy(),
      media: [],
      repetitions: [],
    ));
  }
}
