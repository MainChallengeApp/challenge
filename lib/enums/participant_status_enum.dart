import 'package:challenge/exceptions/challenge_status_is_not_supported_exception.dart';

enum ParticipantStatusEnum {
  accepted('accepted'),
  invited('invited');

  const ParticipantStatusEnum(this.text);

  final String text;

  static ParticipantStatusEnum fromString(String text) {
    return ParticipantStatusEnum.values.firstWhere(
      (e) => e.text == text,
      orElse: () => throw ChallengeStatusIsNotSupportedException(text),
    );
  }
}
