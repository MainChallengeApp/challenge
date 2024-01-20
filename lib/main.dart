// ignore_for_file: must_be_immutable

import 'package:challenge/pages/registration/registration.dart';
import 'package:challenge/providers/design.provider.dart';
import 'package:challenge/services/load_account.service.dart';
import 'package:flutter/material.dart';
import 'package:challenge/app.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => DesignProvider()),
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
  LoadAccountService loadAccountService = LoadAccountService();

  @override
  void initState() {
    super.initState();
    loadAccountService.loadAccount(context);
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
            : const Registration());
  }
}
