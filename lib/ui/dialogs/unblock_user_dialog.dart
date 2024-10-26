import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/dialogs/custom_dialog.dart';
import 'package:flutter/material.dart';

class UnblockUserDialog extends StatefulWidget {
  final UserModel user;
  final Function onTapYes;

  const UnblockUserDialog({
    Key? key,
    required this.user,
    required this.onTapYes,
  }) : super(key: key);

  static Future<void> show({
    required BuildContext context,
    required UserModel user,
    required Function onTapYes,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return UnblockUserDialog(
          user: user,
          onTapYes: onTapYes,
        );
      },
    );
  }

  @override
  State<UnblockUserDialog> createState() => _UnblockUserDialogState();
}

class _UnblockUserDialogState extends State<UnblockUserDialog> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'Unblock ${widget.user.username}?',
      text:
          'Do you really want to unblock this user?\n\n The other user will be able to find you again.\n',
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
            Navigator.pop(context);
          }
        },
        text: 'Unblock',
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
