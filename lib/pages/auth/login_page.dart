import 'package:challenge/components/list_items/list_item_button_component.dart';
import 'package:challenge/components/list_items/list_item_email_component.dart';
import 'package:challenge/components/list_items/list_item_password_component.dart';
import 'package:challenge/components/navigation/app_bar_component.dart';
import 'package:challenge/components/simple_components/space_column_component.dart';
import 'package:challenge/components/simple_components/space_component.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/account_model.dart';
import 'package:challenge/services/account_service.dart';
import 'package:challenge/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onTapSwitchToRegistration});

  final void Function() onTapSwitchToRegistration;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username = '';
  AccountService accountService = AccountService();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  AuthService authService = AuthService();

  String? emailErrorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppBarComponent(
        preTitle: 'Login',
        isFirstPageInRoute: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            spacing(),
            appIcon(),
            spacing(),
            emailInput(),
            passwordInput(),
            forGotPasswordButton(),
            acceptButton(),
            switchToRegistrationButton(),
          ],
        ),
      ),
    );
  }

  SpaceColumnComponent acceptButton() {
    return SpaceColumnComponent(
      heightMultiplier: 4,
      child: ListItemButtonComponent(
        onTap: onTapLogin,
        isMainButton: AccountModel.isValidUsername(username),
        text: 'Login',
      ),
    );
  }

  SpaceColumnComponent passwordInput() {
    return SpaceColumnComponent(
      child: ListItemPasswordComponent(
        textEditingController: passwordTextEditingController,
      ),
    );
  }

  SpaceColumnComponent emailInput() {
    return SpaceColumnComponent(
      child: ListItemEmailComponent(
        textEditingController: emailTextEditingController,
        errorText: emailErrorText,
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

  onTapLogin() async {
    try {
      await authService.loginEmailPassword(
          emailTextEditingController.text, passwordTextEditingController.text);
    } on Exception catch (e) {
      print(e);
    }
  }

  switchToRegistrationButton() {
    return GestureDetector(
      onTap: widget.onTapSwitchToRegistration,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Not a member yet?',
            style: TextStyle(color: themeColor3),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            ' Register now!',
            style: TextStyle(fontWeight: FontWeight.bold, color: themeColor3),
          ),
        ],
      ),
    );
  }

  forGotPasswordButton() {
    return SpaceColumnComponent(
      heightMultiplier: 2,
      child: GestureDetector(
        onTap: () {
          print('Forgot password');
        },
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Text(
              'Forgot password?',
              style: TextStyle(color: themeColor3),
            ),
          ),
        ),
      ),
    );
  }

  // bool isEmailValid(String email) {
  //   // Define a regular expression pattern for a basic email validation
  //   final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');

  //   // Use the regular expression to check if the email matches the pattern
  //   return emailRegex.hasMatch(email);
  // }
}
