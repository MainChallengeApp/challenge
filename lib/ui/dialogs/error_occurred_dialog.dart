import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/dialogs/custom_dialog.dart';
import 'package:flutter/material.dart';

class ErrorOccurredDialog {
  static Future<void> show({required BuildContext context}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
            title: 'Error Occurred',
            text: 'Oh oh! An error occurred...sorry\n',
            buttons: [Expanded(child: noButton(context))]);
      },
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
