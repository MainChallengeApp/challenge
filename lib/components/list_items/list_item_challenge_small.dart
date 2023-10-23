import 'package:flutter/material.dart';
import 'package:challenge/models/challenge.dart';

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
          width: double.infinity,
          height: 64,
          margin: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
              borderRadius: const BorderRadius.all(Radius.circular(24))),
          child: Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(241, 245, 249, 1),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                width: 40,
                height: 40,
                margin: const EdgeInsets.all(12),
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: Image.asset(challenge.thumbnailPath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: Image.asset("assets/images/unknown.png",
                                    fit: BoxFit.cover),
                              ),
                            ))),
              ),
              Text(challenge.title)
            ],
          ),
        ),
      ),
    );
  }
}
