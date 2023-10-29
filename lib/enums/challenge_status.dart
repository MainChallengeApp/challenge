enum ChallengeStatus {
  success,
  failed,
  inProgress,
  backlog;

  // const ChallengeStatus(String status);

  static ChallengeStatus factory(String status) {
    if (status == 'ChallengeStatus.success') {
      return ChallengeStatus.success;
    } else if (status == 'ChallengeStatus.failed') {
      return ChallengeStatus.failed;
    } else if (status == 'ChallengeStatus.backlog') {
      return ChallengeStatus.backlog;
    } else {
      return ChallengeStatus.inProgress;
    }
  }
}
