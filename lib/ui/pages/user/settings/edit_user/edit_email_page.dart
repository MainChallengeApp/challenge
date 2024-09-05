import 'package:challenge/services/auth_service.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_email_component.dart';
import 'package:challenge/ui/components/list_items/list_item_password_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditEmailPage extends StatefulWidget {
  final String preTitle;

  const EditEmailPage({
    super.key,
    required this.preTitle,
  });

  @override
  State<EditEmailPage> createState() => _EditEmailPageState();
}

class _EditEmailPageState extends State<EditEmailPage> {
  bool isLoading = false;

  String title = 'Email';

  var authService = AuthService();

  late String email = authService.getCurrentUser() != null
      ? authService.getCurrentUser()!.email!
      : 'email not found';

  late TextEditingController emailTextEditingController = TextEditingController(
    text: email,
  );

  TextEditingController passwordTextEditingController = TextEditingController();

  TextEditingController newEmailTextEditingController = TextEditingController();

  String? passwordError;
  String? newEmailError;

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
                      child: ListItemEmailComponent(
                          textEditingController: newEmailTextEditingController,
                          errorText: newEmailError,
                          hintText: 'New Email',
                          onChangeTextField: (value) {
                            setState(() {
                              newEmailError = null;
                            });
                          }),
                    ),
                    SpaceColumnComponent(
                      heightMultiplier: 2,
                      child: ListItemPasswordComponent(
                          textEditingController: passwordTextEditingController,
                          errorText: passwordError,
                          onChangeTextField: (value) {
                            setState(() {
                              passwordError = null;
                            });
                          }),
                    ),
                    Visibility(
                        visible: isEmailSentMessageVisible,
                        child: const SpaceColumnComponent(
                            child: ListItemContainerComponent(
                          child: Align(
                              alignment: Alignment.center,
                              child: Text('Click the link in your new email')),
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
                      isMainButton: authService
                          .isValidPassword(passwordTextEditingController.text),
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

    if (!authService.isValidPassword(passwordTextEditingController.text)) {
      setState(() {
        passwordError =
            authService.isValidPassword(passwordTextEditingController.text)
                ? null
                : 'Invalid password';
      });
      return;
    }

    setState(() {
      isLoading = true;
    });
    await authService.getCurrentUser()?.reload();
    if (newEmailTextEditingController.text ==
        (authService.getCurrentUser()?.email ?? '')) {
      setState(() {
        newEmailError = 'this is your current email';
        isLoading = false;
      });
      return;
    }

    try {
      await authService.loginEmailPassword(
          authService.getCurrentUser()?.email ?? '',
          passwordTextEditingController.text);
      await authService.updateEmail(newEmailTextEditingController.text);
      setState(() {
        isEmailSentMessageVisible = true;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        passwordError = authService.getPasswordErrorMessage(e.code);
        passwordError ??= 'Login failed';
      });
    } on Exception {
      setState(() {
        passwordError = 'Login failed';
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
