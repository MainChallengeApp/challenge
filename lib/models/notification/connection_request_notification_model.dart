import 'package:challenge/enums/notification_type_enum.dart';
import 'package:challenge/models/notification/notification_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConnectionRequestNotificationModel extends NotificationModel {
  ConnectionRequestNotificationModel({
    super.id,
    required super.user,
    required super.fromUser,
    super.type = NotificationTypeEnum.connectionRequest,
    required super.createdAt,
  }) : super(
            title: '${fromUser.username} - Connection Request',
            body: '${fromUser.username} wants to connect with you');

  factory ConnectionRequestNotificationModel.fromDoc(
      DocumentSnapshot doc, UserModel user, UserModel fromUser) {
    return ConnectionRequestNotificationModel(
      id: doc.id,
      user: user,
      fromUser: fromUser,
      createdAt: doc[NotificationModel.createdAtField].toDate(),
    );
  }
}
