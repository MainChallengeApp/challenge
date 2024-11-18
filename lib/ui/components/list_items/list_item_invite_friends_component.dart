import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ListItemInviteFriendsComponent extends StatelessWidget {
  final String username;

  const ListItemInviteFriendsComponent({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return ListItemIconTextComponent(
      onTap: onTap,
      icon: Icons.add,
      title: 'Invite Friends',
    );
  }

  void onTap() {
    Share.share(
        '$username invites you to the Challenge app: https://apps.apple.com/de/app/challenge-your-best-version/id6472225791');
  }
}
