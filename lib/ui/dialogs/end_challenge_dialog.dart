import 'package:challenge/providers/user_challenges_provider.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/dialogs/custom_dialog.dart';
import 'package:flutter/material.dart';

class EndChallengeDialog {
  static final userChallengesProvider = UserChallengesProvider();

  static Future<void> show(
      {required BuildContext context, required Function onTapYes}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
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
          Navigator.pop(context);
          onTapYes.call();
        },
        text: 'Yes',
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
        text: 'No',
        isPrimaryButton: true,
      ),
    );
  }
}
