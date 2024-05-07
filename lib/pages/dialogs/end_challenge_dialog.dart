import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:challenge/pages/components/simple_components/space_component.dart';
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
    return GestureDetector(
      onTap: () => onTapYes(challenge),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 55,
          margin: const EdgeInsets.only(bottom: 16, left: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          child: const Center(
              child: Text(
            'Yes',
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
          )),
        ),
      ),
    );
  }

  static _dialogNoButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context3);
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 55,
          margin: const EdgeInsets.only(bottom: 16, right: 16),
          decoration: BoxDecoration(
              color: themeColor2,
              border: Border.all(
                  width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          child: const Center(
              child: Text(
            'No',
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          )),
        ),
      ),
    );
  }
}
