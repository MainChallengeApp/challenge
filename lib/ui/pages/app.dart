import 'package:challenge/enums/tab_item_enum.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/providers/user_challenges_provider.dart';
import 'package:challenge/ui/pages/home/home_tab_navigator.dart';
import 'package:challenge/ui/pages/profile/profile_tab_navigator.dart';
import 'package:challenge/ui/pages/search/search_tab_navigator.dart';
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
        context.read<TabProvider>().selectTab(TabItemEnum.search);
      } else {
        context.read<TabProvider>().selectTab(TabItemEnum.home);
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
            _buildOffstageNavigator(TabItemEnum.search),
            _buildOffstageNavigator(TabItemEnum.home),
            _buildOffstageNavigator(TabItemEnum.profile),
          ],
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildOffstageNavigator(TabItemEnum tabItem) {
    final currentTab = context.watch<TabProvider>().currentTab;
    switch (tabItem) {
      case TabItemEnum.search:
        return Offstage(
          offstage: currentTab != tabItem,
          child: SearchTabNavigator(
            navigatorKey: navigatorKeys[tabItem],
            tabItem: tabItem,
          ),
        );
      case TabItemEnum.home:
        return Offstage(
          offstage: currentTab != tabItem,
          child: HomeTabNavigator(
            navigatorKey: navigatorKeys[tabItem],
            tabItem: tabItem,
          ),
        );
      case TabItemEnum.profile:
        return Offstage(
          offstage: currentTab != tabItem,
          child: ProfileTabNavigator(
            navigatorKey: navigatorKeys[tabItem],
            tabItem: tabItem,
          ),
        );

      default:
        throw Exception('TabItem not found');
    }
  }
}
