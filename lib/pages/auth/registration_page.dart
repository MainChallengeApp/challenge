import 'package:challenge/components/list_items/list_item_button_component.dart';
import 'package:challenge/components/list_items/list_item_email_component.dart';
import 'package:challenge/components/list_items/list_item_password_component.dart';
import 'package:challenge/components/loading_circle/loading_circle_component.dart';
import 'package:challenge/components/navigation/app_bar_component.dart';
import 'package:challenge/components/navigation/leading_app_icon_component.dart';
import 'package:challenge/components/simple_components/space_column_component.dart';
import 'package:challenge/components/simple_components/space_component.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/services/auth/auth_service.dart';
import 'package:challenge/services/user/users_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key, required this.onTapSwitchToLogin});

  final void Function() onTapSwitchToLogin;

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  AuthService authService = AuthService();
  UsersService usersService = UsersService();

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  String? emailErrorText;
  String? passwordErrorText;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarComponent(
        preTitle: 'Register',
        isFirstPageInRoute: true,
        leadingIcon: isLoading
            ? const LoadingCircleComponent()
            : const LeadingAppIconComponent(),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              spacing(),
              emailInput(),
              passwordInput(),
              registerButton(),
              const Spacer(),
              switchToLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  SpaceColumnComponent registerButton() {
    return SpaceColumnComponent(
      heightMultiplier: 4,
      child: ListItemButtonComponent(
        onTap: onTapRegister,
        isMainButton: isMainButton(),
        text: 'Register',
      ),
    );
  }

  SpaceColumnComponent passwordInput() {
    return SpaceColumnComponent(
      heightMultiplier: 2,
      child: ListItemPasswordComponent(
        textEditingController: passwordTextEditingController,
        errorText: passwordErrorText,
        onChangeTextField: (_) => setState(() {
          emailErrorText = null;
          passwordErrorText = null;
        }),
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
    return const SpaceComponent(
      height: 50,
    );
  }

  Container appIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/icons/challenge_icon_black.png'),
        fit: BoxFit.contain,
      )),
    );
  }

  onTapRegister() async {
    if (!authService.isValidEmail(emailTextEditingController.text)) {
      setState(() {
        emailErrorText = 'Invalid Email';
      });
      return;
    }

    if (!authService.isValidPassword(passwordTextEditingController.text)) {
      setState(() {
        emailErrorText = 'Invalid Password';
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await authService.registerEmailPassword(
          emailTextEditingController.text, passwordTextEditingController.text);

      usersService.createUser(
          email: emailTextEditingController.text, username: '', name: '');
    } on FirebaseAuthException catch (e) {
      setState(() {
        emailErrorText = authService.getEmailErrorMessage(e.code);
        passwordErrorText = authService.getPasswordErrorMessage(e.code);
        if (emailErrorText == null && passwordErrorText == null) {
          emailErrorText = 'Registration failed';
          passwordErrorText = 'Registration failed';
        }
      });
    } on Exception {
      setState(() {
        emailErrorText = 'Registration failed';
        passwordErrorText = 'Registration failed';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  switchToLoginButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 150.0),
      child: GestureDetector(
        onTap: widget.onTapSwitchToLogin,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already a member?',
              style: TextStyle(color: themeColor3),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              ' Login here!',
              style: TextStyle(fontWeight: FontWeight.bold, color: themeColor3),
            ),
          ],
        ),
      ),
    );
  }

  isMainButton() {
    return authService.isValidEmail(emailTextEditingController.text) &&
        authService.isValidPassword(passwordTextEditingController.text);
  }
}
