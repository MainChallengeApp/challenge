import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_email_component.dart';
import 'package:challenge/ui/components/list_items/list_item_password_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/simple_components/custom_card_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key, required this.preTitle});

  final String preTitle;

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);

  final String titleText = 'Delete Account';

  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();

  String? emailErrorText;
  String? passwordErrorText;

  final authService = AuthService();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(preTitle: widget.preTitle, titleText: titleText),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const SpaceColumnComponent(
            heightMultiplier: 2,
            child: CustomContainerComponent(
              borderRadius: CardComponent.standardBorderRadius,
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: 150,
              child: Center(
                child: Text(
                  'Please enter your email and password to delete your Account.\n\n\nThis action will delete all your data and cannot be undone.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SpaceColumnComponent(
            child: ListItemEmailComponent(
                textEditingController: emailTextEditingController,
                errorText: emailErrorText,
                onChangeTextField: (_) => setState(() {
                      emailErrorText = null;
                      passwordErrorText = null;
                    })),
          ),
          SpaceColumnComponent(
            child: ListItemPasswordComponent(
                textEditingController: passwordTextEditingController,
                errorText: passwordErrorText,
                onChangeTextField: (_) => setState(() {
                      emailErrorText = null;
                      passwordErrorText = null;
                    })),
          ),
          Expanded(child: Container()),
          SpaceColumnComponent(
            height: 20,
            child: ListItemButtonComponent(
                onTap: onTapDeleteAccount,
                text: 'Delete Account',
                isLoading: isLoading,
                isMainButton: false,
                textColor: Colors.red[300]!),
          ),
        ],
      ),
    );
  }

  void onTapDeleteAccount() async {
    if (isLoading) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await authService.loginEmailPassword(
          emailTextEditingController.text, passwordTextEditingController.text);
      await authService.deleteAccount();
      usersProvider.resetLocalUser();
    } on FirebaseAuthException catch (e) {
      setState(() {
        emailErrorText = authService.getEmailErrorMessage(e.code);
        passwordErrorText = authService.getPasswordErrorMessage(e.code);
        if (emailErrorText == null && passwordErrorText == null) {
          emailErrorText = 'Deletion failed';
          passwordErrorText = 'Deletion failed';
        }
      });
    } on Exception {
      setState(() {
        emailErrorText = 'Deletion failed';
        passwordErrorText = 'Deletion failed';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
