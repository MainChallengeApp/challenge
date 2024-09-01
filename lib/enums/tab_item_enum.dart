// ignore_for_file: constant_identifier_names

enum TabItemEnum {
  search(name: 'Search'),
  home(name: 'Home'),
  account(name: 'Account');

  const TabItemEnum({required this.name});
  final String name;
}
