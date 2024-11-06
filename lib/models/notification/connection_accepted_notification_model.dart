import 'package:challenge/enums/notification_type_enum.dart';
import 'package:challenge/models/notification/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConnectionAcceptedNotificationModel extends NotificationModel {
  ConnectionAcceptedNotificationModel({
    super.id,
    required super.userId,
    required super.fromUserId,
    super.type = NotificationTypeEnum.connectionAccepted,
    required super.createdAt,
  }) : super(title: '', body: 'accepted your connection request');

  factory ConnectionAcceptedNotificationModel.fromDoc(DocumentSnapshot doc) {
    return ConnectionAcceptedNotificationModel(
      id: doc.id,
      userId: doc[NotificationModel.userIdField],
      fromUserId: doc[NotificationModel.fromUserIdField],
      createdAt: doc[NotificationModel.createdAtField].toDate(),
    );
  }
}
