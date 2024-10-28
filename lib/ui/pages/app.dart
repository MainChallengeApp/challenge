import 'package:challenge/enums/tab_item_enum.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/providers/user_challenges_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/loading_circle/loading_circle_component.dart';
import 'package:challenge/ui/pages/home/home_tab_navigator.dart';
import 'package:challenge/ui/pages/search/search_tab_navigator.dart';
import 'package:challenge/ui/pages/user/settings/edit_user/edit_username_page.dart';
import 'package:challenge/ui/pages/user/user_tab_navigator.dart';
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

  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);
  late final listeningUsersProvider =
      Provider.of<UsersProvider>(context, listen: true);

  late final tabProvider = Provider.of<TabProvider>(context, listen: false);

  bool isLoadingUser = true;
  bool isLoadingUserChallenges = true;

  @override
  void initState() {
    super.initState();

    usersProvider.getUser().then((_) {
      setState(() {
        isLoadingUser = false;
      });
    });

    userChallengesProvider.getAllOfUser().then((value) {
      if (value.isEmpty) {
        tabProvider.selectTab(TabItemEnum.search);
      } else {
        tabProvider.selectTab(TabItemEnum.home);
      }
      setState(() {
        isLoadingUserChallenges = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoadingUser || isLoadingUserChallenges
        ? const Scaffold(
            body: Center(
              child: LoadingCircleComponent(),
            ),
          )
        : listeningUsersProvider.user.username == ''
            ? EditUsernamePage(
                user: listeningUsersProvider.user,
                preTitle: 'Registration',
                isRegistration: true)
            : ScaffoldMessenger(
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: Stack(
                    children: <Widget>[
                      _buildOffstageNavigator(TabItemEnum.search),
                      _buildOffstageNavigator(TabItemEnum.home),
                      _buildOffstageNavigator(TabItemEnum.user),
                    ],
                  ),
                  backgroundColor: Theme.of(context).colorScheme.surface,
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
            navigatorKey: tabProvider.navigatorKeys[tabItem],
            tabItem: tabItem,
          ),
        );
      case TabItemEnum.home:
        return Offstage(
          offstage: currentTab != tabItem,
          child: HomeTabNavigator(
            navigatorKey: tabProvider.navigatorKeys[tabItem],
            tabItem: tabItem,
          ),
        );
      case TabItemEnum.user:
        return Offstage(
          offstage: currentTab != tabItem,
          child: UserTabNavigator(
            navigatorKey: tabProvider.navigatorKeys[tabItem],
            tabItem: tabItem,
          ),
        );

      default:
        throw Exception('TabItem not found');
    }
  }
}
