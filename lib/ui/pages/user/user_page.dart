import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/enums/tab_item_enum.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/providers/notifications_provider.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
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
  final _scrollController = ScrollController();

  final _tabProvider = getIt<TabProvider>();
  final _usersProvider = getIt<UsersProvider>();
  late UsersProvider _listeningUsersProvider;
  late GroupChallengesProvider _listeningGroupChallengesProvider;
  late NotificationsProvider _listeningNotificationsProvider;

  late UserModel _user;

  @override
  void initState() {
    super.initState();
    _usersProvider.getUser().then((_) {
      _usersProvider.getConnections();
      _listeningNotificationsProvider.getUserNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    _listeningUsersProvider = Provider.of<UsersProvider>(context);
    _listeningGroupChallengesProvider =
        Provider.of<GroupChallengesProvider>(context);
    _listeningNotificationsProvider =
        Provider.of<NotificationsProvider>(context);
    _user = _listeningUsersProvider.user;
    return ScaffoldComponent(
        appBar: AppBarComponent(
          title: widget.title,
          isFirstPageInRoute: true,
          actions: actions(_user),
        ),
        body: Container(
          color: Colors.white,
          child: RefreshIndicatorComponent(
            onRefresh: () async {
              await _usersProvider.getUser().then((_) async {
                await _usersProvider.getConnections();
                await _listeningNotificationsProvider.getUserNotifications();
              });
            },
            scrollController: _scrollController,
            child: CardComponent(
              scrollPhysics: const AlwaysScrollableScrollPhysics(),
              scrollController: _scrollController,
              children: [
                _profilePicture(_user),
                _username(_user),
                _bio(_user),
                _challengesAndConnections(_user),
                _expandedSpace(),
                _notifications(_user)
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
                    _listeningGroupChallengesProvider.groupChallenges.length
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
                    _listeningUsersProvider.confirmedConnections.length
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
          '${_listeningNotificationsProvider.userNotifications.isEmpty ? '' : '${_listeningNotificationsProvider.userNotifications.length} '}Notification${_listeningNotificationsProvider.userNotifications.length == 1 ? '' : 's'}',
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
            user: _user,
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
            user: _user,
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
            user: _user,
          ),
        )).then((_) {
      _tabProvider.setBottomNavigationVisibility(true);
      if (mounted) {
        setState(() {});
      }
    });
  }
}
