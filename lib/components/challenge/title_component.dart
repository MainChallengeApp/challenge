import 'package:flutter/material.dart';

class TitleComponent extends StatelessWidget {
  final String challengeTitle;

  const TitleComponent({
    super.key,
    required this.challengeTitle,
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
              child: Text(challengeTitle,
                  style: const TextStyle(fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left),
            ),
          ),
        ),
      ],
    );
  }
}
