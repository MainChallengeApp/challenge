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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder(
          future: isDeviceAppVersionUpToDate(),
          builder: (context, isDeviceAppVersionUpToDate) {
            if (isDeviceAppVersionUpToDate.connectionState ==
                ConnectionState.waiting) {
              return const Center(child: LoadingCircleComponent());
            } else if (isDeviceAppVersionUpToDate.hasData &&
                isDeviceAppVersionUpToDate.data == true) {
              return StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: LoadingCircleComponent());
                  } else if (snapshot.hasData) {
                    return const App();
                  } else {
                    return const LoginOrRegistrationPage();
                  }
                },
              );
            } else {
              return const UpdateAppPage();
            }
          }),
    );
  }

  Future<bool> isDeviceAppVersionUpToDate() async {
    try {
      return await AppVersionService.isDeviceAppVersionUpToDate();
    } on Exception {
      ErrorOccurredDialog.show(
          errorText: 'Connection to backend failed', context: context);
      return false;
    }
  }
}
