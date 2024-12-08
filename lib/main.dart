import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/providers/notifications_provider.dart';
import 'package:challenge/providers/reports_provider.dart';
import 'package:challenge/providers/search_challenges_provider.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/backend_service.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/services/time_service.dart';
import 'package:challenge/ui/pages/auth/auth_gate_page.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  await BackendService.initializeBackend();
  setupDependencies();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => TabProvider()),
      ChangeNotifierProvider(create: (_) => SearchChallengesProvider()),
      ChangeNotifierProvider(create: (_) => NotificationsProvider()),
      ChangeNotifierProvider(create: (_) => ReportsProvider()),
      ChangeNotifierProvider(
          create: (context) => GroupChallengesProvider(context: context)),
      ChangeNotifierProvider(
          create: (context) => UsersProvider(context: context)),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void dispose() {
    // Remove observer when the widget is disposed
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // This method gets called on lifecycle state changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      TimeService.initializeTrustedTime();
    }
  }

  @override
  void initState() {
    super.initState();
    setOrientationToPortraitUp();
    WidgetsBinding.instance.addObserver(this);
    TimeService.initializeTrustedTime();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Challenge',
        theme: lightTheme,
        home: const AuthGatePage());
  }

  void setOrientationToPortraitUp() {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }
}
