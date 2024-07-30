enum ChallengeStatusEnum {
  success('success'),
  failed('failed'),
  inProgress('inProgress'),
  backlog('backlog');

  const ChallengeStatusEnum(this.status);

  final String status;

  static ChallengeStatusEnum factory(String status) {
    return ChallengeStatusEnum.values.firstWhere((e) => e.status == status);
  }
}
