import 'package:challenge/enums/notification_type_enum.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/notification/notification_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressAddedNotificationModel extends NotificationModel {
  GroupChallengeModel groupChallenge;
  static const String groupChallengeIdField = 'groupChallengeId';

  ProgressAddedNotificationModel({
    super.id,
    required super.user,
    required super.fromUser,
    super.type = NotificationTypeEnum.progressAdded,
    required super.createdAt,
    required this.groupChallenge,
  }) : super(
            title: '${fromUser.username} - ${groupChallenge.title}',
            body:
                '${fromUser.username} added progress to ${groupChallenge.title}');

  factory ProgressAddedNotificationModel.fromDoc(DocumentSnapshot doc,
      UserModel user, UserModel fromUser, GroupChallengeModel groupChallenge) {
    return ProgressAddedNotificationModel(
      id: doc.id,
      user: user,
      fromUser: fromUser,
      createdAt: doc[NotificationModel.createdAtField].toDate(),
      groupChallenge: groupChallenge,
    );
  }

  @override
  Map<String, dynamic> toDoc() {
    return {
      ...super.toDoc(),
      groupChallengeIdField: groupChallenge.id,
    };
  }
}
