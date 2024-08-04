class RepetitionStatusIsNotSupportedException implements Exception {
  final String status;

  const RepetitionStatusIsNotSupportedException(this.status);

  @override
  String toString() {
    return 'Repetition status "$status" is not supported';
  }
}
