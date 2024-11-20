import 'package:challenge/enums/notification_type_enum.dart';
import 'package:challenge/models/notification/notification_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestConnectionNotificationModel extends NotificationModel {
  RequestConnectionNotificationModel({
    super.id,
    required super.user,
    required super.fromUser,
    super.type = NotificationTypeEnum.connectionRequest,
    required super.createdAt,
  }) : super(title: '', body: 'wants to connect with you');

  factory RequestConnectionNotificationModel.fromDoc(
      DocumentSnapshot doc, UserModel user, UserModel fromUser) {
    return RequestConnectionNotificationModel(
      id: doc.id,
      user: user,
      fromUser: fromUser,
      createdAt: doc[NotificationModel.createdAtField].toDate(),
    );
  }
}
