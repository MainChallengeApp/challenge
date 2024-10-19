import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:flutter/material.dart';

class ExpandedTextFieldComponent extends StatelessWidget {
  final ChallengeModel editChallenge;

  late final TextEditingController textEditingController =
      TextEditingController(text: editChallenge.title)
        ..selection =
            TextSelection.collapsed(offset: editChallenge.title.length);

  ExpandedTextFieldComponent({
    super.key,
    required this.editChallenge,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: CustomContainerComponent(
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextField(
          style: const TextStyle(fontSize: basicFontSize),
          onChanged: (value) => editChallenge.title = value,
          decoration: const InputDecoration.collapsed(hintText: 'Title'),
          controller: textEditingController,
          onSubmitted: (value) {
            textEditingController.text = value.trim();
            editChallenge.title = value.trim();
          },
          onTapOutside: (_) {
            textEditingController.text = textEditingController.text.trim();
            editChallenge.title = textEditingController.text.trim();
          },
        ),
      ),
    ));
  }
}
