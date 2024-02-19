import 'package:challenge/components/navigation/app_bar_component.dart';
import 'package:flutter/material.dart';

class CreditsPage extends StatelessWidget {
  const CreditsPage({super.key, required this.preTitle});

  final String preTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(preTitle: preTitle, titleText: 'Credits'),
      backgroundColor: Colors.white,
      body: const Center(
        child: Text(
          'My Mom\n\n\nYou\n\n\nChallenge Icons made by Freepik from www.flaticon.com',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
