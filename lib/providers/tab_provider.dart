import 'package:challenge/enums/tab_item_enum.dart';
import 'package:challenge/globals.dart';
import 'package:flutter/material.dart';

class TabProvider with ChangeNotifier {
  TabItemEnum _currentTab = TabItemEnum.Search;

  TabItemEnum get currentTab => _currentTab;

  void selectTab(TabItemEnum tabItem) {
    if (tabItem == _currentTab) {
      navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      _currentTab = tabItem;
    }
    notifyListeners();
  }
}
