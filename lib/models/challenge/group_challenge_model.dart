import 'package:challenge/enums/challenge_category_enum.dart';
import 'package:challenge/enums/challenge_status_enum.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/group_challenge_options_model.dart';
import 'package:challenge/models/challenge/media_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChallengeModel extends ChallengeModel {
  String userId;
  static const String userIdField = 'userId';

  late List<ParticipantModel> participants;
  static const String participantsField = 'participants';

  GroupChallengeOptionsModel groupChallengeOptions;
  static const String groupChallengeOptionsField = 'groupChallengeOptions';

  GroupChallengeModel({
    required super.id,
    required this.userId,
    required this.participants,
    required super.status,
    required super.title,
    required super.titleLowerCase,
    required super.description,
    required super.thumbnail,
    super.startDate,
    super.endDate,
    required super.acceptanceCriteria,
    required super.frequency,
    required super.media,
    super.categories = const [],
    required this.groupChallengeOptions,
    required super.createdAt,
  });

  GroupChallengeModel.fromChallengeWithParticipantUsers({
    required ChallengeModel challenge,
    required this.userId,
    required List<UserModel> participantUsers,
    required this.groupChallengeOptions,
  }) : super(
          id: challenge.id,
          status: challenge.status,
          title: challenge.title,
          titleLowerCase: challenge.titleLowerCase,
          description: challenge.description,
          thumbnail: challenge.thumbnail,
          startDate: challenge.startDate,
          endDate: challenge.endDate,
          acceptanceCriteria: challenge.acceptanceCriteria,
          frequency: challenge.frequency,
          media: challenge.media,
          categories: challenge.categories,
        ) {
    participants = participantUsers
        .map((participantUser) => ParticipantModel.fromChallengeModel(
            challenge: challenge, userId: participantUser.id))
        .toList();
  }

  GroupChallengeModel.fromChallengeWithParticipants({
    required ChallengeModel challenge,
    required this.userId,
    required this.participants,
    required this.groupChallengeOptions,
  }) : super(
          id: challenge.id,
          status: challenge.status,
          title: challenge.title,
          titleLowerCase: challenge.titleLowerCase,
          description: challenge.description,
          thumbnail: challenge.thumbnail,
          startDate: challenge.startDate,
          endDate: challenge.endDate,
          acceptanceCriteria: challenge.acceptanceCriteria,
          frequency: challenge.frequency,
          media: challenge.media,
          categories: challenge.categories,
          createdAt: challenge.createdAt,
        );

  @override
  Map<String, dynamic> toDoc() {
    return {
      ...super.toDoc(),
      userIdField: userId,
      groupChallengeOptionsField: groupChallengeOptions.toDoc(),
    };
  }

  static GroupChallengeModel fromDoc(DocumentSnapshot groupChallengeDoc,
      QuerySnapshot<Map<String, dynamic>> participantsDoc) {
    List<ParticipantModel> participants = List<ParticipantModel>.from(
        participantsDoc.docs.map((doc) => ParticipantModel.fromDoc(doc)));

    ChallengeModel challenge = ChallengeModel.fromDoc(groupChallengeDoc);

    return GroupChallengeModel.fromChallengeWithParticipants(
        challenge: challenge,
        userId: groupChallengeDoc[userIdField],
        participants: participants,
        groupChallengeOptions: GroupChallengeOptionsModel.fromDoc(
            groupChallengeDoc[groupChallengeOptionsField]));
  }

  ParticipantModel getParticipant(String userId) {
    try {
      return participants
          .firstWhere((participant) => participant.userId == userId);
    } catch (e) {
      throw Exception('Participant not found');
    }
  }

  @override
  GroupChallengeModel copy({bool isTryAgain = false, bool withId = false}) {
    return GroupChallengeModel(
        id: withId ? id : '',
        status: isTryAgain ? ChallengeStatusEnum.backlog : status,
        title: title,
        titleLowerCase: titleLowerCase,
        startDate: isTryAgain ? null : startDate,
        endDate: isTryAgain ? null : endDate,
        description: description,
        thumbnail: thumbnail?.copy(),
        acceptanceCriteria: acceptanceCriteria.copy(),
        frequency: frequency.copy(),
        media: isTryAgain ? [] : MediaModel.copyList(media),
        categories: ChallengeCategoryEnum.copyCategoryList(categories),
        userId: userId,
        participants: ParticipantModel.copyList(participants),
        groupChallengeOptions: groupChallengeOptions.copy(),
        createdAt: createdAt);
  }

  void setGoals(double amount) {
    acceptanceCriteria.amount = amount;
  }

  checkStatus() {
    for (var participant in participants) {
      for (var attempt in participant.attempts) {
        attempt.checkStatus(this);
      }
    }
  }

  bool isGroupChallenge() {
    return participants.length > 1;
  }

  static List<GroupChallengeModel> sortChallengeList(
      {required List<GroupChallengeModel> groupChallenges,
      required String userId}) {
    for (var groupChallenge in groupChallenges) {
      groupChallenge.checkStatus();
    }
    groupChallenges.sort((a, b) {
      AttemptModel aAttempt = a.getParticipant(userId).getLatestAttempt();
      AttemptModel bAttempt = b.getParticipant(userId).getLatestAttempt();

      // Check if a is succeeded or failed and b is not
      if ((aAttempt.isSucceeded() || aAttempt.isFailed()) &&
          !(bAttempt.isSucceeded() || bAttempt.isFailed())) {
        return 1;
      }

      // Check if b is succeeded or failed and a is not
      if ((bAttempt.isSucceeded() || bAttempt.isFailed()) &&
          !(aAttempt.isSucceeded() || aAttempt.isFailed())) {
        return -1;
      }

      // Check if a is in progress and b is in backlog
      if (aAttempt.isInProgress() && bAttempt.isInBacklog()) {
        return 1;
      }

      // Check if b is in progress and a is in backlog
      if (bAttempt.isInProgress() && aAttempt.isInBacklog()) {
        return -1;
      }

      // Compare by current percentage
      if (aAttempt
              .getCurrentPercentage(a)
              .compareTo(bAttempt.getCurrentPercentage(b)) >
          0) {
        return 1;
      }

      if (bAttempt
              .getCurrentPercentage(b)
              .compareTo(aAttempt.getCurrentPercentage(a)) >
          0) {
        return -1;
      }

      if ((aAttempt.isSucceeded() || aAttempt.isFailed()) &&
          (bAttempt.isSucceeded() || bAttempt.isFailed()) &&
          aAttempt.endDate != null &&
          bAttempt.endDate != null) {
        if (aAttempt.endDate!.compareTo(bAttempt.endDate!) > 0) {
          return -1;
        }

        if (bAttempt.endDate!.compareTo(aAttempt.endDate!) > 0) {
          return 1;
        }
      }

      if (aAttempt.createdAt.compareTo(bAttempt.createdAt) > 0) {
        return -1;
      }

      if (bAttempt.createdAt.compareTo(aAttempt.createdAt) > 0) {
        return 1;
      }

      return 0;
    });
    return groupChallenges;
  }

  void sortParticipants() {
    participants.sort((a, b) {
      return b
          .getLatestAttempt()
          .getCurrentPercentage(this)
          .compareTo(a.getLatestAttempt().getCurrentPercentage(this));
    });
  }
}
