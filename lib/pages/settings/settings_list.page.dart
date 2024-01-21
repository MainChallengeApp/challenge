import 'package:challenge/components/navigation/app_bar.component.dart';
import 'package:challenge/json_file_controller/account.controller.dart';
import 'package:challenge/providers/design.provider.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/components/list_items/list_item_icon_small.component.dart';
import 'package:challenge/models/challenge.model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:challenge/components/navigation/no_animation_page_route.component.dart';
import 'package:challenge/models/account.model.dart';
import 'package:challenge/pages/subpages/credits/credits.page.dart';

class SettingsListPage extends StatefulWidget {
  const SettingsListPage({super.key, required this.title, this.onPush});
  final String title;
  final ValueChanged<ChallengeModel>? onPush;

  @override
  State<SettingsListPage> createState() => _SettingsListPageState();
}

class _SettingsListPageState extends State<SettingsListPage> {
  late Future<List<ChallengeModel>> challengesFutures;
  AccountModel account = AccountModel(email: '');
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
        appBar: AppBarComponent(
          preTitle: widget.title,
          isFirstPage: true,
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
                  ListItemIconSmallComponent(
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
                  ListItemIconSmallComponent(
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
                  ListItemIconSmallComponent(
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
                  ListItemIconSmallComponent(
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
                ListItemIconSmallComponent(
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
    accountController.writeFile(AccountModel());
    context.read<DesignProvider>().setIsRegistered(false);
  }

  void loadAccount() async {
    account = await accountController.readFile();
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
      NoAnimationPageRouteComponent(
        builder: (context) => CreditsPage(
          preTitle: widget.title,
        ),
      ),
    ).then((_) => setState(() {}));
  }
}
