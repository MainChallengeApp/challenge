import 'package:challenge/exceptions/notification_type_is_not_supported_exception.dart';

enum NotificationTypeEnum {
  connectionAccepted('connectionAccepted'),
  connectionRequest('connectionRequest'),
  groupChallengeRequest('groupChallengeRequest'),
  groupChallengeAccepted('groupChallengeAccepted'),
  progressAdded('progressAdded'),
  ;

  final String type;

  const NotificationTypeEnum(this.type);

  factory NotificationTypeEnum.fromString(String? string) {
    return NotificationTypeEnum.values.firstWhere(
      (e) => e.type == string,
      orElse: () => throw NotificationTypeIsNotSupportedException(string),
    );
  }
}
