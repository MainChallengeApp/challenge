import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/list_items/list_item_image_child_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/pages/profile/settings/credits_page.dart';
import 'package:challenge/ui/pages/profile/settings/delete_account_page.dart';
import 'package:challenge/ui/pages/subpages/edit_profile/edit_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage(
      {super.key, required this.preTitle, this.onPush, required this.user});
  final String preTitle;
  final ValueChanged<ChallengeModel>? onPush;
  final UserModel user;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ScrollController scrollController = ScrollController();

  AuthService authService = AuthService();
  late final UsersProvider usersProvider =
      Provider.of<UsersProvider>(context, listen: true);

  late String title = 'Settings';

  late UserModel user = widget.user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        preTitle: widget.preTitle,
        titleText: title,
      ),
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: _buildList(),
      ),
    );
  }

  Widget _buildList() {
    user = usersProvider.user;
    int itemCount = 5;
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
                  ListItemImageChildComponent(
                      onTap: onTapProfile,
                      icon: IconEnum.profile.icon,
                      url: user.profilePictureUrl,
                      child: Text('@${user.username}')),
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

            if (index == 3) {
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

            if (index == itemCount - 1) {
              return Column(
                children: [
                  const SpaceComponent(
                    heightMultiplier: 5,
                  ),
                  ListItemIconTextComponent(
                      onTap: onTapDeleteAccount,
                      icon: IconEnum.delete.icon,
                      title: 'Delete Account',
                      iconColor: Colors.red[300]!,
                      textColor: Colors.red[300]!),
                  const SpaceComponent()
                ],
              );
            }

            return Container();
          }),
    );
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
          preTitle: widget.preTitle,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  void onTapProfile() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) =>
            EditProfilePage(user: user, preTitle: '${widget.preTitle}/$title'),
      ),
    );
  }

  void onTapDeleteAccount() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => DeleteAccountPage(
          preTitle: '${widget.preTitle}/$title',
        ),
      ),
    );
  }
}
