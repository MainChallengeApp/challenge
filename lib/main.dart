import 'package:challenge/enums/environment_enum.dart';
import 'package:challenge/environments/firebase_options_dev.dart' as dev;
import 'package:challenge/environments/firebase_options_prod.dart' as prod;
import 'package:challenge/environments/firebase_options_test.dart' as test;
import 'package:challenge/providers/search_challenges_provider.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/providers/user_challenges_provider.dart';
import 'package:challenge/ui/pages/auth/auth_gate_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final firebaseDev = dev.DefaultFirebaseOptions.currentPlatform;
  final firebaseTest = test.DefaultFirebaseOptions.currentPlatform;
  final firebaseProd = prod.DefaultFirebaseOptions.currentPlatform;

  var environment =
      EnvironmentEnum.fromString(const String.fromEnvironment('ENVIRONMENT'));

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

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => TabProvider()),
      ChangeNotifierProvider(create: (_) => SearchChallengesProvider()),
      ChangeNotifierProvider(create: (_) => UserChallengesProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    setOrientationToPortraitUp();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Challenge',
        theme: ThemeData(
            pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        })),
        home: const AuthGatePage());
  }

  void setOrientationToPortraitUp() {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }
}
