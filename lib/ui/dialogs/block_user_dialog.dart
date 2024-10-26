import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/dialogs/custom_dialog.dart';
import 'package:flutter/material.dart';

class BlockUserDialog extends StatefulWidget {
  final UserModel user;
  final Function onTapYes;

  const BlockUserDialog({
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
        return BlockUserDialog(
          user: user,
          onTapYes: onTapYes,
        );
      },
    );
  }

  @override
  _BlockUserDialogState createState() => _BlockUserDialogState();
}

class _BlockUserDialogState extends State<BlockUserDialog> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'Block ${widget.user.username}?',
      text:
          'Do you really want to block this user?\n\nYou will not be able to find each other.\n',
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
        text: 'Block',
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
