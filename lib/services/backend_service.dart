import 'package:challenge/dotenv.dart';
import 'package:challenge/enums/environment_enum.dart';
import 'package:challenge/environments/firebase_options_dev.dart' as dev;
import 'package:challenge/environments/firebase_options_prod.dart' as prod;
import 'package:challenge/environments/firebase_options_test.dart' as test;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class BackendService {
  static Future<void> initializeBackend() async {
    if (Firebase.apps.isNotEmpty) {
      return;
    }

    WidgetsFlutterBinding.ensureInitialized();
    final firebaseDev = dev.DefaultFirebaseOptions.currentPlatform;
    final firebaseTest = test.DefaultFirebaseOptions.currentPlatform;
    final firebaseProd = prod.DefaultFirebaseOptions.currentPlatform;

    Dotenv dotenv = await Dotenv.create();
    var environment = EnvironmentEnum.fromString(dotenv.environment);

    FirebaseOptions environmentOptions;
    switch (environment) {
      case EnvironmentEnum.dev:
        environmentOptions = firebaseDev;
        break;
      case EnvironmentEnum.test:
        environmentOptions = firebaseTest;
        break;
      case EnvironmentEnum.prod:
        environmentOptions = firebaseProd;
        break;
      default:
        environmentOptions = firebaseDev;
    }
    await Firebase.initializeApp(
        options: environmentOptions, name: 'challenge-${environment.string}');
  }
}
