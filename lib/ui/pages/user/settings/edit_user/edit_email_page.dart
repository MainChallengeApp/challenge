import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_email_component.dart';
import 'package:challenge/ui/components/list_items/list_item_password_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/simple_components/bottom_buttons_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/icon_container_in_list_item_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditEmailPage extends StatefulWidget {
  const EditEmailPage({
    super.key,
  });

  @override
  State<EditEmailPage> createState() => _EditEmailPageState();
}

class _EditEmailPageState extends State<EditEmailPage> {
  bool _isLoading = false;

  final _authService = AuthService();

  final _passwordTextEditingController = TextEditingController();
  final _newEmailTextEditingController = TextEditingController();

  String? _passwordError;
  String? _newEmailError;

  bool _isEmailSentMessageVisible = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ScaffoldComponent(
        appBar: const AppBarComponent(title: 'Edit Email'),
        isBottomNavigationVisible: false,
        resizeToAvoidBottomInset: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SpaceColumnComponent(
                      child: ListItemEmailComponent(
                          textEditingController: _newEmailTextEditingController,
                          errorText: _newEmailError,
                          lableText: 'New Email',
                          autoFocus: true,
                          onChangeTextField: (value) {
                            setState(() {
                              _newEmailError = null;
                            });
                          }),
                    ),
                    SpaceColumnComponent(
                      heightMultiplier: 2,
                      child: ListItemPasswordComponent(
                          textEditingController: _passwordTextEditingController,
                          errorText: _passwordError,
                          onChangeTextField: (value) {
                            setState(() {
                              _passwordError = null;
                            });
                          }),
                    ),
                    Visibility(
                        visible: _isEmailSentMessageVisible,
                        child: SpaceColumnComponent(
                            child: CustomContainerComponent(
                          padding: const EdgeInsets.all(
                              ListItemContainerComponent.standardPadding),
                          isHeightDynamic: true,
                          borderRadius: CardComponent.standardBorderRadius,
                          margin: const EdgeInsets.symmetric(
                              horizontal: CardComponent.standardSideMargin),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconContainerInListItemComponent(
                                  icon: IconEnum.info.icon),
                              const Expanded(
                                child: Text(
                                  'Click the link in the email we sent you to confirm your new email address.',
                                  maxLines: null,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              )
                            ],
                          ),
                        )))
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
        onTap: _onTapCancel,
        text: 'Cancel',
        isMainButton: false,
        margin: EdgeInsets.zero,
      ),
      ListItemButtonComponent(
        onTap: _onTapSendLink,
        text: 'Send Link',
        isLoading: _isLoading,
        isMainButton:
            _authService.isValidPassword(_passwordTextEditingController.text) &&
                _authService.isValidEmail(_newEmailTextEditingController.text),
        margin: EdgeInsets.zero,
      ),
    ]);
  }

  void _onTapSendLink() async {
    if (_isLoading) {
      return;
    }

    if (!_authService.isValidPassword(_passwordTextEditingController.text) ||
        !_authService.isValidEmail(_newEmailTextEditingController.text)) {
      setState(() {
        _newEmailError =
            _authService.isValidEmail(_newEmailTextEditingController.text)
                ? null
                : 'Invalid email';

        _passwordError =
            _authService.isValidPassword(_passwordTextEditingController.text)
                ? null
                : 'Invalid password';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });
    await _authService.getCurrentUser()?.reload();
    if (_newEmailTextEditingController.text ==
        (_authService.getCurrentUser()?.email ?? '')) {
      setState(() {
        _newEmailError = 'this is your current email';
        _isLoading = false;
      });
      return;
    }

    try {
      await _authService.loginEmailPassword(
          _authService.getCurrentUser()?.email ?? '',
          _passwordTextEditingController.text);
      await _authService.updateEmail(_newEmailTextEditingController.text);
      setState(() {
        _isEmailSentMessageVisible = true;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _passwordError = _authService.getPasswordErrorMessage(e.code);
        _passwordError ??= 'Login failed';
      });
    } on Exception {
      setState(() {
        _passwordError = 'Login failed';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _onTapCancel() {
    Navigator.pop(context);
  }
}
