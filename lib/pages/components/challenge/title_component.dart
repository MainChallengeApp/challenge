import 'package:challenge/models/challenge_model.dart';
import 'package:challenge/pages/components/challenge/challenge_total_percentage_component.dart';
import 'package:flutter/material.dart';

class TitleComponent extends StatelessWidget {
  final ChallengeModel challenge;
  final bool isSearch;

  const TitleComponent({
    super.key,
    required this.challenge,
    this.isSearch = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0 + 1),
              child: Text(challenge.title,
                  style: const TextStyle(fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left),
            ),
          ),
        ),
        ChallengeTotalPercentageComponent(
            challenge: challenge,
            isVisible: !isSearch,
            padding: const EdgeInsets.all(8))
      ],
    );
  }
}
