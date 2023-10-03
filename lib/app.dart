import 'package:flutter/material.dart';
import 'package:nested_navigation_demo_flutter/bottom_navigation.dart';
import 'package:nested_navigation_demo_flutter/tab_item.dart';
import 'package:nested_navigation_demo_flutter/tab_navigators/home_tab_navigator.dart';
import 'package:nested_navigation_demo_flutter/tab_navigators/tab_navigator.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  final _mainTab = TabItem.Home;
  var _currentTab = TabItem.Home;

  final _navigatorKeys = {
    TabItem.Search: GlobalKey<NavigatorState>(),
    TabItem.Home: GlobalKey<NavigatorState>(),
    TabItem.Settings: GlobalKey<NavigatorState>(),
  };

  void _selectTab(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentTab]!.currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
          // if not on the 'main' tab
          if (_currentTab != _mainTab) {
            // select 'main' tab
            _selectTab(_mainTab);
            // back button handled by app
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            _buildOffstageNavigator(TabItem.Search),
            _buildOffstageNavigator(TabItem.Home),
            _buildOffstageNavigator(TabItem.Settings),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(
              left: 20.0, right: 20.0, bottom: 20, top: 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
                24.0), // Hier können Sie den Radius nach Bedarf ändern
            child: Container(
              height: 72,
              // width: 450,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(15, 23, 42, 1),
              ),
              child: BottomNavigation(
                currentTab: _currentTab,
                onSelectTab: _selectTab,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    switch (tabItem) {
      case TabItem.Search:
        return Offstage(
          offstage: _currentTab != tabItem,
          child: TabNavigator(
            navigatorKey: _navigatorKeys[tabItem],
            tabItem: tabItem,
          ),
        );
      case TabItem.Home:
        return Offstage(
          offstage: _currentTab != tabItem,
          child: HomeTabNavigator(
            navigatorKey: _navigatorKeys[tabItem],
            tabItem: tabItem,
          ),
        );
      case TabItem.Settings:
        return Offstage(
          offstage: _currentTab != tabItem,
          child: TabNavigator(
            navigatorKey: _navigatorKeys[tabItem],
            tabItem: tabItem,
          ),
        );

      default:
        return Offstage(
          offstage: _currentTab != tabItem,
          child: TabNavigator(
            navigatorKey: _navigatorKeys[tabItem],
            tabItem: tabItem,
          ),
        );
    }
  }
}
