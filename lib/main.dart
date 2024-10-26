import 'package:challenge/providers/notifications_provider.dart';
import 'package:challenge/providers/reports_provider.dart';
import 'package:challenge/providers/search_challenges_provider.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/providers/user_challenges_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/backend_service.dart';
import 'package:challenge/ui/pages/auth/auth_gate_page.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
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
      ChangeNotifierProvider(create: (_) => NotificationsProvider()),
      ChangeNotifierProvider(create: (_) => ReportsProvider()),
      ChangeNotifierProxyProvider<NotificationsProvider, UsersProvider>(
        create: (context) => UsersProvider(
          notificationsProvider:
              Provider.of<NotificationsProvider>(context, listen: false),
        ),
        update: (context, notificationsProvider, previousUsersProvider) {
          return previousUsersProvider ??
              UsersProvider(notificationsProvider: notificationsProvider);
        },
      ),
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
