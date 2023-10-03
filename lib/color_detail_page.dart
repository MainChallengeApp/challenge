import 'package:flutter/material.dart';
import 'package:nested_navigation_demo_flutter/globals.dart';

class ColorDetailPage extends StatelessWidget {
  const ColorDetailPage(
      {super.key,
      // required this.color,
      required this.title,
      this.challengeId = 0,
      // required this.challenge
      });
  // final MaterialColor color;
  final String title;
  // final Challenge challenge;
  final int challengeId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: const Icon(Icons.chevron_left, color: Colors.black,),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Align(
          alignment: Alignment.topLeft,
          child: Text(
            '$title/$challengeId',
            style: const TextStyle(color: Colors.black, fontSize: appBarFontSize),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
      ),
    );
  }
}
