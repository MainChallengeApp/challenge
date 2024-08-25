import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserChallengeModel extends ChallengeModel {
  String userId;
  static const String userIdField = 'userId';

  UserChallengeModel({
    required super.id,
    required this.userId,
    required super.status,
    required super.title,
    required super.description,
    required super.thumbnail,
    super.startDate,
    super.endDate,
    required super.acceptanceCriteria,
    required super.frequency,
    required super.repetitions,
    required super.media,
    super.categories = const [],
  });

  UserChallengeModel.fromChallengeModel({
    required ChallengeModel challenge,
    required this.userId,
  }) : super(
          id: challenge.id,
          status: challenge.status,
          title: challenge.title,
          description: challenge.description,
          thumbnail: challenge.thumbnail,
          startDate: challenge.startDate,
          endDate: challenge.endDate,
          acceptanceCriteria: challenge.acceptanceCriteria,
          frequency: challenge.frequency,
          repetitions: challenge.repetitions,
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

  static UserChallengeModel fromDoc(DocumentSnapshot doc) {
    try {
      ChallengeModel challenge = ChallengeModel.fromDoc(doc);
      return UserChallengeModel.fromChallengeModel(
          challenge: challenge, userId: doc[userIdField]);
    } on Exception {
      rethrow;
    }
  }

  @override
  UserChallengeModel copyChallenge(
      {bool isTryAgain = false, bool withId = false}) {
    return UserChallengeModel.fromChallengeModel(
        challenge: super.copyChallenge(isTryAgain: isTryAgain, withId: withId),
        userId: userId);
  }
}
