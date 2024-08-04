class ChallengeCategoryIsNotSupportedException implements Exception {
  final String category;

  const ChallengeCategoryIsNotSupportedException(this.category);

  @override
  String toString() {
    return 'Challenge category "$category" is not supported';
  }
}
