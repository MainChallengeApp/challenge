import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:challenge/components/simple_components/custom_container_component.dart';
import 'package:flutter/material.dart';

class DescriptionBigComponent extends StatelessWidget {
  final ChallengeModel editChallenge;

  const DescriptionBigComponent({
    super.key,
    required this.editChallenge,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainerComponent(
        heightFactor: 3,
        child: TapRegion(
          child: TextField(
              maxLines: 999,
              style: const TextStyle(fontSize: basicFontSize),
              onChanged: (value) => editChallenge.description = value,
              controller: TextEditingController()
                ..text = editChallenge.description,
              decoration:
                  const InputDecoration.collapsed(hintText: 'Description')),
        ));
  }
}
