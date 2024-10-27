import 'package:challenge/exceptions/notification_type_is_not_supported_exception.dart';

enum NotificationTypeEnum {
  connectionAccepted(type: 'connectionAccepted'),
  connectionRequest(type: 'connectionRequest'),
  ;

  final String type;

  const NotificationTypeEnum({required this.type});

  factory NotificationTypeEnum.fromString(String? string) {
    return NotificationTypeEnum.values.firstWhere(
      (e) => e.type == string,
      orElse: () => throw NotificationTypeIsNotSupportedException(string),
    );
  }
}
