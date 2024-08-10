import 'package:flutter/material.dart';

class LeadingAppIconComponent extends StatelessWidget {
  const LeadingAppIconComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Center(
        child: Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/icons/challenge_icon_black.png'),
            fit: BoxFit.contain,
          )),
        ),
      ),
    );
  }
}
