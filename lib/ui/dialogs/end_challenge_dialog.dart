import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/dialogs/custom_dialog.dart';
import 'package:flutter/material.dart';

class EndChallengeDialog {
  static Future<void> show(
      {required BuildContext context,
      required String challengeTitle,
      required Function onTapYes}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
            title: 'End $challengeTitle?',
            text:
                'Do you really want to end this Challenge?\n\nThis action can not be undone.\n',
            buttons: [
              Expanded(child: yesButton(context, onTapYes)),
              const SpaceComponent(),
              Expanded(child: noButton(context))
            ]);
      },
    );
  }

  static yesButton(BuildContext context, Function onTapYes) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: CustomButtonComponent(
        onTap: () {
          onTapYes.call();
          Navigator.pop(context);
        },
        text: 'End',
      ),
    );
  }

  static noButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: CustomButtonComponent(
        onTap: () {
          Navigator.pop(context);
        },
        text: 'Cancel',
        isPrimaryButton: true,
      ),
    );
  }
}
