import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/profile/user_profile_picture_component.dart';
import 'package:challenge/ui/components/simple_components/custom_card_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/components/simple_components/title_component.dart';
import 'package:challenge/ui/pages/profile/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.title, this.onPush});
  final String title;
  final ValueChanged<ChallengeModel>? onPush;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ScrollController scrollController = ScrollController();

  AuthService authService = AuthService();
  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);
  late final listeningProvider =
      Provider.of<UsersProvider>(context, listen: true);

  late UserModel user;

  @override
  void initState() {
    super.initState();
    usersProvider.getUser().then((user) {
      setState(() {
        this.user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    user = listeningProvider.user;
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
              profileUserName(user),
              bio(user),
              challengesAndConnections(user),
              const Expanded(
                child: SizedBox(),
              ),
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
      child: UserProfilePictureMaxComponent(
        profilePictureUrl: user.profilePictureUrl,
      ),
    );
  }

  bio(UserModel user) {
    return Visibility(
      visible: user.bio != null,
      child: SpaceColumnComponent(
        child: CustomContainerComponent(
          child: Text(
            user.bio ?? '',
            style: const TextStyle(color: themeColor3),
          ),
        ),
      ),
    );
  }

  challengesAndConnections(UserModel user) {
    return SpaceColumnComponent(
      child: Row(
        children: [
          const Expanded(
            child: CustomContainerComponent(
              child: Column(
                children: [
                  Text(
                    '0',
                  ),
                  Text(
                    'Challenges',
                    style: TextStyle(fontSize: 9),
                  ),
                ],
              ),
            ),
          ),
          const SpaceComponent(),
          Expanded(
            child: CustomContainerComponent(
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
    );
  }

  notifications(UserModel user) {
    return const CustomContainerComponent(
      child: Center(
        child: Text(
          'Notifications',
        ),
      ),
    );
  }

  profileUserName(UserModel user) {
    return SpaceColumnComponent(
      height: 11,
      child: TitleComponent(title: '@${user.username}'),
    );
  }
}
