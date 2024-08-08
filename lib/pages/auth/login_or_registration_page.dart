import 'package:challenge/pages/auth/login_page.dart';
import 'package:challenge/pages/auth/registration_page.dart';
import 'package:flutter/material.dart';

class LoginOrRegistrationPage extends StatefulWidget {
  const LoginOrRegistrationPage({super.key});

  @override
  State<LoginOrRegistrationPage> createState() =>
      _LoginOrRegistrationPageState();
}

class _LoginOrRegistrationPageState extends State<LoginOrRegistrationPage> {
  bool isLoginVisible = true;

  @override
  Widget build(BuildContext context) {
    return isLoginVisible
        ? LoginPage(
            onTapSwitchToRegistration: onTapSwitchToLoginOrRegistration,
          )
        : RegistrationPage(
            onTapSwitchToLogin: onTapSwitchToLoginOrRegistration);
  }

  void onTapSwitchToLoginOrRegistration() {
    setState(() {
      isLoginVisible = !isLoginVisible;
    });
  }
}
