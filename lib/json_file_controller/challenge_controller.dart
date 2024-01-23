import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:challenge/models/challenge_model.dart';

import 'package:path_provider/path_provider.dart';

class ChallengeController {
  final String filePath = 'home_challenges.json';

  ChallengeController();

  Future<List<ChallengeModel>> readFile(BuildContext context) async {
    try {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final file = File('${documentsDirectory.path}/$filePath');
      final data = await file.readAsString();

      final body = json.decode(data);
      List<ChallengeModel> c = body.map<ChallengeModel>((e) {
        return ChallengeModel.fromJson(e);
      }).toList();
      return c;
    } catch (e) {
      return [];
    }
  }

  Future<void> writeFile(
      BuildContext context, List<ChallengeModel> challenges) async {
    try {
      // Convert the list of Challenge objects to a list of JSON data.
      final jsonData =
          challenges.map((challenge) => challenge.toJson()).toList();

      // Convert the list of JSON data to a JSON string.
      final jsonString = json.encode(jsonData);

      // Get the file path where you want to save the JSON file (e.g., in the app's documents directory).
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final file = File('${documentsDirectory.path}/$filePath');

      // Write the JSON string to the file.
      await file.writeAsString(jsonString);

      // You can display a success message or handle any other logic here.
    } catch (e) {
      print("Error writing JSON file: $e");
      // Handle the error, e.g., show an error message to the user.
    }
  }
}
