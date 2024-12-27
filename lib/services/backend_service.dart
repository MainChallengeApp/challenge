import 'package:challenge/enums/environment_enum.dart';
import 'package:challenge/environments/firebase_options_dev.dart' as dev;
import 'package:challenge/environments/firebase_options_prod.dart' as prod;
import 'package:challenge/environments/firebase_options_test.dart' as test;
import 'package:challenge/services/env_vars_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BackendService {
  static Future<void> initializeBackend() async {
    if (Firebase.apps.isNotEmpty) {
      await Firebase.app().delete(); // Clear existing instance
    }

    WidgetsFlutterBinding.ensureInitialized();
    final firebaseDev = dev.DefaultFirebaseOptions.currentPlatform;
    final firebaseTest = test.DefaultFirebaseOptions.currentPlatform;
    final firebaseProd = prod.DefaultFirebaseOptions.currentPlatform;

    EnvVarsService dotenv = await EnvVarsService.create();
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

    // await _setupEmulators(); // comment with to use real device
    // https://console.firebase.google.com/v1/r/project/challenge-dev-sdgi/firestore/indexes?create_composite=Clhwcm9qZWN0cy9jaGFsbGVuZ2UtZGV2LXNkZ2kvZGF0YWJhc2VzLyhkZWZhdWx0KS9jb2xsZWN0aW9uR3JvdXBzL25vdGlmaWNhdGlvbnMvaW5kZXhlcy9fEAEaCgoGdXNlcklkEAEaDQoJY3JlYXRlZEF0EAIaDAoIX19uYW1lX18QAg
  }

  static Future<void> _setupEmulators() async {
    if (kDebugMode) {
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 9151);
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
      await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
      // FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
    }
  }
}
