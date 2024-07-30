import 'package:challenge/enums/tab_item_enum.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/json_file_controller/challenge_controller.dart';
import 'package:challenge/pages/home/home_tab_navigator.dart';
import 'package:challenge/pages/search/search_tab_navigator.dart';
import 'package:challenge/pages/settings/settings_tab_navigator.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  ChallengeController challengeController = ChallengeController();

  @override
  void initState() {
    super.initState();
    challengeController.readFile().then((value) {
      allChallengesList = value;
      if (allChallengesList.isEmpty) {
        context.read<TabProvider>().selectTab(TabItemEnum.Search);
      } else {
        context.read<TabProvider>().selectTab(TabItemEnum.Home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            _buildOffstageNavigator(TabItemEnum.Search),
            _buildOffstageNavigator(TabItemEnum.Home),
            _buildOffstageNavigator(TabItemEnum.Settings),
          ],
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildOffstageNavigator(TabItemEnum tabItem) {
    final currentTab = context.watch<TabProvider>().currentTab;
    switch (tabItem) {
      case TabItemEnum.Search:
        return Offstage(
          offstage: currentTab != tabItem,
          child: SearchTabNavigator(
            navigatorKey: navigatorKeys[tabItem],
            tabItem: tabItem,
          ),
        );
      case TabItemEnum.Home:
        return Offstage(
          offstage: currentTab != tabItem,
          child: HomeTabNavigator(
            navigatorKey: navigatorKeys[tabItem],
            tabItem: tabItem,
          ),
        );
      case TabItemEnum.Settings:
        return Offstage(
          offstage: currentTab != tabItem,
          child: SettingsTabNavigator(
            navigatorKey: navigatorKeys[tabItem],
            tabItem: tabItem,
          ),
        );

      default:
        throw Exception('TabItem not found');
    }
  }
}
