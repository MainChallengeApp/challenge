import 'package:challenge/enums/notification_type_enum.dart';
import 'package:challenge/models/notification/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestConnectionNotificationModel extends NotificationModel {
  RequestConnectionNotificationModel({
    super.id,
    required super.userId,
    required super.fromUserId,
    super.type = NotificationTypeEnum.connectionRequest,
    required super.createdAt,
  }) : super(title: '', body: 'wants to connect with you');

  factory RequestConnectionNotificationModel.fromDoc(DocumentSnapshot doc) {
    return RequestConnectionNotificationModel(
      id: doc.id,
      userId: doc[NotificationModel.userIdField],
      fromUserId: doc[NotificationModel.fromUserIdField],
      createdAt: doc[NotificationModel.createdAtField].toDate(),
    );
  }
}
