import 'package:challenge/enums/notification_type_enum.dart';
import 'package:challenge/exceptions/notification_type_is_not_supported_exception.dart';
import 'package:challenge/models/notification/connection_accepted_notification_model.dart';
import 'package:challenge/models/notification/request_connection_notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String id;
  static const String idField = 'id';

  String userId;
  static const String userIdField = 'userId';

  String fromUserId;
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
      required this.userId,
      required this.fromUserId,
      this.title = '',
      this.body = '',
      required this.type,
      DateTime? createdAt})
      : createdAt = createdAt ?? DateTime.now();

  factory NotificationModel.fromDoc(DocumentSnapshot doc) {
    if (doc[typeField] == NotificationTypeEnum.connectionRequest.type) {
      return RequestConnectionNotificationModel.fromDoc(doc);
    } else if (doc[typeField] == NotificationTypeEnum.connectionAccepted.type) {
      return ConnectionAcceptedNotificationModel.fromDoc(doc);
    }
    throw NotificationTypeIsNotSupportedException(doc[typeField]);
  }

  // ignore title and body (set in the constructor)
  Map<String, dynamic> toDoc() {
    return {
      userIdField: userId,
      fromUserIdField: fromUserId,
      typeField: type.type,
      createdAtField: createdAt,
    };
  }
}
