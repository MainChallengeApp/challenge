import 'package:challenge/json_file_controller/account_controller.dart';
import 'package:challenge/models/account.dart';
import 'package:challenge/providers/design_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadAccountService {
  AccountController accountController = AccountController();
  Account account = Account();

  Future<void> loadAccount(BuildContext context) async {
    // ignore: use_build_context_synchronously
    account = await accountController.readFile();
    if (account.email == null || account.email!.isEmpty) {
      // ignore: use_build_context_synchronously
      await accountController.writeFile(account);
    } else {
      // ignore: use_build_context_synchronously
      context.read<DesignProvider>().setIsRegistered(true);
    }
  }
}
