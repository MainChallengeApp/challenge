import 'package:challenge/enums/tab_item_enum.dart';
import 'package:flutter/material.dart';

class TabProvider with ChangeNotifier {
  TabItemEnum _currentTab = TabItemEnum.search;
  TabItemEnum get currentTab => _currentTab;

  final Map<TabItemEnum, GlobalKey<NavigatorState>> _navigatorKeys = {
    TabItemEnum.search: GlobalKey<NavigatorState>(),
    TabItemEnum.home: GlobalKey<NavigatorState>(),
    TabItemEnum.user: GlobalKey<NavigatorState>(),
  };
  Map<TabItemEnum, GlobalKey<NavigatorState>> get navigatorKeys =>
      _navigatorKeys;

  void selectTab(TabItemEnum tabItem) {
    if (tabItem == _currentTab) {
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      _currentTab = tabItem;
    }
    notifyListeners();
  }
}
