import 'package:challenge/enums/notification_type_enum.dart';
import 'package:challenge/models/notification/notification_model.dart';

class RequestConnectionNotificationModel extends NotificationModel {
  String fromUserId;
  static const String fromUserIdField = 'fromUserId';

  RequestConnectionNotificationModel(
      {super.id,
      required super.userId,
      required this.fromUserId,
      super.type = NotificationTypeEnum.connectionRequest,
      super.createDate,
      required super.title});

  factory RequestConnectionNotificationModel.fromDoc(Map<String, dynamic> doc) {
    return RequestConnectionNotificationModel(
      id: doc[NotificationModel.idField],
      userId: doc[NotificationModel.userIdField],
      title: doc[NotificationModel.titleField],
      fromUserId: doc[fromUserIdField],
      createDate: doc[NotificationModel.createDateField].toDate(),
    );
  }

  @override
  Map<String, dynamic> toDoc() {
    return {
      NotificationModel.userIdField: userId,
      NotificationModel.titleField: title,
      NotificationModel.typeField: type.type,
      NotificationModel.createDateField: createDate,
      fromUserIdField: fromUserId,
    };
  }
}
