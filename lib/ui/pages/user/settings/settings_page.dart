import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/pages/user/settings/credits_page.dart';
import 'package:challenge/ui/pages/user/settings/delete_user_page.dart';
import 'package:challenge/ui/pages/user/settings/edit_user/edit_user_page.dart';
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
    return RawScrollbar(
      controller: scrollController,
      radius: const Radius.circular(4),
      thumbColor: themeColor3,
      padding: const EdgeInsets.only(right: 4),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        children: [
          SpaceColumnComponent(
            child: ListItemIconTextComponent(
                onTap: onTapEdit, icon: IconEnum.edit.icon, title: 'Edit'),
          ),
          SpaceColumnComponent(
            child: ListItemIconTextComponent(
                onTap: onTapFeedback,
                icon: Icons.feedback_outlined,
                title: 'Feedback'),
          ),
          SpaceColumnComponent(
            child: ListItemIconTextComponent(
                onTap: onTapCredits,
                icon: Icons.handshake_outlined,
                title: 'Credits'),
          ),
          SpaceColumnComponent(
            child: ListItemIconTextComponent(
                onTap: onTapLogout,
                icon: Icons.logout_rounded,
                title: 'Log out'),
          ),
          const SpaceComponent(),
          SpaceColumnComponent(
            child: ListItemIconTextComponent(
                onTap: onTapDeleteUser,
                icon: IconEnum.delete.icon,
                title: 'Delete',
                iconColor: Colors.red[300]!,
                textColor: Colors.red[300]!),
          )
        ],
      ),
    );
  }

  onTapLogout() async {
    await authService.logout();
    usersProvider.resetLocalUser();
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

  void onTapEdit() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) =>
            EditUserPage(preTitle: '${widget.preTitle}/$title'),
      ),
    );
  }

  void onTapDeleteUser() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => DeleteUserPage(
          preTitle: '${widget.preTitle}/$title',
        ),
      ),
    );
  }
}
