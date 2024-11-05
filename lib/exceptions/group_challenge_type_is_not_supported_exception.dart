class GroupChallengeTypeIsNotSupportedException implements Exception {
  final String type;

  const GroupChallengeTypeIsNotSupportedException(this.type);

  @override
  String toString() {
    return 'GroupChallenge type "$type" is not supported';
  }
}
