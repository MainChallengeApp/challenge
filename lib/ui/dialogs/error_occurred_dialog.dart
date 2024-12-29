import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/dialogs/custom_dialog.dart';
import 'package:flutter/material.dart';

class ErrorOccurredDialog {
  static final tabProvider = getIt<TabProvider>();

  static Future<void> show({required String? errorText}) async {
    await showDialog(
      context: tabProvider.getCurrentContext(),
      builder: (context) {
        return CustomDialog(
            title: 'Error Occurred',
            text: errorText == null
                ? 'Oh oh! An error occurred...sorry\n'
                : '$errorText\n',
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
