import 'package:challenge/firebase_options.dart';
import 'package:challenge/providers/design_provider.dart';
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
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => DesignProvider()),
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
