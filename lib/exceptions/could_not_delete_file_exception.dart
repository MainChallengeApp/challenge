class CouldNotDeleteFileException implements Exception {
  final String message;

  const CouldNotDeleteFileException(this.message);

  @override
  String toString() {
    return 'Could not delete file: $message';
  }
}
