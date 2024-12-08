import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/providers/notifications_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_child_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/loading_circle/loading_circle_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/pages/user/settings/blocked_users_page.dart';
import 'package:challenge/ui/pages/user/settings/credits_page.dart';
import 'package:challenge/ui/pages/user/settings/delete_user_page.dart';
import 'package:challenge/ui/pages/user/settings/edit_notification_page.dart';
import 'package:challenge/ui/pages/user/settings/edit_user/edit_user_page.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
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
  final ScrollController _scrollController = ScrollController();
  late final _usersProvider =
      Provider.of<UsersProvider>(context, listen: false);
  late final _groupChallengesProvider =
      Provider.of<GroupChallengesProvider>(context, listen: false);
  late final _notificationsProvider =
      Provider.of<NotificationsProvider>(context, listen: false);

  late final String _title = 'Settings';

  bool _isLogoutLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        preTitle: widget.preTitle,
        titleText: _title,
      ),
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: _buildList(),
      ),
      bottomNavigationBar: const BottomNavigationComponent(),
    );
  }

  Widget _buildList() {
    return RawScrollbar(
      controller: _scrollController,
      radius: const Radius.circular(4),
      thumbColor: Theme.of(context).colorScheme.tertiary,
      padding: const EdgeInsets.only(right: 4),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        children: [
          SpaceColumnComponent(
            child: ListItemIconTextComponent(
                onTap: onTapEdit, icon: IconEnum.edit.icon, title: 'Edit'),
          ),
          SpaceColumnComponent(
            child: ListItemIconTextComponent(
                onTap: onTapNotifications,
                icon: IconEnum.notification.icon,
                title: 'Notifications'),
          ),
          SpaceColumnComponent(
            child: ListItemIconTextComponent(
                onTap: onTapFeedback,
                icon: IconEnum.feedback.icon,
                title: 'Feedback'),
          ),
          SpaceColumnComponent(
            child: ListItemIconTextComponent(
                onTap: onTapCredits,
                icon: IconEnum.credits.icon,
                title: 'Credits'),
          ),
          SpaceColumnComponent(
              child: ListItemIconTextComponent(
            icon: IconEnum.blockedUsers.icon,
            title: 'Blocked Users',
            onTap: onTapBlockedUsers,
          )),
          SpaceColumnComponent(
            child: ListItemIconTextChildComponent(
              onTap: onTapLogout,
              icon: IconEnum.logout.icon,
              text: 'Log out',
              child: Visibility(
                  visible: _isLogoutLoading,
                  child: const LoadingCircleComponent()),
            ),
          ),
          const SpaceComponent(
            heightMultiplier: 3,
          ),
          SpaceColumnComponent(
              child: ListItemIconTextComponent(
            onTap: onTapDeleteUser,
            icon: IconEnum.delete.icon,
            title: 'Delete',
            iconColor: Theme.of(context).colorScheme.red,
            textColor: Theme.of(context).colorScheme.red,
          ))
        ],
      ),
    );
  }

  onTapLogout() async {
    if (_isLogoutLoading) {
      return;
    }

    setState(() {
      _isLogoutLoading = true;
    });
    await _usersProvider.logout();
    _groupChallengesProvider.resetLocalList();
    _notificationsProvider.resetLocalList();
    if (mounted) {
      setState(() {
        _isLogoutLoading = false;
      });
    }
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
            EditUserPage(preTitle: '${widget.preTitle}/$_title'),
      ),
    );
  }

  void onTapDeleteUser() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => DeleteUserPage(
          preTitle: '${widget.preTitle}/$_title',
        ),
      ),
    );
  }

  void onTapBlockedUsers() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => BlockedUsersPage(
          preTitle: '${widget.preTitle}/$_title',
        ),
      ),
    );
  }

  void onTapNotifications() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => EditNotificationPage(
          preTitle: '${widget.preTitle}/$_title',
        ),
      ),
    );
  }
}
