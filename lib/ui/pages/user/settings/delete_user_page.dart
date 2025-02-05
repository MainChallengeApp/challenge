import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/services/error_text_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_info_component.dart';
import 'package:challenge/ui/components/list_items/list_item_password_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteUserPage extends StatefulWidget {
  const DeleteUserPage({super.key});

  @override
  State<DeleteUserPage> createState() => _DeleteUserPageState();
}

class _DeleteUserPageState extends State<DeleteUserPage> {
  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);

  final String titleText = 'Delete User';

  final TextEditingController passwordTextEditingController =
      TextEditingController();

  String? _tempPasswordErrorText;
  final String _passwordErrorTextKey = 'password';
  late final Map<String, String?> _errorTexts = {
    _passwordErrorTextKey: null,
  };

  final authService = AuthService();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ScaffoldComponent(
        appBar: AppBarComponent(title: titleText),
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
                          textEditingController: passwordTextEditingController,
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
            SpaceColumnComponent(
              height: BottomNavigationComponent.standardMargin,
              child: Row(
                children: [
                  const SpaceComponent(
                    width: ListItemContainerComponent.standardMargin,
                  ),
                  Expanded(
                    child: ListItemButtonComponent(
                        margin: const EdgeInsets.all(0),
                        onTap: _onTapCancel,
                        isMainButton: false,
                        text: 'Cancel'),
                  ),
                  const SpaceComponent(),
                  Expanded(
                    child: ListItemButtonComponent(
                        margin: const EdgeInsets.all(0),
                        onTap: _onTapDeleteUser,
                        text: 'Delete',
                        isLoading: isLoading),
                  ),
                  const SpaceComponent(
                    width: ListItemContainerComponent.standardMargin,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTapDeleteUser() async {
    if (isLoading) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await authService.loginEmailPassword(
          authService.getCurrentUser()?.email ?? '',
          passwordTextEditingController.text);
      await authService.deleteUser();
      usersProvider.resetLocalUser();
    } on FirebaseAuthException catch (e) {
      _tempPasswordErrorText = authService.getPasswordErrorMessage(e.code);
      _tempPasswordErrorText ??= 'Deletion failed';
      setState(() {});
    } on Exception {
      setState(() {
        _tempPasswordErrorText = 'Deletion failed';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
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
