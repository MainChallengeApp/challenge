import 'package:challenge/enums/notification_type_enum.dart';
import 'package:challenge/exceptions/notification_type_is_not_supported_exception.dart';
import 'package:challenge/models/notification/request_connection_notification_model.dart';

abstract class NotificationModel {
  String id;
  static const String idField = 'id';

  String userId;
  static const String userIdField = 'userId';

  NotificationTypeEnum type;
  static const String typeField = 'type';

  DateTime createDate;
  static const String createDateField = 'createDate';

  NotificationModel(
      {String? id,
      required this.userId,
      required this.type,
      DateTime? createDate})
      : id = id ?? '',
        createDate = createDate ?? DateTime.now();

  factory NotificationModel.fromDoc(Map<String, dynamic> doc) {
    if (doc[typeField] == NotificationTypeEnum.connectionRequest.type) {
      return RequestConnectionNotificationModel.fromDoc(doc);
    }
    throw NotificationTypeIsNotSupportedException(doc[typeField]);
  }

  Map<String, dynamic> toDoc() {
    return {
      idField: id,
      typeField: type.type,
      createDateField: createDate,
    };
  }
}
