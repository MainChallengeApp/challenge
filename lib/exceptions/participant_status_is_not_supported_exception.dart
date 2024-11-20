class ParticipantStatusIsNotSupportedException implements Exception {
  final String status;

  const ParticipantStatusIsNotSupportedException(this.status);

  @override
  String toString() {
    return 'Participant status "$status" is not supported';
  }
}
