import 'package:challenge/enums/tab_item_enum.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/providers/user_challenges_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
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

  late final tabProvider = Provider.of<TabProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();

    usersProvider.getUser().then((user) {
      if (user.username == '') {
        // ignore: use_build_context_synchronously
        context.read<TabProvider>().selectTab(TabItemEnum.user);
        Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            NoAnimationPageRouteComponent(
                builder: (context) => EditUsernamePage(
                      user: user,
                      preTitle: 'Registration',
                      isRegistration: true,
                    )));
        return;
      }

      userChallengesProvider.getAllOfUser().then((value) {
        if (value.isEmpty) {
          context.read<TabProvider>().selectTab(TabItemEnum.search);
        } else {
          context.read<TabProvider>().selectTab(TabItemEnum.home);
        }
      });
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
            _buildOffstageNavigator(TabItemEnum.user),
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
