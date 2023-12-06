// ignore_for_file: must_be_immutable

import 'package:challenge/json_file_controller/account_controller.dart';
import 'package:challenge/models/account.dart';
import 'package:challenge/pages/registration/registration.dart';
import 'package:challenge/providers/design_provider.dart';
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
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AccountController accountController = AccountController();
  Account account = Account();

  @override
  void initState() {
    super.initState();

    loadAccount();
  }

  Future<void> loadAccount() async {
    // ignore: use_build_context_synchronously
    account = await accountController.readFile(context);
    if (account.email == null || account.email!.isEmpty) {
      // ignore: use_build_context_synchronously
      await accountController.writeFile(context, account);
    } else {
      // ignore: use_build_context_synchronously
      context.read<DesignProvider>().setIsRegistered(true);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Challenge',
        theme: ThemeData(
            pageTransitionsTheme: const PageTransitionsTheme(
                // try to swipe to go back with navigator (doesn't work)
                builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            })),
        home: context.watch<DesignProvider>().isRegistered()
            ? const App()
            : const Registration());
  }
}
