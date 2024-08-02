class FrequencyTypeIsNotSupportedException implements Exception {
  final String type;

  const FrequencyTypeIsNotSupportedException(this.type);

  @override
  String toString() {
    return 'Frequency type "$type" is not supported';
  }
}
