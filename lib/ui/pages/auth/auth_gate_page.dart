import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/services/app_version_service.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/loading_circle/loading_circle_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/pages/app.dart';
import 'package:challenge/ui/pages/auth/login_or_registration_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGatePage extends StatelessWidget {
  const AuthGatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder(
          future: AppVersionService.isDeviceAppVersionUpToDate(),
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
              return updateTheAppMessage(context);
            }
          }),
    );
  }

  Scaffold updateTheAppMessage(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomContainerComponent(
          margin: const EdgeInsets.all(40),
          padding: const EdgeInsets.all(20),
          borderRadius: CardComponent.standardBorderRadius,
          borderWidth: 2,
          isHeightDynamic: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SpaceColumnComponent(child: Icon(IconEnum.info.icon, size: 50)),
              SpaceColumnComponent(
                child: Text(
                  'Due to major updates you need to update the app to the latest version to access it.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
