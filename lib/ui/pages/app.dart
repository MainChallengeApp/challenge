import 'package:challenge/enums/tab_item_enum.dart';
import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/providers/notifications_provider.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/services/push_notification_service.dart';
import 'package:challenge/ui/components/loading_circle/loading_circle_component.dart';
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
  late final groupChallengesProvider =
      Provider.of<GroupChallengesProvider>(context, listen: false);
  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);
  late final listeningUsersProvider =
      Provider.of<UsersProvider>(context, listen: true);
  late final tabProvider = getIt<TabProvider>();

  final _notificationsProvider = getIt<NotificationsProvider>();

  final authService = AuthService();
  final _pushNotificationService = PushNotificationService();

  bool isLoadingUser = true;
  bool isLoadingUserChallenges = true;

  @override
  void initState() {
    super.initState();

    usersProvider.getUser().then((_) {
      isLoadingUser = false;
      if (mounted) {
        setState(() {});
      }

      groupChallengesProvider.getAllOfUser().then((value) {
        if (value.isEmpty) {
          tabProvider.selectTab(TabItemEnum.search);
        } else {
          tabProvider.selectTab(TabItemEnum.home);
        }
        isLoadingUserChallenges = false;
        if (mounted) {
          setState(() {});
        }
      }).catchError((error) {
        isLoadingUserChallenges = false;
        if (mounted) {
          setState(() {});
        }
        authService.logout();
        // ignore: use_build_context_synchronously
        ErrorOccurredDialog.show(context: context, errorText: error.toString());
      }).timeout((const Duration(seconds: 10)), onTimeout: () {
        isLoadingUserChallenges = false;
        if (mounted) {
          setState(() {});
        }
        ErrorOccurredDialog.show(
            // ignore: use_build_context_synchronously
            context: context,
            errorText: 'Timeout: Could not load user challenges');
      });
    }).catchError((error) {
      isLoadingUser = false;
      isLoadingUserChallenges = false;
      if (mounted) {
        setState(() {});
      }
      authService.logout();
      // ignore: use_build_context_synchronously
      ErrorOccurredDialog.show(context: context, errorText: error.toString());
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
    return isLoadingUser || isLoadingUserChallenges
        ? Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LoadingCircleComponent(),
                  Text('Loading user data... $isLoadingUser'),
                  Text('Loading challenge data... $isLoadingUserChallenges'),
                ],
              ),
            ),
          )
        : listeningUsersProvider.user.username == ''
            ? EditUsernamePage(
                user: listeningUsersProvider.user, isRegistration: true)
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
