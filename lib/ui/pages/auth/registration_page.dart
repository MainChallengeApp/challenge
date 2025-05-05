import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/services/error_text_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_email_component.dart';
import 'package:challenge/ui/components/list_items/list_item_password_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/leading_app_icon_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/pages/auth/login_or_registration_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  final _authService = AuthService();
  final _usersProvider = getIt<UsersProvider>();

  late final _emailTextEditingController =
      TextEditingController(text: widget.initialEmail);
  final _passwordTextEditingController = TextEditingController();

  String? _tempEmailErrorText;
  String? _tempPasswordErrorText;
  final String _emailErrorTextKey = 'email';
  final String _passwordErrorTextKey = 'password';
  late final Map<String, String?> _errorTexts = {
    _emailErrorTextKey: null,
    _passwordErrorTextKey: null,
  };

  bool _isLoading = false;

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
            _spacing(),
            _emailInput(),
            _passwordInput(),
            _space(),
            _registerButton(),
            _switchToLoginButton(),
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

  SpaceColumnComponent _registerButton() {
    return SpaceColumnComponent(
      heightMultiplier: 2,
      child: ListItemButtonComponent(
        onTap: _onTapRegister,
        isMainButton: _isMainButton(),
        text: 'Register',
        isLoading: _isLoading,
      ),
    );
  }

  SpaceColumnComponent _passwordInput() {
    return SpaceColumnComponent(
      child: ListItemPasswordComponent(
        textEditingController: _passwordTextEditingController,
        errorText: _errorTexts[_passwordErrorTextKey],
        onChangeTextField: (_) => setState(() {
          _errorTexts[_passwordErrorTextKey] = null;
          _errorTexts[_emailErrorTextKey] = null;
          _tempEmailErrorText = null;
          _tempPasswordErrorText = null;
        }),
        onSubmitted: (_) => _onTapRegister(),
      ),
    );
  }

  SpaceColumnComponent _emailInput() {
    return SpaceColumnComponent(
      child: ListItemEmailComponent(
        textEditingController: _emailTextEditingController,
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

  SpaceComponent _spacing() {
    return SpaceComponent(
      height: LoginOrRegistrationPage.spaceTop,
    );
  }

  _onTapRegister() async {
    if (_isLoading) {
      return;
    }

    _emailTextEditingController.text = _emailTextEditingController.text.trim();

    if (!_authService.isValidEmail(_emailTextEditingController.text) ||
        !_authService.isValidPassword(_passwordTextEditingController.text)) {
      _tempEmailErrorText =
          _authService.isValidEmail(_emailTextEditingController.text)
              ? null
              : 'Invalid Email';
      _tempPasswordErrorText =
          _authService.isValidPassword(_passwordTextEditingController.text)
              ? null
              : 'Invalid Password';
      ErrorTextService.showErrorText(
          setState, _errorTexts, _emailErrorTextKey, _tempEmailErrorText);
      ErrorTextService.showErrorText(
          setState, _errorTexts, _passwordErrorTextKey, _tempPasswordErrorText);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.registerEmailPassword(_emailTextEditingController.text,
          _passwordTextEditingController.text);

      await _usersProvider.createUser();
    } on FirebaseAuthException catch (e) {
      _tempEmailErrorText = _authService.getEmailErrorMessage(e.code);
      _tempPasswordErrorText = _authService.getPasswordErrorMessage(e.code);
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
          _isLoading = false;
        });

        ErrorTextService.showErrorText(
            setState, _errorTexts, _emailErrorTextKey, _tempEmailErrorText);
        ErrorTextService.showErrorText(setState, _errorTexts,
            _passwordErrorTextKey, _tempPasswordErrorText);
      }
    }
  }

  _switchToLoginButton() {
    return GestureDetector(
      onTap: () => widget.onTapSwitchToLogin(_emailTextEditingController.text),
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

  _isMainButton() {
    return _authService.isValidEmail(_emailTextEditingController.text) &&
        _authService.isValidPassword(_passwordTextEditingController.text);
  }
}
