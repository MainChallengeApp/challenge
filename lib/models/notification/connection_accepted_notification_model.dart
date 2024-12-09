import 'package:challenge/enums/notification_type_enum.dart';
import 'package:challenge/models/notification/notification_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConnectionAcceptedNotificationModel extends NotificationModel {
  ConnectionAcceptedNotificationModel({
    super.id,
    required super.user,
    required super.fromUser,
    super.type = NotificationTypeEnum.connectionAccepted,
    required super.createdAt,
  }) : super(
            title: 'Connection Accepted',
            body: '${fromUser.username} and you are connected');

  factory ConnectionAcceptedNotificationModel.fromDoc(
      DocumentSnapshot doc, UserModel user, UserModel fromUser) {
    return ConnectionAcceptedNotificationModel(
      id: doc.id,
      user: user,
      fromUser: fromUser,
      createdAt: doc[NotificationModel.createdAtField].toDate(),
    );
  }
}
