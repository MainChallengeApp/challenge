import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_password_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
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

  String? emailErrorText;
  String? passwordErrorText;

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
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SpaceColumnComponent(
                      child: CustomContainerComponent(
                        borderRadius: CardComponent.standardBorderRadius,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(20),
                        isHeightDynamic: true,
                        child: Center(
                          child: Text(
                            'This action will delete all your data and cannot be undone.\n\nEnter your password to delete your user.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ),
                    SpaceColumnComponent(
                      heightMultiplier: 2,
                      child: ListItemPasswordComponent(
                          textEditingController: passwordTextEditingController,
                          errorText: passwordErrorText,
                          onChangeTextField: (_) => setState(() {
                                emailErrorText = null;
                                passwordErrorText = null;
                              })),
                    ),
                  ],
                ),
              ),
            ),
            SpaceColumnComponent(
              height: 20,
              child: ListItemButtonComponent(
                  onTap: onTapDeleteUser,
                  text: 'Delete',
                  isLoading: isLoading,
                  isMainButton: false,
                  textColor: Theme.of(context).colorScheme.red),
            ),
          ],
        ),
      ),
    );
  }

  void onTapDeleteUser() async {
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
      setState(() {
        emailErrorText = authService.getEmailErrorMessage(e.code);
        passwordErrorText = authService.getPasswordErrorMessage(e.code);
        if (emailErrorText == null && passwordErrorText == null) {
          emailErrorText = 'Deletion failed';
          passwordErrorText = 'Deletion failed';
        }
      });
    } on Exception {
      setState(() {
        emailErrorText = 'Deletion failed';
        passwordErrorText = 'Deletion failed';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
