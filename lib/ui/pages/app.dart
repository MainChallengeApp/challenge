import 'package:challenge/enums/tab_item_enum.dart';
import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/providers/notifications_provider.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/services/local_push_notification_service.dart';
import 'package:challenge/services/push_notification_service.dart';
import 'package:challenge/ui/animations/bottom_navigation_animation.dart';
import 'package:challenge/ui/components/loading_circle/loading_circle_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/dialogs/error_occurred_dialog.dart';
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
  final _groupChallengesProvider = getIt<GroupChallengesProvider>();
  final _usersProvider = getIt<UsersProvider>();
  final _tabProvider = getIt<TabProvider>();
  late UsersProvider _listeningUsersProvider;
  final _notificationsProvider = getIt<NotificationsProvider>();

  final _authService = AuthService();
  final _pushNotificationService = PushNotificationService();
  final _localNotificationService = LocalPushNotificationService();

  bool _isLoadingUser = true;
  bool _isLoadingUserChallenges = true;

  @override
  void initState() {
    super.initState();

    _usersProvider.getUser().then((_) {
      _isLoadingUser = false;
      if (mounted) {
        setState(() {});
      }

      _groupChallengesProvider.getAllOfUser().then((value) {
        if (value.isEmpty) {
          _tabProvider.selectTab(TabItemEnum.search);
        } else {
          _tabProvider.selectTab(TabItemEnum.home);
        }
        _isLoadingUserChallenges = false;
        _localNotificationService.activateAllChallengeNotifications();
        if (mounted) {
          setState(() {});
        }
      }).catchError((error) {
        _isLoadingUserChallenges = false;
        if (mounted) {
          setState(() {});
        }
        _authService.logout();
        if (mounted) {
          ErrorOccurredDialog.show(
              errorText: error.toString(), context: context);
        }
      }).timeout((const Duration(seconds: 5)), onTimeout: () {
        _isLoadingUserChallenges = false;
        if (mounted) {
          setState(() {});
          ErrorOccurredDialog.show(
              errorText: 'Timeout: Could not load user challenges',
              context: context);
        }
      });
    }).catchError((error) {
      _isLoadingUser = false;
      _isLoadingUserChallenges = false;
      if (mounted) {
        setState(() {});
      }
      _authService.logout();
      ErrorOccurredDialog.show(errorText: error.toString());
    });

    _pushNotificationService.initialize();
    _notificationsProvider.listenForUserNotifications();
  }

  @override
  void dispose() {
    _pushNotificationService.dispose();
    _notificationsProvider.stopListeningForUserNotifications();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _listeningUsersProvider = Provider.of<UsersProvider>(context);
    return _isLoadingUser || _isLoadingUserChallenges
        ? const Scaffold(
            body: Center(
              child: LoadingCircleComponent(),
            ),
          )
        : _listeningUsersProvider.user.username == ''
            ? EditUsernamePage(
                user: _listeningUsersProvider.user, isRegistration: true)
            : ScaffoldMessenger(
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: Stack(
                    children: <Widget>[
                      _buildOffstageNavigator(TabItemEnum.search),
                      _buildOffstageNavigator(TabItemEnum.home),
                      _buildOffstageNavigator(TabItemEnum.user),
                      _bottomNavigationBar()
                    ],
                  ),
                  backgroundColor: Theme.of(context).colorScheme.surface,
                ),
              );
  }

  _bottomNavigationBar() {
    bool isBottomNavigationVisible =
        context.watch<TabProvider>().isBottomNavigationVisible;
    return BottomNavigationAnimation(
      isVisible: isBottomNavigationVisible,
      child: const Align(
          alignment: Alignment.bottomCenter,
          child: BottomNavigationComponent()),
    );
  }

  Widget _buildOffstageNavigator(TabItemEnum tabItem) {
    final currentTab = context.watch<TabProvider>().currentTab;
    switch (tabItem) {
      case TabItemEnum.search:
        return Offstage(
          offstage: currentTab != tabItem,
          child: SearchTabNavigator(
            navigatorKey: _tabProvider.navigatorKeys[tabItem],
            tabItem: tabItem,
          ),
        );
      case TabItemEnum.home:
        return Offstage(
          offstage: currentTab != tabItem,
          child: HomeTabNavigator(
            navigatorKey: _tabProvider.navigatorKeys[tabItem],
            tabItem: tabItem,
          ),
        );
      case TabItemEnum.user:
        return Offstage(
          offstage: currentTab != tabItem,
          child: UserTabNavigator(
            navigatorKey: _tabProvider.navigatorKeys[tabItem],
            tabItem: tabItem,
          ),
        );
    }
  }
}
