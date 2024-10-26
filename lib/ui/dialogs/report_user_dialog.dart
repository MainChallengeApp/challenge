import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/dialogs/custom_dialog.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';

class ReportUserDialog extends StatefulWidget {
  final UserModel user;
  final Function(String) onTapYes;

  const ReportUserDialog({
    Key? key,
    required this.user,
    required this.onTapYes,
  }) : super(key: key);

  static Future<void> show({
    required BuildContext context,
    required UserModel user,
    required Function(String) onTapYes,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ReportUserDialog(
            user: user,
            onTapYes: onTapYes,
          ),
        );
      },
    );
  }

  @override
  _ReportUserDialogState createState() => _ReportUserDialogState();
}

class _ReportUserDialogState extends State<ReportUserDialog> {
  final TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'Report ${widget.user.username}?',
      text:
          'Do you really want to report this user?\n\n Please provide a reason for the report:\n',
      buttons: [
        Expanded(child: yesButton(context)),
        const SpaceComponent(),
        Expanded(child: noButton(context)),
      ],
      child: SpaceColumnComponent(
        child: CustomContainerComponent(
          isHeightDynamic: true,
          child: TextField(
            controller: textEditingController,
            maxLines: 3,
            style: Theme.of(context).textTheme.textInputSmall,
            decoration: InputDecoration.collapsed(
              hintText: 'Reason for report',
              hintStyle: Theme.of(context).textTheme.textInputHintSmall,
            ),
          ),
        ),
      ),
    );
  }

  Widget yesButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: CustomButtonComponent(
        onTap: () async {
          FocusScope.of(context).unfocus();
          setState(() {
            isLoading = true;
          });
          await widget.onTapYes.call(textEditingController.text);
          if (mounted) {
            Navigator.pop(context);
          }
        },
        text: 'Report',
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
