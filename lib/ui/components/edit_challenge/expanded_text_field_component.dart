import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/services/database_service.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
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
          maxLength: DatabaseService.maxCharactersShort,
          buildCounter: (_,
                  {required currentLength,
                  required isFocused,
                  required maxLength}) =>
              null,
          style: Theme.of(context).textTheme.textInputSmall,
          onChanged: (value) => editChallenge.title = value,
          decoration: InputDecoration.collapsed(
              hintText: 'Title',
              hintStyle: Theme.of(context).textTheme.textInputHintSmall),
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
