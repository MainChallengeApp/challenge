import 'package:challenge/exceptions/challenge_status_is_not_supported_exception.dart';

enum ChallengeStatusEnum {
  backlog('backlog'),
  failed('failed'),
  inProgress('inProgress'),
  success('success');

  const ChallengeStatusEnum(this.status);

  final String status;

  static ChallengeStatusEnum fromString(String status) {
    return ChallengeStatusEnum.values.firstWhere(
      (e) => e.status == status,
      orElse: () => throw ChallengeStatusIsNotSupportedException(status),
    );
  }
}
