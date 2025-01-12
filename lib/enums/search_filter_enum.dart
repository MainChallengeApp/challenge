enum SearchFilterEnum {
  all(text: 'All'),
  challenges(text: 'Challenges'),
  users(text: 'Users');

  final String text;

  const SearchFilterEnum({required this.text});
}
