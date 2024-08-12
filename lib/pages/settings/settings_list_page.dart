import 'package:challenge/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/components/loading_circle/loading_circle_component.dart';
import 'package:challenge/components/navigation/app_bar_component.dart';
import 'package:challenge/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/components/simple_components/space_component.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/pages/settings/credits/credits_page.dart';
import 'package:challenge/services/auth/auth_service.dart';
import 'package:challenge/services/user/users_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsListPage extends StatefulWidget {
  const SettingsListPage({super.key, required this.title, this.onPush});
  final String title;
  final ValueChanged<ChallengeModel>? onPush;

  @override
  State<SettingsListPage> createState() => _SettingsListPageState();
}

class _SettingsListPageState extends State<SettingsListPage> {
  ScrollController scrollController = ScrollController();

  AuthService authService = AuthService();
  UsersService usersService = UsersService();

  late Future<UserModel> userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = usersService.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarComponent(
          preTitle: widget.title,
          isFirstPageInRoute: true,
        ),
        body: Container(
          color: Colors.white,
          child: _buildList(),
        ),
        bottomNavigationBar: const BottomNavigationComponent());
  }

  Widget _buildList() {
    int itemCount = 4;
    return FutureBuilder<UserModel>(
        future: userFuture,
        builder: (context, AsyncSnapshot<UserModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingCircleComponent());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            UserModel user = snapshot.data!;
            return RawScrollbar(
              controller: scrollController,
              radius: const Radius.circular(4),
              thumbColor: themeColor3,
              padding: const EdgeInsets.only(right: 4),
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: scrollController,
                  itemCount: itemCount,
                  itemBuilder: (BuildContext content, int index) {
                    if (index == 0) {
                      return Column(
                        children: [
                          ListItemIconTextComponent(
                              icon: Icons.person_outlined, title: user.email),
                          const SpaceComponent()
                        ],
                      );
                    }

                    if (index == 1) {
                      return Column(
                        children: [
                          ListItemIconTextComponent(
                              onTap: onTapFeedback,
                              icon: Icons.feedback_outlined,
                              title: 'Feedback'),
                          const SpaceComponent()
                        ],
                      );
                    }

                    if (index == 2) {
                      return Column(
                        children: [
                          ListItemIconTextComponent(
                              onTap: onTapCredits,
                              icon: Icons.handshake_outlined,
                              title: 'Credits'),
                          const SpaceComponent()
                        ],
                      );
                    }

                    if (index == itemCount - 1) {
                      return Column(
                        children: [
                          ListItemIconTextComponent(
                              onTap: onTapLogout,
                              icon: Icons.logout_rounded,
                              title: 'Log out'),
                          const SpaceComponent()
                        ],
                      );
                    }

                    return Container();
                  }),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        });
  }

  onTapLogout() {
    authService.logout();
  }

  onTapFeedback() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'main.challenge.app@gmail.com',
      queryParameters: {
        'subject': 'Feedback',
        // You can add other parameters like 'body', 'cc', 'bcc', etc.
      },
    );

    // ignore: deprecated_member_use
    if (await canLaunch(emailLaunchUri.toString())) {
      // ignore: deprecated_member_use
      await launch(emailLaunchUri.toString());
    } else {
      throw 'Could not launch $emailLaunchUri';
    }
  }

  onTapCredits() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => CreditsPage(
          preTitle: widget.title,
        ),
      ),
    ).then((_) => setState(() {}));
  }
}
