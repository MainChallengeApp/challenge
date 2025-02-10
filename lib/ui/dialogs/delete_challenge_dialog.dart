import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/dialogs/custom_dialog.dart';
import 'package:flutter/material.dart';

class DeleteChallengeDialog extends StatefulWidget {
  final String challengeTitle;
  final Function onTapYes;

  const DeleteChallengeDialog({
    Key? key,
    required this.challengeTitle,
    required this.onTapYes,
  }) : super(key: key);

  static Future<void> show({
    required BuildContext context,
    required String challengeTitle,
    required Function onTapYes,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return DeleteChallengeDialog(
          challengeTitle: challengeTitle,
          onTapYes: onTapYes,
        );
      },
    );
  }

  @override
  State<DeleteChallengeDialog> createState() => _DeleteChallengeDialogState();
}

class _DeleteChallengeDialogState extends State<DeleteChallengeDialog> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'Delete Challenge?',
      text:
          'Do you really want to delete the Challenge:\n\n ${widget.challengeTitle}\n\nThis action can not be undone.\n',
      buttons: [
        Expanded(child: noButton(context)),
        const SpaceComponent(),
        Expanded(child: yesButton(context)),
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
        isPrimaryButton: true,
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
      ),
    );
  }
}
