import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/profile/user_name_component.dart';
import 'package:challenge/ui/components/profile/user_profile_picture_component.dart';
import 'package:challenge/ui/components/simple_components/custom_card_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/pages/profile/settings/settings_page.dart';
import 'package:flutter/material.dart';

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
  UsersProvider usersProvider = UsersProvider();

  late Future<UserModel> userFuture;
  late UserModel user;

  @override
  void initState() {
    super.initState();
    userFuture = usersProvider.getUser().then((user) {
      setState(() {
        this.user = user;
      });
      return user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: userFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            user = snapshot.data as UserModel;
            return Scaffold(
                appBar: AppBarComponent(
                  preTitle: widget.title,
                  isFirstPageInRoute: true,
                  actions: actions(),
                ),
                backgroundColor: Colors.white,
                body: Container(
                  color: Colors.white,
                  child: CardComponent(
                    scrollPhysics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      profilePictureAndName(),
                      bio(),
                      challengesAndConnections(),
                      const Expanded(
                        child: SizedBox(),
                      ),
                      notifications()
                    ],
                  ),
                ),
                bottomNavigationBar: const BottomNavigationComponent());
          } else {
            return const Center(child: Text('An error occurred'));
          }
        });
  }

  List<Widget> actions() {
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

  profilePictureAndName() {
    return SpaceColumnComponent(
      child: Row(
        children: [
          UserProfilePictureComponent(
            profilePictureUrl: user.profilePictureUrl,
          ),
          const SpaceComponent(),
          UserNameComponent(
            userName: user.email,
          )
        ],
      ),
    );
  }

  bio() {
    return const SpaceColumnComponent(
      heightMultiplier: 2,
      child: CustomContainerComponent(
        child: Text(
          'bio...',
          style: TextStyle(color: themeColor3),
        ),
      ),
    );
  }

  challengesAndConnections() {
    return const SpaceColumnComponent(
      child: Row(
        children: [
          Expanded(
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
          SpaceComponent(),
          Expanded(
            child: CustomContainerComponent(
              child: Column(
                children: [
                  Text(
                    '0',
                  ),
                  Text(
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

  notifications() {
    return const CustomContainerComponent(
      child: Center(
        child: Text(
          'Notifications',
        ),
      ),
    );
  }
}
