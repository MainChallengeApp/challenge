import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/dialogs/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class OpenAppSettingsDialog {
  static Future<void> show(
      {required BuildContext context,
      required String title,
      required text}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(title: title, text: text, buttons: [
          Expanded(child: noButton(context)),
          const SpaceComponent(),
          Expanded(child: yesButton(context))
        ]);
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
      ),
    );
  }

  static yesButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: CustomButtonComponent(
        onTap: () {
          openAppSettings();
          Navigator.pop(context);
        },
        text: 'Settings',
        isPrimaryButton: true,
      ),
    );
  }
}
