import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/loading_circle/loading_circle_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/custom_card_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/pages/profile/credits/credits_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

  @override
  void initState() {
    super.initState();
    userFuture = usersProvider.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarComponent(
          preTitle: widget.title,
          isFirstPageInRoute: true,
          actions: const [Icon(Icons.settings_outlined)],
        ),
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.white,
          child: const CardComponent(
            children: [],
          ),
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
