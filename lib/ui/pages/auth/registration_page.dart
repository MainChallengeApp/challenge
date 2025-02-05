import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/services/error_text_service.dart';
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

  String? _tempEmailErrorText;
  String? _tempPasswordErrorText;
  final String _emailErrorTextKey = 'email';
  final String _passwordErrorTextKey = 'password';
  late final Map<String, String?> _errorTexts = {
    _emailErrorTextKey: null,
    _passwordErrorTextKey: null,
  };

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ScaffoldComponent(
      appBar: const AppBarComponent(
        title: 'Registration',
        isFirstPageInRoute: true,
        leadingIcon: LeadingAppIconComponent(),
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
        errorText: _errorTexts[_passwordErrorTextKey],
        onChangeTextField: (_) => setState(() {
          _errorTexts[_passwordErrorTextKey] = null;
          _errorTexts[_emailErrorTextKey] = null;
          _tempEmailErrorText = null;
          _tempPasswordErrorText = null;
        }),
        onSubmitted: (_) => onTapRegister(),
      ),
    );
  }

  SpaceColumnComponent emailInput() {
    return SpaceColumnComponent(
      child: ListItemEmailComponent(
        textEditingController: emailTextEditingController,
        errorText: _tempEmailErrorText,
        onChangeTextField: (_) => setState(() {
          _errorTexts[_emailErrorTextKey] = null;
          _errorTexts[_passwordErrorTextKey] = null;
          _tempEmailErrorText = null;
          _tempPasswordErrorText = null;
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

    emailTextEditingController.text = emailTextEditingController.text.trim();

    if (!authService.isValidEmail(emailTextEditingController.text) ||
        !authService.isValidPassword(passwordTextEditingController.text)) {
      _tempEmailErrorText =
          authService.isValidEmail(emailTextEditingController.text)
              ? null
              : 'Invalid Email';
      _tempPasswordErrorText =
          authService.isValidPassword(passwordTextEditingController.text)
              ? null
              : 'Invalid Password';
      ErrorTextService.showErrorText(
          setState, _errorTexts, _emailErrorTextKey, _tempEmailErrorText);
      ErrorTextService.showErrorText(
          setState, _errorTexts, _passwordErrorTextKey, _tempPasswordErrorText);
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
      _tempEmailErrorText = authService.getEmailErrorMessage(e.code);
      _tempPasswordErrorText = authService.getPasswordErrorMessage(e.code);
      if (_tempEmailErrorText == null && _tempPasswordErrorText == null) {
        _tempEmailErrorText = 'Registration failed';
        _tempPasswordErrorText = 'Registration failed';
      }
    } on Exception {
      _tempEmailErrorText = 'Registration failed';
      _tempPasswordErrorText = 'Registration failed';
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });

        ErrorTextService.showErrorText(
            setState, _errorTexts, _emailErrorTextKey, _tempEmailErrorText);
        ErrorTextService.showErrorText(setState, _errorTexts,
            _passwordErrorTextKey, _tempPasswordErrorText);
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
