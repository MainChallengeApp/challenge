import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/enums/tab_item_enum.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/providers/user_challenges_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/ui/components/loading_circle/refresh_indicator_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/custom_card_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:challenge/ui/components/simple_components/title_component.dart';
import 'package:challenge/ui/components/user/bio_component.dart';
import 'package:challenge/ui/components/user/user_picture_min_component.dart';
import 'package:challenge/ui/pages/user/connections/connections_page.dart';
import 'package:challenge/ui/pages/user/settings/edit_user/edit_picture_page.dart';
import 'package:challenge/ui/pages/user/settings/edit_user/edit_user_page.dart';
import 'package:challenge/ui/pages/user/settings/edit_user/edit_username_page.dart';
import 'package:challenge/ui/pages/user/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key, required this.title, this.onPush});
  final String title;
  final ValueChanged<ChallengeModel>? onPush;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  ScrollController scrollController = ScrollController();

  AuthService authService = AuthService();
  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);
  late final listeningUsersProvider =
      Provider.of<UsersProvider>(context, listen: true);

  late final listeningUserChallengesProvider =
      Provider.of<UserChallengesProvider>(context, listen: true);

  late UserModel user;

  int amountOfChallenges = 0;

  List<UserModel> outgoingConnections = [];

  bool isBioExpanded = false;

  @override
  void initState() {
    super.initState();
    usersProvider.getUser().then((_) {
      usersProvider.getConnections();
    });
  }

  @override
  Widget build(BuildContext context) {
    user = listeningUsersProvider.user;
    amountOfChallenges = listeningUserChallengesProvider.userChallenges.length;
    outgoingConnections = listeningUsersProvider.outgoingConnections;
    return Scaffold(
        appBar: AppBarComponent(
          preTitle: widget.title,
          isFirstPageInRoute: true,
          actions: actions(user),
        ),
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.white,
          child: RefreshIndicatorComponent(
            onRefresh: () async {
              await usersProvider.getUser();
              await usersProvider.getConnections();
            },
            scrollController: scrollController,
            child: CardComponent(
              scrollPhysics: const AlwaysScrollableScrollPhysics(),
              scrollController: scrollController,
              children: [
                pictureAndUsername(user),
                bio(user),
                challengesAndConnections(user),
                expandedSpace(),
                edit(user)
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomNavigationComponent());
  }

  List<Widget> actions(UserModel user) {
    return [
      GestureDetector(onTap: () {}, child: Icon(IconEnum.inbox.icon)),
      const SpaceComponent(),
      GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                NoAnimationPageRouteComponent(
                  builder: (context) => SettingsPage(
                    preTitle: widget.title,
                    user: user,
                  ),
                ));
          },
          child: Icon(IconEnum.settings.icon)),
    ];
  }

  bio(UserModel user) {
    BioComponent bioComponent = BioComponent(
      bio: user.bio,
      onTap: () {
        setState(() {
          isBioExpanded = !isBioExpanded;
        });
      },
      isBioExpanded: isBioExpanded,
    );
    return isBioExpanded
        ? Expanded(
            child: Column(
              children: [
                Expanded(child: bioComponent),
                const SpaceComponent(),
              ],
            ),
          )
        : user.bio != null && user.bio!.isNotEmpty
            ? SpaceColumnComponent(
                heightMultiplier: 2,
                child: bioComponent,
              )
            : Container();
  }

  challengesAndConnections(UserModel user) {
    return Visibility(
      visible: !isBioExpanded,
      child: SpaceColumnComponent(
        child: Row(
          children: [
            Expanded(
              child: TapContainerComponent(
                onTap: () {
                  context.read<TabProvider>().selectTab(TabItemEnum.home);

                  var homeNavigator =
                      navigatorKeys[TabItemEnum.home]!.currentState!;

                  homeNavigator.popUntil((route) => route.isFirst);
                },
                child: Column(
                  children: [
                    Text(
                      amountOfChallenges.toString(),
                    ),
                    const Text(
                      'Challenges',
                      style: TextStyle(fontSize: 9),
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
                      outgoingConnections
                          .where((outgoingConnection) =>
                              outgoingConnection.isConnectedWith(user.id))
                          .length
                          .toString(),
                    ),
                    const Text(
                      'Connections',
                      style: TextStyle(fontSize: 9),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  edit(UserModel user) {
    return TapContainerComponent(
      onTap: onTapEdit,
      child: const Center(
        child: Text(
          'Edit',
        ),
      ),
    );
  }

  userName(UserModel user) {
    return SpaceColumnComponent(
      height: 11,
      child: TitleComponent(title: '@${user.username}'),
    );
  }

  expandedSpace() {
    return isBioExpanded ? Container() : Expanded(child: Container());
  }

  pictureAndUsername(UserModel user) {
    return SpaceColumnComponent(
      child: Row(
        children: [
          UserPictureMinComponent(
            userPictureUrl: user.pictureUrl,
            onTap: onTapPicture,
          ),
          const SpaceComponent(),
          Expanded(
              child: TapContainerComponent(
                  onTap: onTapUsername,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '@${user.username}',
                        overflow: TextOverflow.ellipsis,
                      )))),
        ],
      ),
    );
  }

  onTapPicture() {
    Navigator.push(
        context,
        NoAnimationPageRouteComponent(
          builder: (context) => EditPicturePage(
            preTitle: widget.title,
            user: user,
          ),
        ));
  }

  onTapUsername() {
    Navigator.push(
        context,
        NoAnimationPageRouteComponent(
          builder: (context) => EditUsernamePage(
            preTitle: widget.title,
            user: user,
          ),
        ));
  }

  onTapEdit() {
    Navigator.push(
        context,
        NoAnimationPageRouteComponent(
          builder: (context) => EditUserPage(
            preTitle: widget.title,
          ),
        ));
  }

  onTapConnections() {
    Navigator.push(
        context,
        NoAnimationPageRouteComponent(
          builder: (context) => ConnectionsPage(
            preTitle: widget.title,
          ),
        ));
  }
}
