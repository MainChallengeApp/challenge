enum RepetitionStatusEnum {
  success,
  failed,
  inProgress,
  backlog;

  static RepetitionStatusEnum factory(String status) {
    if (status == 'success') {
      return RepetitionStatusEnum.success;
    } else if (status == 'failed') {
      return RepetitionStatusEnum.failed;
    } else if (status == 'backlog') {
      return RepetitionStatusEnum.backlog;
    } else {
      return RepetitionStatusEnum.inProgress;
    }
  }
}
