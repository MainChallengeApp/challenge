import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/user_challenge_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChallengeModel extends ChallengeModel {
  String userId;
  static const String userIdField = 'userId';

  late List<UserChallengeModel> userChallenges;
  static const String userChallengesField = 'userChallenges';

  GroupChallengeModel({
    required super.id,
    required this.userId,
    required this.userChallenges,
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

  GroupChallengeModel.fromChallengeModelWithMembers({
    required ChallengeModel challenge,
    required this.userId,
    required List<UserModel> members,
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
        ) {
    userChallenges = members
        .map((member) => UserChallengeModel.fromChallengeModel(
            challenge: challenge, userId: member.id, repetitions: []))
        .toList();
  }

  GroupChallengeModel.fromChallengeModelWithUserChallenges({
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

  static GroupChallengeModel fromDoc(DocumentSnapshot groupChallengeDoc,
      QuerySnapshot<Map<String, dynamic>> userChallengesDocs) {
    List<UserChallengeModel> userChallenges = userChallengesDocs.docs
        .map((doc) => UserChallengeModel.fromDoc(doc))
        .toList();

    ChallengeModel challenge = ChallengeModel.fromDoc(groupChallengeDoc);

    return GroupChallengeModel.fromChallengeModelWithUserChallenges(
        challenge: challenge,
        userId: groupChallengeDoc[userIdField],
        userChallenges: userChallenges);
    // try {
    //   ChallengeModel challenge = ChallengeModel.fromDoc(doc);
    //   return GroupChallengeModel.fromChallengeModel(
    //       challenge: challenge,
    //       userId: doc[userIdField],
    //       userChallenges: UserChallengeModel.fromDocList(doc[userChallengesField]));
    // } on Exception {
    //   rethrow;
    // }
  }

  // @override
  // GroupChallengeModel copyChallenge(
  //     {bool isTryAgain = false, bool withId = false}) {
  //   return GroupChallengeModel.fromChallengeModel(
  //       challenge: super.copyChallenge(isTryAgain: isTryAgain, withId: withId),
  //       userId: userId,
  //       userChallenges: userChallenges.map((userChallenge) => userChallenge.copyChallenge()).toList());
  // }

  UserChallengeModel toUserChallengeModel(String userId) {
    try {
      return userChallenges
          .firstWhere((userChallenge) => userChallenge.userId == userId);
    } catch (e) {
      throw Exception('UserChallengeModel not found');
    }
  }

  factory GroupChallengeModel.empty() {
    return GroupChallengeModel.fromChallengeModelWithMembers(
        challenge: ChallengeModel.empty(), userId: '', members: []);
  }

  @override
  checkChallengeStatus() {
    for (var userChallenge in userChallenges) {
      userChallenge.checkChallengeStatus();
    }
  }
}
