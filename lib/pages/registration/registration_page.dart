import 'package:challenge/components/list_items/list_item_accept_button_component.dart';
import 'package:challenge/components/list_items/list_item_email_component.dart';
import 'package:challenge/components/navigation/app_bar_component.dart';
import 'package:challenge/components/simple_components/space_component.dart';
import 'package:challenge/services/account_service.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  String email = '';
  AccountService accountService = AccountService();
  TextEditingController textEditingController = TextEditingController();
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppBarComponent(
        preTitle: 'Registration',
        isFirstPageInRoute: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SpaceComponent(
              height: 200,
            ),
            ListItemEmailComponent(
              onChangeTextField: onChangeTextField,
              textEditingController: textEditingController,
              errorText: errorText,
            ),
            const SpaceComponent(),
            ListItemAcceptButtonComponent(
                onTapAccept: onTapAccept, isAcceptable: email.isNotEmpty),
            const SpaceComponent(),
            appIcon(),
          ],
        ),
      ),
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

  onChangeTextField(value) {
    setState(() {
      errorText = null;
    });
    return email = value;
  }

  onTapAccept() {
    if (email.isNotEmpty) {
      accountService.registerAcount(email: email, context: context);
    } else {
      setState(() {
        errorText = 'add a Username';
      });
    }
  }

  // bool isEmailValid(String email) {
  //   // Define a regular expression pattern for a basic email validation
  //   final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');

  //   // Use the regular expression to check if the email matches the pattern
  //   return emailRegex.hasMatch(email);
  // }
}
