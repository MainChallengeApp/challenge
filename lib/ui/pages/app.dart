import 'package:challenge/enums/tab_item_enum.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/providers/user_challenges_provider.dart';
import 'package:challenge/ui/pages/home/home_tab_navigator.dart';
import 'package:challenge/ui/pages/search/search_tab_navigator.dart';
import 'package:challenge/ui/pages/settings/settings_tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  late final userChallengesProvider =
      Provider.of<UserChallengesProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();

    userChallengesProvider.getAllOfUser().then((value) {
      if (value.isEmpty) {
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
