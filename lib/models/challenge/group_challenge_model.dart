import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/user_challenge_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChallengeModel extends ChallengeModel {
  String userId;
  static const String userIdField = 'userId';

  List<UserChallengeModel>? userChallenges = [];
  static const String userChallengesField = 'userChallenges';

  GroupChallengeModel({
    required super.id,
    required this.userId,
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
  });

  GroupChallengeModel.fromChallengeModel({
    required ChallengeModel challenge,
    required this.userId,
    required this.userChallenges,
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
    };
  }

  static GroupChallengeModel fromDoc(DocumentSnapshot doc) {
    try {
      ChallengeModel challenge = ChallengeModel.fromDoc(doc);
      return GroupChallengeModel.fromChallengeModel(
          challenge: challenge,
          userId: doc[userIdField],
          userChallenges: doc[userChallengesField]);
    } on Exception {
      rethrow;
    }
  }

  @override
  GroupChallengeModel copyChallenge(
      {bool isTryAgain = false, bool withId = false}) {
    return GroupChallengeModel.fromChallengeModel(
        challenge: super.copyChallenge(isTryAgain: isTryAgain, withId: withId),
        userId: userId,
        userChallenges: userChallenges);
  }

  UserChallengeModel? toUserChallengeModel(String userId) {
    try {
      return userChallenges
          ?.firstWhere((userChallenge) => userChallenge.userId == userId);
    } catch (e) {
      return null;
    }
  }

  void setUserChallenges(List<UserChallengeModel> userChallenges) {
    this.userChallenges = userChallenges;
  }
}
