import 'package:challenge/components/simple_components/custom_button_component.dart';
import 'package:challenge/components/simple_components/space_component.dart';
import 'package:challenge/models/challenge/user_challenge_model.dart';
import 'package:flutter/material.dart';

class EndChallengeDialog {
  static late BuildContext context2;

  static Future<void> show(
      BuildContext context, UserChallengeModel userChallenge,
      {required void Function(UserChallengeModel) onTapYes,
      required void Function() onTapNo}) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        context2 = context;
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Dialog(
            insetPadding: const EdgeInsets.only(
                top: 150, bottom: 200, left: 50, right: 50),
            alignment: Alignment.center,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24))),
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(24))),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Do you really want to end this Challenge?\n\nThis action can not be undone.\n',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: _dialogYesButton(
                                context, userChallenge, onTapYes)),
                        const SpaceComponent(),
                        Expanded(child: _dialogNoButton())
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    if (result == true) {
      // End the challenge
    }
  }

  static _dialogYesButton(
      BuildContext context,
      UserChallengeModel userChallenge,
      void Function(UserChallengeModel) onTapYes) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: CustomButtonComponent(
        onTap: () => onTapYes(userChallenge),
        text: 'Yes',
        margin: const EdgeInsets.only(bottom: 16, left: 16),
      ),
    );
  }

  static _dialogNoButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: CustomButtonComponent(
        onTap: () {
          Navigator.pop(context2);
        },
        margin: const EdgeInsets.only(bottom: 16, right: 16),
        text: 'No',
        isPrimaryButton: true,
      ),
    );
  }
}
