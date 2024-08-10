import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:challenge/models/challenge/account_model.dart';
import 'package:path_provider/path_provider.dart';

class AccountController {
  final String filePath = 'account.json';

  AccountController();

  Future<AccountModel> readFile() async {
    try {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final file = File('${documentsDirectory.path}/$filePath');
      final data = await file.readAsString();

      final jsonData = json.decode(data);
      return AccountModel.fromDoc(
          jsonData); // body.map<Account>(Account.fromJson);
    } catch (e) {
      return AccountModel(username: '');
    }
  }

  Future<void> writeFile(AccountModel account) async {
    try {
      // Convert the list of Challenge objects to a list of JSON data.
      final jsonData = account.toDoc();

      // Convert the list of JSON data to a JSON string.
      final jsonString = json.encode(jsonData);

      // Get the file path where you want to save the JSON file (e.g., in the app's documents directory).
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final file = File('${documentsDirectory.path}/$filePath');

      // Write the JSON string to the file.
      await file.writeAsString(jsonString);

      // You can display a success message or handle any other logic here.
    } catch (e) {
      log('Error writing JSON file: $e');
      // Handle the error, e.g., show an error message to the user.
    }
  }
}
