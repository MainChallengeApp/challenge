class MediaTypeIsNotSupportedException implements Exception {
  final String type;

  const MediaTypeIsNotSupportedException(this.type);

  @override
  String toString() {
    return 'Media type "$type" is not supported';
  }
}
