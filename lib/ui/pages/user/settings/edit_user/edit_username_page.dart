import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_input_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/pages/user/settings/edit_user/edit_picture_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EditUsernamePage extends StatefulWidget {
  final UserModel user;
  final String preTitle;
  final bool isRegistration;

  const EditUsernamePage({
    super.key,
    required this.user,
    required this.preTitle,
    this.isRegistration = false,
  });

  @override
  State<EditUsernamePage> createState() => _EditUsernamePageState();
}

class _EditUsernamePageState extends State<EditUsernamePage> {
  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);

  late UserModel editUser = widget.user.copy();

  bool isLoading = false;

  String title = 'Username';

  late var userNameTextEditingController = TextEditingController(
    text: editUser.username,
  );

  String? errorText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBarComponent(
          preTitle: widget.preTitle,
          titleText: title,
          isFirstPageInRoute: widget.isRegistration,
        ),
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SpaceColumnComponent(
              child: ListItemIconTextInputComponent(
                icon: IconEnum.username.icon,
                textEditingController: userNameTextEditingController,
                hintText: 'Username',
                errorText: errorText,
                inputFormatters: [
                  TextInputFormatter.withFunction(
                    (TextEditingValue oldValue, TextEditingValue newValue) {
                      return TextEditingValue(
                        text: newValue.text.toLowerCase().replaceAll(' ', '_'),
                        selection: newValue.selection,
                      );
                    },
                  ),
                ],
                onChangeTextField: (value) {
                  setState(() {
                    editUser.username = value;
                    errorText = null;
                  });
                },
              ),
            ),
            SpaceColumnComponent(
              height: 20,
              child: Row(
                children: [
                  Visibility(
                    visible: !widget.isRegistration,
                    child: Expanded(
                      child: ListItemButtonComponent(
                        onTap: onTapCancel,
                        text: 'Cancel',
                        isMainButton: false,
                        margin: const EdgeInsets.only(
                            left: ListItemContainerComponent.standardMargin),
                      ),
                    ),
                  ),
                  const SpaceComponent(
                    width: ListItemContainerComponent.standardMargin,
                  ),
                  Expanded(
                    child: ListItemButtonComponent(
                      margin: const EdgeInsets.only(
                          right: ListItemContainerComponent.standardMargin),
                      onTap: onTapSave,
                      isMainButton:
                          userNameTextEditingController.text.trim().isNotEmpty,
                      text: 'Save',
                      isLoading: isLoading,
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

  void onTapSave() async {
    if (isLoading) {
      return;
    }

    editUser.username = editUser.username.trim();
    if (editUser.username.isEmpty) {
      setState(() {
        errorText = 'Username cannot be empty';
      });
      return;
    }

    if (editUser.username == widget.user.username) {
      setState(() {
        errorText = 'Username cannot be the same';
      });
      return;
    }

    setState(() {
      isLoading = true;
    });
    var result = await usersProvider.updateUsername(editUser);

    setState(() {
      isLoading = false;
      if (!result) {
        errorText = 'Username already taken';
      }
    });
    if (!result) {
      return;
    }

    if (widget.isRegistration) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      Navigator.push(
          context,
          NoAnimationPageRouteComponent(
              builder: (builder) => EditPicturePage(
                  user: editUser,
                  preTitle: 'Registration',
                  isRegistration: true)));
      return;
    }

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  void onTapCancel() {
    Navigator.pop(context);
  }
}
