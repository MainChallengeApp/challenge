import 'package:challenge/services/app_version_service.dart';
import 'package:challenge/ui/components/loading_circle/loading_circle_component.dart';
import 'package:challenge/ui/dialogs/error_occurred_dialog.dart';
import 'package:challenge/ui/pages/app.dart';
import 'package:challenge/ui/pages/auth/login_or_registration_page.dart';
import 'package:challenge/ui/pages/auth/update_app_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGatePage extends StatefulWidget {
  const AuthGatePage({super.key});

  @override
  State<AuthGatePage> createState() => _AuthGatePageState();
}

class _AuthGatePageState extends State<AuthGatePage> {
  final _app = const App();
  bool _isVersionChecked = false;
  bool _isVersionUpToDate = false;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _checkVersion();
    _listenToAuthChanges();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVersionChecked) {
      return const Center(child: LoadingCircleComponent());
    }

    if (!_isVersionUpToDate) {
      return const UpdateAppPage();
    }

    if (_currentUser == null) {
      return const LoginOrRegistrationPage();
    }

    return _app;
  }

  void _checkVersion() async {
    try {
      final isUpToDate = await AppVersionService.isDeviceAppVersionUpToDate();
      if (mounted) {
        setState(() {
          _isVersionChecked = true;
          _isVersionUpToDate = isUpToDate;
        });
      }
    } on Exception {
      if (mounted) {
        ErrorOccurredDialog.show(
            errorText: 'Connection to backend failed', context: context);
        setState(() {
          _isVersionChecked = true;
          _isVersionUpToDate = false;
        });
      }
    }
  }

  void _listenToAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        setState(() {
          _currentUser = user;
        });
      }
    });
  }
}
