import 'package:challenge/json_file_controller/account_controller.dart';
import 'package:challenge/providers/design_provider.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/components/list_items/list_item_icon_small.dart';
import 'package:challenge/models/challenge.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/navigation/no_animation_page_route.dart';
import '../../models/account.dart';
import '../credits/credits.dart';

class SettingsList extends StatefulWidget {
  const SettingsList({super.key, required this.title, this.onPush});
  final String title;
  final ValueChanged<Challenge>? onPush;

  @override
  State<SettingsList> createState() => _SettingsListState();
}

class _SettingsListState extends State<SettingsList> {
  late Future<List<Challenge>> challengesFutures;
  Account account = Account(email: '');
  AccountController accountController = AccountController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadAccount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: const Icon(
            Icons.chevron_left,
            color: Colors.transparent,
          ),
          foregroundColor: Colors.black,
          titleSpacing: 0,
          title: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(right: 24),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  widget.title,
                  style: const TextStyle(
                      color: Colors.black, fontSize: appBarFontSize),
                ),
              ),
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: Container(
          color: Colors.white,
          child: _buildList(),
        ));
  }

  Widget _buildList() {
    int itemCount = 4;
    return RawScrollbar(
      controller: scrollController,
      radius: const Radius.circular(4),
      thumbColor: themeColor3,
      padding: const EdgeInsets.only(right: 4),
      child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          itemCount: itemCount,
          itemBuilder: (BuildContext content, int index) {
            if (index == 0) {
              return Column(
                children: [
                  ListItemIconSmall(
                      onTap: () {},
                      icon: Icons.person_outlined,
                      title: account.email!),
                  const SizedBox(
                    height: 17,
                  )
                ],
              );
            }

            if (index == 1) {
              return Column(
                children: [
                  ListItemIconSmall(
                      onTap: onTapFeedback,
                      icon: Icons.feedback_outlined,
                      title: 'Feedback'),
                  const SizedBox(
                    height: 17,
                  )
                ],
              );
            }

            if (index == 2) {
              return Column(
                children: [
                  ListItemIconSmall(
                      onTap: onTapCredits,
                      icon: Icons.handshake_outlined,
                      title: 'Credits'),
                  const SizedBox(
                    height: 17,
                  )
                ],
              );
            }

            if (index == itemCount - 1) {
              return Column(
                children: [
                  ListItemIconSmall(
                      onTap: onTapLogout,
                      icon: Icons.logout_rounded,
                      title: 'Log out'),
                  const SizedBox(
                    height: 17,
                  )
                ],
              );
            }

            return Column(
              children: [
                ListItemIconSmall(
                    onTap: () {}, icon: Icons.settings, title: 'settings'),
                const SizedBox(
                  height: 17,
                )
              ],
            );
          }),
    );
  }

  onTapLogout() {
    accountController.writeFile(context, Account());
    context.read<DesignProvider>().setIsRegistered(false);
  }

  void loadAccount() async {
    account = await accountController.readFile(context);
    setState(() {});
  }

  onTapFeedback() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'main.challenge.app@gmail.com',
      queryParameters: {
        'subject': 'Feedback',
        // You can add other parameters like 'body', 'cc', 'bcc', etc.
      },
    );

    // ignore: deprecated_member_use
    if (await canLaunch(emailLaunchUri.toString())) {
      // ignore: deprecated_member_use
      await launch(emailLaunchUri.toString());
    } else {
      throw 'Could not launch $emailLaunchUri';
    }
  }

  onTapCredits() {
    Navigator.push(
      context,
      NoAnimationPageRoute(
        builder: (context) => Credits(
          preTitle: widget.title,
        ),
      ),
    ).then((_) => setState(() {}));
  }
}
