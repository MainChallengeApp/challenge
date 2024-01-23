enum ChallengeStatusEnum {
  success,
  failed,
  inProgress,
  backlog;

  // const ChallengeStatus(String status);

  static ChallengeStatusEnum factory(String status) {
    if (status == 'success') {
      return ChallengeStatusEnum.success;
    } else if (status == 'failed') {
      return ChallengeStatusEnum.failed;
    } else if (status == 'backlog') {
      return ChallengeStatusEnum.backlog;
    } else {
      return ChallengeStatusEnum.inProgress;
    }
  }
}
