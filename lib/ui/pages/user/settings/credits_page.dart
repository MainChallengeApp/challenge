import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:flutter/material.dart';

class CreditsPage extends StatelessWidget {
  const CreditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScaffoldComponent(
      appBar: AppBarComponent(title: 'Credits'),
      body: Center(
        child: Text(
          'Jesus Christ\n\n\nMy Parents\n\n\nYou\n\n\nChallenge Icons made by Freepik from www.flaticon.com',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
