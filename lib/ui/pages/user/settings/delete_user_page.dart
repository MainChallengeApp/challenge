import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/services/error_text_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_info_component.dart';
import 'package:challenge/ui/components/list_items/list_item_password_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/simple_components/bottom_buttons_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeleteUserPage extends StatefulWidget {
  const DeleteUserPage({super.key});

  @override
  State<DeleteUserPage> createState() => _DeleteUserPageState();
}

class _DeleteUserPageState extends State<DeleteUserPage> {
  final _usersProvider = getIt<UsersProvider>();

  final _passwordTextEditingController = TextEditingController();

  String? _tempPasswordErrorText;
  final String _passwordErrorTextKey = 'password';
  late final Map<String, String?> _errorTexts = {
    _passwordErrorTextKey: null,
  };

  final _authService = AuthService();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ScaffoldComponent(
        appBar: const AppBarComponent(title: 'Delete User'),
        isBottomNavigationVisible: false,
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SpaceColumnComponent(
                        child: ListItemInfoComponent(
                            title: 'Delete User',
                            text:
                                'This action will delete all your data and cannot be undone.\n\nEnter your password to delete your user.')),
                    SpaceColumnComponent(
                      heightMultiplier: 2,
                      child: ListItemPasswordComponent(
                          textEditingController: _passwordTextEditingController,
                          errorText: _errorTexts[_passwordErrorTextKey],
                          onChangeTextField: (_) => setState(() {
                                _errorTexts[_passwordErrorTextKey] = null;
                                _tempPasswordErrorText = null;
                              })),
                    ),
                  ],
                ),
              ),
            ),
            _actionButtons(),
          ],
        ),
      ),
    );
  }

  _actionButtons() {
    return BottomButtonsComponent(buttons: [
      ListItemButtonComponent(
          margin: EdgeInsets.zero,
          onTap: _onTapCancel,
          isMainButton: false,
          text: 'Cancel'),
      ListItemButtonComponent(
          margin: EdgeInsets.zero,
          onTap: _onTapDeleteUser,
          text: 'Delete',
          isLoading: _isLoading),
    ]);
  }

  void _onTapDeleteUser() async {
    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.loginEmailPassword(
          _authService.getCurrentUser()?.email ?? '',
          _passwordTextEditingController.text);
      await _authService.deleteUser();
      _usersProvider.resetLocalUser();
    } on FirebaseAuthException catch (e) {
      _tempPasswordErrorText = _authService.getPasswordErrorMessage(e.code);
      _tempPasswordErrorText ??= 'Deletion failed';
      setState(() {});
    } on Exception {
      setState(() {
        _tempPasswordErrorText = 'Deletion failed';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ErrorTextService.showErrorText(setState, _errorTexts,
            _passwordErrorTextKey, _tempPasswordErrorText);
      }
    }
  }

  void _onTapCancel() {
    Navigator.pop(context);
  }
}
