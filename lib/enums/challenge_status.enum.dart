enum ChallengeStatusEnum {
  success,
  failed,
  inProgress,
  backlog;

  // const ChallengeStatus(String status);

  static ChallengeStatusEnum factory(String status) {
    if (status == 'ChallengeStatus.success') {
      return ChallengeStatusEnum.success;
    } else if (status == 'ChallengeStatus.failed') {
      return ChallengeStatusEnum.failed;
    } else if (status == 'ChallengeStatus.backlog') {
      return ChallengeStatusEnum.backlog;
    } else {
      return ChallengeStatusEnum.inProgress;
    }
  }
}
