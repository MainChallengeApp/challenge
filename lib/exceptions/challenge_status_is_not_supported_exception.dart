class ChallengeStatusIsNotSupportedException implements Exception {
  final String status;

  const ChallengeStatusIsNotSupportedException(this.status);

  @override
  String toString() {
    return 'Challenge status "$status" is not supported';
  }
}
