import 'package:challenge/exceptions/challenge_status_is_not_supported_exception.dart';

enum ChallengeStatusEnum {
  success('success'),
  failed('failed'),
  inProgress('inProgress'),
  backlog('backlog');

  const ChallengeStatusEnum(this.status);

  final String status;

  static ChallengeStatusEnum fromString(String status) {
    return ChallengeStatusEnum.values.firstWhere(
      (e) => e.status == status,
      orElse: () => throw ChallengeStatusIsNotSupportedException(status),
    );
  }
}
