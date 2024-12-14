import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:flutter/material.dart';

class CreditsPage extends StatelessWidget {
  const CreditsPage({super.key});

  final String _title = 'Credits';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(title: _title),
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
