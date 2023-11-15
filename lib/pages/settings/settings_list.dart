import 'package:challenge/json_file_controller/account_controller.dart';
import 'package:challenge/providers/design_provider.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/components/list_items/list_item_icon_small.dart';
import 'package:challenge/models/challenge.dart';
import 'package:provider/provider.dart';

import '../../models/account.dart';

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
    int itemCount = 2;
    return ListView.separated(
        itemCount: itemCount + 1, // +1 for extra separator at the end
        separatorBuilder: (context, index) => const SizedBox(
              height: 17,
            ),
        itemBuilder: (BuildContext content, int index) {
          if (index == 0) {
            return ListItemIconSmall(
                onTap: () {}, icon: Icons.person, title: account.email!);
          }

          if (index == itemCount - 1) {
            return ListItemIconSmall(
                onTap: onTapLogout, icon: Icons.logout, title: 'log out');
          }

          if (index == itemCount) {
            return Container(); // for separator at the end
          }

          return ListItemIconSmall(
              onTap: () {}, icon: Icons.settings, title: 'settings');
        });
  }

  onTapLogout() {
    accountController.writeFile(context, Account());
    context.read<DesignProvider>().setIsRegistered(false);
  }

  void loadAccount() async {
    account = await accountController.readFile(context);
    setState(() {});
  }
}
