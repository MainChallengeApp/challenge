import 'package:challenge/components/list_items/list_item_accept_button.dart';
import 'package:challenge/components/list_items/list_item_email.dart';
import 'package:challenge/json_file_controller/account_controller.dart';
import 'package:challenge/models/account.dart';
import 'package:challenge/providers/design_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../globals.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String email = '';
  AccountController accountController = AccountController();
  TextEditingController textEditingController = TextEditingController();
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: const Icon(
          Icons.chevron_left,
          color: Colors.transparent,
        ),
        foregroundColor: Colors.black,
        titleSpacing: 0,
        title: const Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(right: 24),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                'Registration',
                style: TextStyle(color: Colors.black, fontSize: appBarFontSize),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 200,
            ),
            ListItemEmail(
              changeList: (value) => email = value,
              textEditingController: textEditingController,
              errorText: errorText,
            ),
            const SizedBox(
              height: 16,
            ),
            ListItemAcceptButton(
              onTapAccept: onTapAccept,
            ),
            const SizedBox(
              height: 230,
            ),
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/icons/challenge_icon_black.png'),
                fit: BoxFit.contain,
              )),
            )
          ],
        ),
      ),
    );
  }

  onTapAccept() {
    if (isEmailValid(email)) {
      Account account = Account(email: email);
      accountController.writeFile(context, account);
      setState(() {
        errorText = null;
        context.read<DesignProvider>().setIsRegistered(true);
      });
    } else {
      setState(() {
        errorText = 'thats not an email...';
      });
    }
  }

  bool isEmailValid(String email) {
    // Define a regular expression pattern for a basic email validation
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');

    // Use the regular expression to check if the email matches the pattern
    return emailRegex.hasMatch(email);
  }
}
