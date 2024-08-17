import 'package:challenge/providers/search_challenges_provider.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/providers/user_challenges_provider.dart';
import 'package:challenge/services/backend_service.dart';
import 'package:challenge/ui/pages/auth/auth_gate_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  await BackendService.initializeBackend();

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
