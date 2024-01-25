import 'package:challenge/json_file_controller/account_controller.dart';
import 'package:challenge/models/account_model.dart';
import 'package:challenge/providers/design_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountService {
  AccountController accountController = AccountController();
  AccountModel account = AccountModel();

  Future<void> loadAccount(BuildContext context) async {
    // ignore: use_build_context_synchronously
    account = await accountController.readFile();
    if (account.username == null || account.username!.isEmpty) {
      // ignore: use_build_context_synchronously
      await accountController.writeFile(account);
    } else {
      // ignore: use_build_context_synchronously
      context.read<DesignProvider>().setIsRegistered(true);
    }
  }

  bool registerAccount({required String username}) {
    if (AccountModel.isValidUsername(username)) {
      AccountModel account = AccountModel(username: username);
      accountController.writeFile(account);
      return true;
    }
    return false;
  }
}
