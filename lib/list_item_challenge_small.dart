import 'package:flutter/material.dart';
import 'package:nested_navigation_demo_flutter/models/challenge.dart';

class ListItemChallengeSmall extends StatelessWidget {
  const ListItemChallengeSmall(
      {super.key, required this.onTap, required this.challenge});

  final dynamic Function() onTap;

  final Challenge challenge;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          width: 345,
          height: 64,
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(241, 245, 249, 1),
                    image: DecorationImage(
                      image: AssetImage(challenge.thumbnailPath),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(12))),
                margin: const EdgeInsets.all(12),
              ),
              Text(challenge.title)
            ],
          ),
        ),
      ),
    );
  }
}
