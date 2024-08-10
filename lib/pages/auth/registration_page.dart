import 'package:challenge/components/list_items/list_item_button_component.dart';
import 'package:challenge/components/list_items/list_item_email_component.dart';
import 'package:challenge/components/list_items/list_item_password_component.dart';
import 'package:challenge/components/navigation/app_bar_component.dart';
import 'package:challenge/components/navigation/leading_app_icon_component.dart';
import 'package:challenge/components/simple_components/space_column_component.dart';
import 'package:challenge/components/simple_components/space_component.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/account_model.dart';
import 'package:challenge/providers/design_provider.dart';
import 'package:challenge/services/account_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key, required this.onTapSwitchToLogin});

  final void Function() onTapSwitchToLogin;

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  AccountService accountService = AccountService();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  String? emailErrorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppBarComponent(
        preTitle: 'Register',
        isFirstPageInRoute: true,
        leadingIcon: LeadingAppIconComponent(),
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
        onTap: onTapAccept,
        isMainButton:
            AccountModel.isValidUsername(emailTextEditingController.text),
        text: 'Register',
      ),
    );
  }

  SpaceColumnComponent passwordInput() {
    return SpaceColumnComponent(
      heightMultiplier: 2,
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

  onTapAccept() {
    if (accountService.registerAccount(
        username: emailTextEditingController.text)) {
      context.read<DesignProvider>().setIsRegistered(true);
    } else {
      setState(() {
        emailErrorText = 'add an Email';
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
