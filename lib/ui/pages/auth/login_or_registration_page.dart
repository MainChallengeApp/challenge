import 'package:challenge/ui/pages/auth/login_page.dart';
import 'package:challenge/ui/pages/auth/registration_page.dart';
import 'package:flutter/material.dart';

class LoginOrRegistrationPage extends StatefulWidget {
  static double spaceTop = 50;
  static double spaceMid = 60;

  const LoginOrRegistrationPage({super.key});

  @override
  State<LoginOrRegistrationPage> createState() =>
      _LoginOrRegistrationPageState();
}

class _LoginOrRegistrationPageState extends State<LoginOrRegistrationPage> {
  bool isLoginPageVisible = true;
  String email = '';

  @override
  Widget build(BuildContext context) {
    return isLoginPageVisible
        ? LoginPage(
            initialEmail: email,
            onTapSwitchToRegistration: onTapSwitchToLoginOrRegistration,
          )
        : RegistrationPage(
            initialEmail: email,
            onTapSwitchToLogin: onTapSwitchToLoginOrRegistration);
  }

  void onTapSwitchToLoginOrRegistration(String email) {
    setState(() {
      this.email = email;
      isLoginPageVisible = !isLoginPageVisible;
    });
  }
}
