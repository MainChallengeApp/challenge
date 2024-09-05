import 'package:challenge/services/auth_service.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_password_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditPasswordPage extends StatefulWidget {
  final String preTitle;

  const EditPasswordPage({
    super.key,
    required this.preTitle,
  });

  @override
  State<EditPasswordPage> createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  bool isLoading = false;

  String title = 'Password';

  var authService = AuthService();

  late String email = authService.getCurrentUser() != null
      ? authService.getCurrentUser()!.email!
      : 'email not found';

  TextEditingController oldPasswordTextEditingController =
      TextEditingController();
  TextEditingController newPasswordTextEditingController =
      TextEditingController();

  String? oldPasswordError;
  String? newPasswordError;

  bool isEmailSentMessageVisible = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBarComponent(preTitle: widget.preTitle, titleText: title),
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SpaceColumnComponent(
                      heightMultiplier: 2,
                      child: ListItemPasswordComponent(
                          textEditingController:
                              oldPasswordTextEditingController,
                          errorText: oldPasswordError,
                          hintText: 'Old Password',
                          onChangeTextField: (value) {
                            setState(() {
                              oldPasswordError = null;
                            });
                          }),
                    ),
                    Visibility(
                        visible: isEmailSentMessageVisible,
                        child: const SpaceColumnComponent(
                            child: ListItemContainerComponent(
                          child: Align(
                              alignment: Alignment.center,
                              child: Text('Click the link in your email')),
                        )))
                  ],
                ),
              ),
            ),
            SpaceColumnComponent(
              height: 20,
              child: Row(
                children: [
                  Expanded(
                    child: ListItemButtonComponent(
                      onTap: onTapCancel,
                      text: 'Cancel',
                      isMainButton: false,
                      margin: const EdgeInsets.only(
                          left: ListItemContainerComponent.standardMargin),
                    ),
                  ),
                  const SpaceComponent(
                    width: ListItemContainerComponent.standardMargin,
                  ),
                  Expanded(
                    child: ListItemButtonComponent(
                      margin: const EdgeInsets.only(
                          right: ListItemContainerComponent.standardMargin),
                      onTap: onTapSendLink,
                      text: 'Send Link',
                      isLoading: isLoading,
                      isMainButton: authService.isValidPassword(
                          oldPasswordTextEditingController.text),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onTapSendLink() async {
    if (isLoading) {
      return;
    }

    if (!authService.isValidPassword(oldPasswordTextEditingController.text)) {
      setState(() {
        newPasswordError =
            authService.isValidPassword(newPasswordTextEditingController.text)
                ? null
                : 'Invalid password';

        oldPasswordError =
            authService.isValidPassword(oldPasswordTextEditingController.text)
                ? null
                : 'Invalid password';
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await authService.loginEmailPassword(
          authService.getCurrentUser()?.email ?? '',
          oldPasswordTextEditingController.text);
      await authService
          .sendPasswordResetEmail(authService.getCurrentUser()?.email ?? '');
      setState(() {
        isEmailSentMessageVisible = true;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        oldPasswordError = authService.getPasswordErrorMessage(e.code);
        oldPasswordError ??= 'Login failed';
      });
    } on Exception {
      setState(() {
        oldPasswordError = 'Login failed';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }

    setState(() {
      isLoading = false;
    });
    // ignore: use_build_context_synchronously
    // Navigator.pop(context);
  }

  void onTapCancel() {
    Navigator.pop(context);
  }
}
