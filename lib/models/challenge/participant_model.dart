import 'package:challenge/enums/challenge_status_enum.dart';
import 'package:challenge/enums/participant_status_enum.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParticipantModel {
  String? id; // the same as userId but i can not filter by FieldPath.documentId
  static const String idField = 'id';

  UserModel user;
  static const String userIdField = 'userId';

  List<AttemptModel> attempts;
  static const String attemptsField = 'attempts';

  ParticipantStatusEnum status;
  static const String statusField = 'status';

  ParticipantModel({
    this.id,
    required this.user,
    this.attempts = const [],
    required this.status,
  });

  static ParticipantModel fromChallengeModel(
      {required ChallengeModel challenge,
      required UserModel user,
      required ParticipantStatusEnum status}) {
    return ParticipantModel(
      user: user,
      attempts: [AttemptModel.fromChallengeModel(challenge: challenge)],
      status: status,
    );
  }

  Map<String, dynamic> toDoc() {
    return {
      userIdField: user.id,
      statusField: status.text,
      attemptsField: attempts.map((attempt) => attempt.toDoc()).toList(),
    };
  }

  static ParticipantModel fromDoc(DocumentSnapshot doc, UserModel user) {
    try {
      return ParticipantModel(
          id: doc.id,
          user: user,
          status: ParticipantStatusEnum.fromString(doc[statusField]),
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
      user: user,
      status: status,
      attempts: AttemptModel.copyList(attempts),
    );
  }

  void acceptChallengeRequest() {
    status = ParticipantStatusEnum.accepted;
  }

  static List<ParticipantModel> copyList(List<ParticipantModel> participants) {
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

  bool isAccepted() {
    return status == ParticipantStatusEnum.accepted;
  }
}
