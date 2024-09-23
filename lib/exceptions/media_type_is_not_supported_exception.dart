class MediaTypeIsNotSupportedException implements Exception {
  final String? type;

  const MediaTypeIsNotSupportedException(this.type);

  @override
  String toString() {
    if (type == null) {
      return 'Media type is not specified (type is null)';
    }
    return 'Media type "$type" is not supported';
  }
}
