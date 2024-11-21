class GroupChallengeNotFoundException implements Exception {
  final String id;

  const GroupChallengeNotFoundException(this.id);

  @override
  String toString() {
    return 'Group Challenge not found. Id: $id';
  }
}
