import 'package:challenge/components/navigation/custom_app_bar.dart';
import 'package:flutter/material.dart';

class Credits extends StatelessWidget {
  const Credits({super.key, required this.preTitle});

  final String preTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomeAppBar.build(preTitle: preTitle, title: 'Credits'),
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'My Mom\n\n\nYou\n\n\nChallenge Icons made by Freepik from www.flaticon.com',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
