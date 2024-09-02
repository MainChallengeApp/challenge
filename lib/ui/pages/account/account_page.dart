import 'dart:developer';

import 'package:challenge/enums/tab_item_enum.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/providers/user_challenges_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/profile/bio_component.dart';
import 'package:challenge/ui/components/profile/profile_picture_component.dart';
import 'package:challenge/ui/components/simple_components/custom_card_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:challenge/ui/components/simple_components/title_component.dart';
import 'package:challenge/ui/pages/account/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key, required this.title, this.onPush});
  final String title;
  final ValueChanged<ChallengeModel>? onPush;

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  ScrollController scrollController = ScrollController();

  AuthService authService = AuthService();
  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);
  late final listeningUsersProvider =
      Provider.of<UsersProvider>(context, listen: true);

  late final listeningUserChallengesProvider =
      Provider.of<UserChallengesProvider>(context, listen: true);

  late UserModel user;

  int amountOfChallenges = 0;

  bool isBioExpanded = false;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    user = listeningUsersProvider.user;
    amountOfChallenges = listeningUserChallengesProvider.userChallenges.length;
    return Scaffold(
        appBar: AppBarComponent(
          preTitle: widget.title,
          isFirstPageInRoute: true,
          actions: actions(user),
        ),
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.white,
          child: CardComponent(
            scrollPhysics: const AlwaysScrollableScrollPhysics(),
            children: [
              profilePicture(user),
              userName(user),
              bio(user),
              challengesAndConnections(user),
              expandedSpace(),
              notifications(user)
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavigationComponent());
  }

  List<Widget> actions(UserModel user) {
    return [
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
          child: const Icon(Icons.settings_outlined))
    ];
  }

  profilePicture(UserModel user) {
    return SpaceColumnComponent(
      height: 11,
      child: ProfilePictureMaxComponent(
        profilePictureUrl: user.profilePictureUrl,
      ),
    );
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
            ? SpaceColumnComponent(child: bioComponent)
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
                onTap: () {},
                child: Column(
                  children: [
                    Text(
                      user.connectionIds.length.toString(),
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

  notifications(UserModel user) {
    return TapContainerComponent(
      onTap: () {},
      child: const Center(
        child: Text(
          'Notifications',
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

  void fetchUser() {
    const int maxRetries = 3;
    const Duration initialDelay = Duration(seconds: 2);

    Future<void> attemptFetchUser(int retryCount, Duration delay) async {
      try {
        var user = await usersProvider.getUser();
        setState(() {
          this.user = user;
        });
      } catch (error) {
        if (retryCount < maxRetries) {
          await Future.delayed(delay);
          attemptFetchUser(retryCount + 1, delay * 2); // Exponential backoff
        } else {
          log('Failed to fetch user after $maxRetries attempts: $error');
        }
      }
    }

    attemptFetchUser(0, initialDelay);
  }
}
