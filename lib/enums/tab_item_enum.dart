enum TabItemEnum {
  search(name: 'Search'),
  home(name: 'Home'),
  user(name: 'User');

  const TabItemEnum({required this.name});
  final String name;
}
