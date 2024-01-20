import 'package:challenge/json_file_controller/challenge.controller.dart';
import 'package:challenge/providers/design.provider.dart';
import 'package:flutter/material.dart';
import 'package:challenge/components/navigation/bottom_navigation.dart';
import 'package:challenge/pages/settings/settings_tab_navigator.dart';
import 'package:challenge/enums/tab_item.enum.dart';
import 'package:challenge/pages/home/home_tab_navigator.dart';
import 'package:challenge/pages/search/search_tab_navigator.dart';
import 'package:challenge/components/navigation/tab_navigator.dart';
import 'package:provider/provider.dart';

import 'globals.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  TabItemEnum _currentTab = TabItemEnum.Search;
  ChallengeController challengeController = ChallengeController();

  @override
  void initState() {
    super.initState();
    challengeController.readFile(context).then((value) {
      allChallengesList = value;
      setState(() {
        _currentTab =
            allChallengesList.isEmpty ? TabItemEnum.Search : TabItemEnum.Home;
      });
      return allChallengesList = value;
    });
  }

  void setStartPage() {
    Future.delayed(Duration.zero, () async {
      allChallengesList = await challengeController.readFile(context);
      setState(() {
        _currentTab =
            allChallengesList.isEmpty ? TabItemEnum.Search : TabItemEnum.Home;
      });
    });
  }

  void _selectTab(TabItemEnum tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildOffstageNavigator(TabItemEnum.Search),
          _buildOffstageNavigator(TabItemEnum.Home),
          _buildOffstageNavigator(TabItemEnum.Settings),
        ],
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  bottomNavigationBar() {
    return context.watch<DesignProvider>().isBottomNavBarVisible()
        ? Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, bottom: 20, top: 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  24.0), // Hier können Sie den Radius nach Bedarf ändern
              child: Container(
                height: 72,
                // width: 450,
                decoration: const BoxDecoration(
                  color: themeColor1,
                ),
                child: BottomNavigation(
                  currentTab: _currentTab,
                  onSelectTab: _selectTab,
                ),
              ),
            ),
          )
        : null;
  }

  Widget _buildOffstageNavigator(TabItemEnum tabItem) {
    switch (tabItem) {
      case TabItemEnum.Search:
        return Offstage(
          offstage: _currentTab != tabItem,
          child: SearchTabNavigator(
            navigatorKey: navigatorKeys[tabItem],
            tabItem: tabItem,
            selectTab: _selectTab,
          ),
        );
      case TabItemEnum.Home:
        return Offstage(
          offstage: _currentTab != tabItem,
          child: HomeTabNavigator(
            navigatorKey: navigatorKeys[tabItem],
            tabItem: tabItem,
          ),
        );
      case TabItemEnum.Settings:
        return Offstage(
          offstage: _currentTab != tabItem,
          child: SettingsTabNavigator(
            navigatorKey: navigatorKeys[tabItem],
            tabItem: tabItem,
          ),
        );

      default:
        return Offstage(
          offstage: _currentTab != tabItem,
          child: TabNavigator(
            navigatorKey: navigatorKeys[tabItem],
            tabItem: tabItem,
          ),
        );
    }
  }
}
