import 'package:challenge/enums/notification_type_enum.dart';
import 'package:challenge/models/notification/notification_model.dart';

class RequestConnectionNotificationModel extends NotificationModel {
  String fromUserId;
  static const String fromUserIdField = 'fromUserId';

  String toUserId;
  static const String toUserIdField = 'toUserId';

  RequestConnectionNotificationModel(
      {super.id,
      required super.userId,
      required this.fromUserId,
      required this.toUserId,
      super.type = NotificationTypeEnum.connectionRequest,
      super.createDate});

  factory RequestConnectionNotificationModel.fromDoc(Map<String, dynamic> doc) {
    return RequestConnectionNotificationModel(
      id: doc[NotificationModel.idField],
      userId: doc[NotificationModel.userIdField],
      fromUserId: doc[fromUserIdField],
      toUserId: doc[toUserIdField],
      createDate: doc[NotificationModel.createDateField].toDate(),
    );
  }
}
