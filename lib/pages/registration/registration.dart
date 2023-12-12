import 'dart:convert';

import 'package:challenge/components/list_items/list_item_accept_button.dart';
import 'package:challenge/components/list_items/list_item_email.dart';
import 'package:challenge/json_file_controller/account_controller.dart';
import 'package:challenge/models/account.dart';
import 'package:challenge/providers/design_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../globals.dart';
import 'package:http/http.dart' as http;

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
              changeList: onChangeList,
              textEditingController: textEditingController,
              errorText: errorText,
            ),
            const SizedBox(
              height: 16,
            ),
            ListItemAcceptButton(
                onTapAccept: onTapAccept, isAcceptable: isEmailValid(email)),
            const SizedBox(
              height: 140,
            ),
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/icons/challenge_icon_black.png'),
                fit: BoxFit.contain,
              )),
            ),
            const SizedBox(
              height: 90,
            ),
            Center(
              child: Text("Your Email will be added to the Email list",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 10,
                    fontWeight: FontWeight.w100,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  onChangeList(value) {
    setState(() {});
    return email = value;
  }

  onTapAccept() {
    if (isEmailValid(email)) {
      Account account = Account(email: email);
      accountController.writeFile(context, account);
      sendMail();
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

  // void sendMail() async {
  //   String username = 'main.challenge.app@gmail.com';
  //   String password = 'Die Email fuer dieses Business1';
  //   final smtpServer = gmail(username, password);

  //   final message = Message()
  //     ..from = Address(username, 'Your Name')
  //     ..recipients.add('mynona@tuta.io')
  //     ..subject = email
  //     ..text = 'This is the plain text.\nThis is line 2 of the text part.'
  //     ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

  //   try {
  //     final sendReport = await send(message, smtpServer);
  //     print('Message sent: ' + sendReport.toString());
  //   } on MailerException catch (e) {
  //     print('Message not sent. Error: $e');
  //   }
  // }

  Future sendMail() async {
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    const serviceId = "service_pfaqzo6";
    const templateId = "template_juw1ssh";
    const userId = "kBvyg4bhXZMHM1mfr";
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {'email': email}
        }));
    return response;
  }

  bool isEmailValid(String email) {
    // Define a regular expression pattern for a basic email validation
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');

    // Use the regular expression to check if the email matches the pattern
    return emailRegex.hasMatch(email);
  }
}
