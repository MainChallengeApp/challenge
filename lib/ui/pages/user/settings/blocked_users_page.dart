import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:flutter/material.dart';

class BlockedUsersPage extends StatelessWidget {
  const BlockedUsersPage({super.key, required this.preTitle});

  final String preTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(preTitle: preTitle, titleText: 'Blocked Users'),
      backgroundColor: Colors.white,
      body: const Center(
        child: Text(
          'List of blocked users',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
