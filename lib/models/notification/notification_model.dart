import 'package:challenge/enums/notification_type_enum.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/notification/connection_accepted_notification_model.dart';
import 'package:challenge/models/notification/group_challenge_accepted_notification_model.dart';
import 'package:challenge/models/notification/group_challenge_request_notification_model.dart';
import 'package:challenge/models/notification/request_connection_notification_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String id;
  static const String idField = 'id';

  UserModel user;
  static const String userIdField = 'userId';

  UserModel fromUser;
  static const String fromUserIdField = 'fromUserId';

  String title;
  static const String titleField = 'title';

  String body;
  static const String bodyField = 'body';

  NotificationTypeEnum type;
  static const String typeField = 'type';

  DateTime createdAt;
  static const String createdAtField = 'createdAt';

  NotificationModel(
      {this.id = '',
      required this.user,
      required this.fromUser,
      this.title = '',
      this.body = '',
      required this.type,
      required this.createdAt});

  factory NotificationModel.fromDoc(DocumentSnapshot doc,
      {required UserModel user,
      required UserModel fromUser,
      GroupChallengeModel? groupChallenge}) {
    NotificationTypeEnum notificationType =
        NotificationTypeEnum.fromString(doc[typeField]);

    switch (notificationType) {
      case NotificationTypeEnum.connectionRequest:
        return RequestConnectionNotificationModel.fromDoc(doc, user, fromUser);
      case NotificationTypeEnum.connectionAccepted:
        return ConnectionAcceptedNotificationModel.fromDoc(doc, user, fromUser);
      case NotificationTypeEnum.groupChallengeRequest:
        return GroupChallengeRequestNotificationModel.fromDoc(
            doc, user, fromUser, groupChallenge!);
      case NotificationTypeEnum.groupChallengeAccepted:
        return GroupChallengeAcceptedNotificationModel.fromDoc(
            doc, user, fromUser, groupChallenge!);
    }
  }

  // ignore title and body (set in the constructor)
  Map<String, dynamic> toDoc() {
    return {
      userIdField: user.id,
      fromUserIdField: fromUser.id,
      typeField: type.type,
      createdAtField: createdAt,
    };
  }
}
