import 'package:challenge/pages/registration/registration_page.dart';
import 'package:challenge/providers/design_provider.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/services/account_service.dart';
import 'package:flutter/material.dart';
import 'package:challenge/app.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => DesignProvider()),
      ChangeNotifierProvider(create: (_) => TabProvider()),
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
  AccountService accountService = AccountService();

  @override
  void initState() {
    super.initState();
    setOrientationToPortraitUp();
    accountService.loadAccount(context);
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
        home: context.watch<DesignProvider>().isRegistered()
            ? const App()
            : const RegistrationPage());
  }

  void setOrientationToPortraitUp() {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }
}
