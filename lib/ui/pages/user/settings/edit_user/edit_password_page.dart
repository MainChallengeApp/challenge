import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_info_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/icon_container_in_list_item_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage({
    super.key,
  });

  @override
  State<EditPasswordPage> createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  bool isLoading = false;

  String title = 'Edit Password';

  var authService = AuthService();

  late String email = authService.getCurrentUser() != null
      ? authService.getCurrentUser()!.email!
      : 'email not found';

  String? oldPasswordError;
  String? newPasswordError;

  bool isEmailSentMessageVisible = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ScaffoldComponent(
        appBar: AppBarComponent(title: title),
        isBottomNavigationVisible: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SpaceColumnComponent(
                      child: ListItemInfoComponent(
                          text:
                              'Click on "Send Link" to receive an email to reset your password.')),
                  Visibility(
                      visible: isEmailSentMessageVisible,
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
                                'Click the link in the email to reset your password.',
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
            SpaceColumnComponent(
              height: BottomNavigationComponent.standardMargin,
              child: Row(
                children: [
                  Expanded(
                    child: ListItemButtonComponent(
                      onTap: onTapCancel,
                      text: 'Cancel',
                      isMainButton: false,
                      margin: const EdgeInsets.only(
                          left: ListItemContainerComponent.standardMargin),
                    ),
                  ),
                  const SpaceComponent(
                    width: ListItemContainerComponent.standardMargin,
                  ),
                  Expanded(
                    child: ListItemButtonComponent(
                      margin: const EdgeInsets.only(
                          right: ListItemContainerComponent.standardMargin),
                      onTap: onTapSendLink,
                      text: 'Send Link',
                      isLoading: isLoading,
                      isMainButton: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onTapSendLink() async {
    if (isLoading) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await authService
          .sendPasswordResetEmail(authService.getCurrentUser()?.email ?? '');
      setState(() {
        isEmailSentMessageVisible = true;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        oldPasswordError = authService.getPasswordErrorMessage(e.code);
        oldPasswordError ??= 'Login failed';
      });
    } on Exception {
      setState(() {
        oldPasswordError = 'Login failed';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }

    setState(() {
      isLoading = false;
    });
    // ignore: use_build_context_synchronously
    // Navigator.pop(context);
  }

  void onTapCancel() {
    Navigator.pop(context);
  }
}
