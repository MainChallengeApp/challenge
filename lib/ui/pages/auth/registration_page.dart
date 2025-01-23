import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_email_component.dart';
import 'package:challenge/ui/components/list_items/list_item_password_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/leading_app_icon_component.dart';
import 'package:challenge/ui/components/simple_components/app_icon_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/pages/auth/login_or_registration_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  final String initialEmail;
  final void Function(String) onTapSwitchToLogin;

  const RegistrationPage(
      {super.key,
      required this.onTapSwitchToLogin,
      required this.initialEmail});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  AuthService authService = AuthService();
  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);

  late TextEditingController emailTextEditingController =
      TextEditingController(text: widget.initialEmail);
  TextEditingController passwordTextEditingController = TextEditingController();

  String? emailErrorText;
  String? passwordErrorText;

  bool isLoading = false;

  final String _title = 'Registration';

  @override
  Widget build(BuildContext context) {
    return ScaffoldComponent(
      appBar: AppBarComponent(
        title: _title,
        isFirstPageInRoute: true,
        leadingIcon: const LeadingAppIconComponent(),
      ),
      isBottomNavigationVisible: false,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            spacing(),
            emailInput(),
            passwordInput(),
            _space(),
            registerButton(),
            switchToLoginButton(),
          ],
        ),
      ),
    );
  }

  SpaceComponent _space() {
    return SpaceComponent(
      height: LoginOrRegistrationPage.spaceMid,
    );
  }

  SpaceColumnComponent registerButton() {
    return SpaceColumnComponent(
      heightMultiplier: 2,
      child: ListItemButtonComponent(
        onTap: onTapRegister,
        isMainButton: isMainButton(),
        text: 'Register',
        isLoading: isLoading,
      ),
    );
  }

  SpaceColumnComponent passwordInput() {
    return SpaceColumnComponent(
      child: ListItemPasswordComponent(
        textEditingController: passwordTextEditingController,
        errorText: passwordErrorText,
        onChangeTextField: (_) => setState(() {
          emailErrorText = null;
          passwordErrorText = null;
        }),
        onSubmitted: (_) => onTapRegister(),
      ),
    );
  }

  SpaceColumnComponent emailInput() {
    return SpaceColumnComponent(
      child: ListItemEmailComponent(
        textEditingController: emailTextEditingController,
        errorText: emailErrorText,
        onChangeTextField: (_) => setState(() {
          emailErrorText = null;
          passwordErrorText = null;
        }),
      ),
    );
  }

  SpaceComponent spacing() {
    return SpaceComponent(
      height: LoginOrRegistrationPage.spaceTop,
    );
  }

  Container appIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage(
          AppIconComponent.path,
        ),
        fit: BoxFit.contain,
      )),
    );
  }

  onTapRegister() async {
    if (isLoading) {
      return;
    }
    if (!authService.isValidEmail(emailTextEditingController.text)) {
      setState(() {
        emailErrorText = 'Invalid Email';
      });
      return;
    }

    if (!authService.isValidPassword(passwordTextEditingController.text)) {
      setState(() {
        passwordErrorText = 'Invalid Password';
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await authService.registerEmailPassword(
          emailTextEditingController.text, passwordTextEditingController.text);

      await usersProvider.createUser();
    } on FirebaseAuthException catch (e) {
      setState(() {
        emailErrorText = authService.getEmailErrorMessage(e.code);
        passwordErrorText = authService.getPasswordErrorMessage(e.code);
        if (emailErrorText == null && passwordErrorText == null) {
          emailErrorText = 'Registration failed';
          passwordErrorText = 'Registration failed';
        }
      });
    } on Exception {
      setState(() {
        emailErrorText = 'Registration failed';
        passwordErrorText = 'Registration failed';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  switchToLoginButton() {
    return GestureDetector(
      onTap: () => widget.onTapSwitchToLogin(emailTextEditingController.text),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already a member?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            ' Login here!',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  isMainButton() {
    return authService.isValidEmail(emailTextEditingController.text) &&
        authService.isValidPassword(passwordTextEditingController.text);
  }
}
