import 'package:challenge/components/simple_components/space_component.dart';
import 'package:challenge/components/simple_components/tap_container_component.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:flutter/material.dart';

class EndChallengeDialog {
  static late BuildContext context3;

  static Future<void> show(BuildContext context, ChallengeModel challenge,
      {required void Function(ChallengeModel) onTapYes,
      required void Function() onTapNo}) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        context3 = context;
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
                            child:
                                _dialogYesButton(context, challenge, onTapYes)),
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

  static _dialogYesButton(BuildContext context, ChallengeModel challenge,
      void Function(ChallengeModel) onTapYes) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: TapContainerComponent(
        onTap: () => onTapYes(challenge),
        margin: const EdgeInsets.only(bottom: 16, left: 16),
        child: const Center(
            child: Text(
          'Yes',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
        )),
      ),
    );
  }

  static _dialogNoButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: TapContainerComponent(
        onTap: () {
          Navigator.pop(context3);
        },
        margin: const EdgeInsets.only(bottom: 16, right: 16),
        backgroundColor: themeColor2,
        child: const Center(
            child: Text(
          'No',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
        )),
      ),
    );
  }
}
