import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_email_component.dart';
import 'package:challenge/ui/components/list_items/list_item_password_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/leading_app_icon_component.dart';
import 'package:challenge/ui/components/simple_components/app_icon_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/pages/auth/login_or_registration_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final String initialEmail;
  final void Function(String) onTapSwitchToRegistration;

  const LoginPage(
      {super.key,
      required this.onTapSwitchToRegistration,
      required this.initialEmail});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController emailTextEditingController =
      TextEditingController(text: widget.initialEmail);
  TextEditingController passwordTextEditingController = TextEditingController();

  AuthService authService = AuthService();

  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);

  String? emailErrorText;
  String? passwordErrorText;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const AppBarComponent(
          title: 'Login',
          isFirstPageInRoute: true,
          leadingIcon: LeadingAppIconComponent(),
        ),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            children: [
              spacing(),
              emailInput(),
              passwordInput(),
              forgotPasswordButton(),
              loginButton(),
              switchToRegistrationButton(),
            ],
          ),
        ),
      ),
    );
  }

  SpaceColumnComponent loginButton() {
    return SpaceColumnComponent(
      heightMultiplier: 2,
      child: ListItemButtonComponent(
        onTap: onTapLogin,
        isMainButton: isMainButton(),
        text: 'Login',
        isLoading: isLoading,
      ),
    );
  }

  SpaceColumnComponent passwordInput() {
    return SpaceColumnComponent(
      child: ListItemPasswordComponent(
        textEditingController: passwordTextEditingController,
        errorText: passwordErrorText,
        onChangeTextField: (_) => setState(() {
          passwordErrorText = null;
          emailErrorText = null;
        }),
        onSubmitted: (_) => onTapLogin(),
      ),
    );
  }

  SpaceColumnComponent emailInput() {
    return SpaceColumnComponent(
      child: ListItemEmailComponent(
        textEditingController: emailTextEditingController,
        errorText: emailErrorText,
        onChangeTextField: (_) => setState(() {
          emailErrorText = null;
          passwordErrorText = null;
        }),
      ),
    );
  }

  SpaceComponent spacing() {
    return SpaceComponent(height: LoginOrRegistrationPage.spaceTop);
  }

  Container appIcon() {
    return Container(
      width: 70,
      height: 70,
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage(
          AppIconComponent.path,
        ),
        fit: BoxFit.contain,
      )),
    );
  }

  onTapLogin() async {
    if (isLoading) {
      return;
    }

    setState(() {
      emailTextEditingController.text = emailTextEditingController.text.trim();
    });

    if (!authService.isValidEmail(emailTextEditingController.text) ||
        !authService.isValidPassword(passwordTextEditingController.text)) {
      setState(() {
        emailErrorText =
            authService.isValidEmail(emailTextEditingController.text)
                ? null
                : 'Invalid email';
        passwordErrorText =
            authService.isValidPassword(passwordTextEditingController.text)
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
          emailTextEditingController.text, passwordTextEditingController.text);
      await usersProvider.login();
    } on FirebaseAuthException catch (e) {
      setState(() {
        emailErrorText = authService.getEmailErrorMessage(e.code);
        passwordErrorText = authService.getPasswordErrorMessage(e.code);
        if (emailErrorText == null && passwordErrorText == null) {
          emailErrorText = 'Login failed';
          passwordErrorText = 'Login failed';
        }
      });
    } on Exception {
      setState(() {
        emailErrorText = 'Login failed';
        passwordErrorText = 'Login failed';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  switchToRegistrationButton() {
    return GestureDetector(
      onTap: () =>
          widget.onTapSwitchToRegistration(emailTextEditingController.text),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Not a member yet?',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(
            width: 5,
          ),
          Text(
            ' Register now!',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  forgotPasswordButton() {
    return SizedBox(
      height: LoginOrRegistrationPage.spaceMid,
      child: GestureDetector(
        onTap: onTapForgotPassword,
        child: Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(
                right: ListItemContainerComponent.standardMargin),
            child: Text(
              'Forgot password?',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ),
    );
  }

  isMainButton() {
    return authService.isValidEmail(emailTextEditingController.text) &&
        authService.isValidPassword(passwordTextEditingController.text);
  }

  void onTapForgotPassword() async {
    if (isLoading) {
      return;
    }

    setState(() {
      emailTextEditingController.text = emailTextEditingController.text.trim();
    });

    if (!authService.isValidEmail(emailTextEditingController.text)) {
      setState(() {
        emailErrorText =
            authService.isValidEmail(emailTextEditingController.text)
                ? null
                : 'Invalid email';
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await authService.sendPasswordResetEmail(emailTextEditingController.text);
      setState(() {
        passwordErrorText = 'Password reset email sent';
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        emailErrorText = authService.getEmailErrorMessage(e.code);
        passwordErrorText = authService.getPasswordErrorMessage(e.code);
        if (emailErrorText == null && passwordErrorText == null) {
          emailErrorText = 'Setting password failed';
          passwordErrorText = 'Setting password failed';
        }
      });
    } on Exception {
      setState(() {
        emailErrorText = 'Setting password failed';
        passwordErrorText = 'Setting password failed';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
