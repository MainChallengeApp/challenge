import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/dialogs/custom_dialog.dart';
import 'package:flutter/material.dart';

class DeleteAttemptDialog extends StatefulWidget {
  final Function onTapYes;

  const DeleteAttemptDialog({
    Key? key,
    required this.onTapYes,
  }) : super(key: key);

  static Future<void> show({
    required BuildContext context,
    required Function onTapYes,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return DeleteAttemptDialog(
          onTapYes: onTapYes,
        );
      },
    );
  }

  @override
  State<DeleteAttemptDialog> createState() => _DeleteAttemptDialogState();
}

class _DeleteAttemptDialogState extends State<DeleteAttemptDialog> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'Delete this attempt?',
      text:
          'Do you really want to delete this attempt?\n\nThis action can not be undone.\n',
      buttons: [
        Expanded(child: yesButton(context)),
        const SpaceComponent(),
        Expanded(child: noButton(context)),
      ],
    );
  }

  Widget yesButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: CustomButtonComponent(
        onTap: () async {
          setState(() {
            isLoading = true;
          });
          await widget.onTapYes.call();
          if (mounted) {
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          }
        },
        text: 'Delete',
        isLoading: isLoading,
      ),
    );
  }

  Widget noButton(BuildContext context) {
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
