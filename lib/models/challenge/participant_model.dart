import 'package:challenge/enums/challenge_status_enum.dart';
import 'package:challenge/enums/participant_status_enum.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/reminder_model.dart';
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

  ReminderModel? reminder;
  static const String reminderField = 'reminder';

  ParticipantModel({
    this.id,
    required this.user,
    this.attempts = const [],
    required this.status,
    this.reminder,
  });

  factory ParticipantModel.fromChallengeModel(
      {required ChallengeModel challenge,
      required UserModel user,
      required ParticipantStatusEnum status,
      ReminderModel? reminder}) {
    return ParticipantModel(
      user: user,
      attempts: [AttemptModel.fromChallengeModel(challenge: challenge)],
      status: status,
      reminder: reminder,
    );
  }

  factory ParticipantModel.empty() {
    return ParticipantModel(
      user: UserModel.empty(),
      attempts: [],
      status: ParticipantStatusEnum.accepted,
      reminder: null,
    );
  }

  Map<String, dynamic> toDoc() {
    return {
      userIdField: user.id,
      statusField: status.text,
      attemptsField: attempts.map((attempt) => attempt.toDoc()).toList(),
      reminderField: reminder?.toDoc(),
    };
  }

  static ParticipantModel fromDoc(DocumentSnapshot doc, UserModel user) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    if (data.isEmpty) {
      throw Exception('ParticipantModel.fromDoc: Document is empty');
    }
    try {
      return ParticipantModel(
          id: doc.id,
          user: user,
          status: ParticipantStatusEnum.fromString(doc[statusField]),
          attempts: doc[attemptsField] != null
              ? List<AttemptModel>.from(doc[attemptsField]
                  .map((attempt) => AttemptModel.fromDoc(attempt)))
              : [],
          reminder:
              data.containsKey(reminderField) && doc[reminderField] != null
                  ? ReminderModel.fromDoc(doc[reminderField])
                  : null);
    } on Exception {
      rethrow;
    }
  }

  AttemptModel getLatestAttempt() {
    if (attempts.isEmpty) {
      return AttemptModel.empty();
    }
    attempts.sort((a, b) => a.number.compareTo(b.number));
    return attempts.last;
  }

  ParticipantModel copy() {
    return ParticipantModel(
      user: user,
      status: status,
      attempts: AttemptModel.copyList(attempts),
      reminder: reminder?.copy(),
    );
  }

  void acceptChallengeRequest() {
    status = ParticipantStatusEnum.accepted;
  }

  static List<ParticipantModel> copyList(List<ParticipantModel> participants) {
    return participants.map((participant) => participant.copy()).toList();
  }

  AttemptModel addAttempt(GroupChallengeModel groupChallenge) {
    AttemptModel lastAttempt = getLatestAttempt();
    AttemptModel addedAttempt = AttemptModel(
      number: lastAttempt.number + 1,
      startDate: null,
      endDate: null,
      status: ChallengeStatusEnum.backlog,
      acceptanceCriteria:
          lastAttempt.getAcceptanceCriteria(groupChallenge).copy(),
      frequency: lastAttempt.getFrequency(groupChallenge).copy(),
      media: [],
      repetitions: [],
    );
    attempts.add(addedAttempt);
    return addedAttempt;
  }

  bool isAccepted() {
    return status == ParticipantStatusEnum.accepted;
  }

  void deleteAttempt({required int attemptNumber}) {
    attempts
        .removeWhere((attemptEntry) => attemptEntry.number == attemptNumber);
  }
}
