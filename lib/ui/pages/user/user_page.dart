import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/enums/tab_item_enum.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/providers/notifications_provider.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/loading_circle/refresh_indicator_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:challenge/ui/components/user/bio_component.dart';
import 'package:challenge/ui/components/user/user_picture_min_component.dart';
import 'package:challenge/ui/pages/user/connections/connections_page.dart';
import 'package:challenge/ui/pages/user/notifications/notifications_list_page.dart';
import 'package:challenge/ui/pages/user/settings/edit_user/edit_bio_page.dart';
import 'package:challenge/ui/pages/user/settings/edit_user/edit_picture_page.dart';
import 'package:challenge/ui/pages/user/settings/edit_user/edit_username_page.dart';
import 'package:challenge/ui/pages/user/settings/settings_page.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key, required this.title});
  final String title;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  ScrollController scrollController = ScrollController();

  AuthService authService = AuthService();
  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);
  late final listeningUsersProvider =
      Provider.of<UsersProvider>(context, listen: true);

  late final listeningGroupChallengesProvider =
      Provider.of<GroupChallengesProvider>(context, listen: true);

  late final listeningNotificationsProvider =
      Provider.of<NotificationsProvider>(context, listen: true);

  late final _tabProvider = Provider.of<TabProvider>(context, listen: false);

  late UserModel user;

  @override
  void initState() {
    super.initState();
    usersProvider.getUser().then((_) {
      usersProvider.getConnections();
      listeningNotificationsProvider.getUserNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    user = listeningUsersProvider.user;
    return ScaffoldComponent(
        appBar: AppBarComponent(
          title: widget.title,
          isFirstPageInRoute: true,
          actions: actions(user),
        ),
        body: Container(
          color: Colors.white,
          child: RefreshIndicatorComponent(
            onRefresh: () async {
              await usersProvider.getUser().then((_) async {
                await usersProvider.getConnections();
                await listeningNotificationsProvider.getUserNotifications();
              });
            },
            scrollController: scrollController,
            child: CardComponent(
              scrollPhysics: const AlwaysScrollableScrollPhysics(),
              scrollController: scrollController,
              children: [
                _profilePicture(user),
                _username(user),
                _bio(user),
                _challengesAndConnections(user),
                _expandedSpace(),
                _notifications(user)
              ],
            ),
          ),
        ));
  }

  List<Widget> actions(UserModel user) {
    return [
      GestureDetector(
          onTap: () => onTapSettings(user),
          child: Icon(IconEnum.settings.icon)),
    ];
  }

  _bio(UserModel user) {
    return SpaceColumnComponent(
      child: BioComponent(
        bio: user.bio,
        onTap: onTapBio,
        isBioExpanded: false,
      ),
    );
  }

  _challengesAndConnections(UserModel user) {
    return SpaceColumnComponent(
      child: Row(
        children: [
          Expanded(
            child: TapContainerComponent(
              onTap: () {
                context.read<TabProvider>().selectTab(TabItemEnum.home);

                var homeNavigator =
                    _tabProvider.navigatorKeys[TabItemEnum.home]!.currentState!;

                homeNavigator.popUntil((route) => route.isFirst);
              },
              child: Column(
                children: [
                  Text(
                    listeningGroupChallengesProvider.groupChallenges.length
                        .toString(),
                    style: Theme.of(context).textTheme.bodyMediumBlack,
                  ),
                  Text(
                    'Challenges',
                    style: Theme.of(context).textTheme.subTitle,
                  ),
                ],
              ),
            ),
          ),
          const SpaceComponent(),
          Expanded(
            child: TapContainerComponent(
              onTap: onTapConnections,
              child: Column(
                children: [
                  Text(
                    listeningUsersProvider.confirmedConnections.length
                        .toString(),
                    style: Theme.of(context).textTheme.bodyMediumBlack,
                  ),
                  Text(
                    'Connections',
                    style: Theme.of(context).textTheme.subTitle,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _notifications(UserModel user) {
    return CustomButtonComponent(
      onTap: onTapNotifications,
      text:
          '${listeningNotificationsProvider.userNotifications.isEmpty ? '' : '${listeningNotificationsProvider.userNotifications.length} '}Notification${listeningNotificationsProvider.userNotifications.length == 1 ? '' : 's'}',
    );
  }

  _expandedSpace() {
    return const Expanded(child: SizedBox());
  }

  _username(UserModel user) {
    return SpaceColumnComponent(
      child: TapContainerComponent(
          onTap: onTapUsername,
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                user.username,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.textInputSmall,
              ))),
    );
  }

  onTapPicture() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditPicturePage(
            user: user,
          ),
        )).then((_) {
      _tabProvider.setBottomNavigationVisibility(true);
      if (mounted) {
        setState(() {});
      }
    });
  }

  onTapUsername() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditUsernamePage(
            user: user,
          ),
        )).then((_) {
      _tabProvider.setBottomNavigationVisibility(true);
      if (mounted) {
        setState(() {});
      }
    });
  }

  onTapConnections() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ConnectionsPage(),
        ));
  }

  void onTapNotifications() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NotificationsListPage(),
        ));
  }

  void onTapSettings(UserModel user) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsPage(
            user: user,
          ),
        ));
  }

  _profilePicture(UserModel user) {
    return SpaceColumnComponent(
      child: UserPictureMinComponent(
        userPictureUrl: user.pictureUrl,
        onTap: onTapPicture,
      ),
    );
  }

  void onTapBio() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditBioPage(
            user: user,
          ),
        )).then((_) {
      _tabProvider.setBottomNavigationVisibility(true);
      if (mounted) {
        setState(() {});
      }
    });
  }
}
