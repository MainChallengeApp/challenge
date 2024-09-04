import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_input_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditUsernamePage extends StatefulWidget {
  final UserModel user;
  final String preTitle;

  const EditUsernamePage({
    super.key,
    required this.user,
    required this.preTitle,
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
    text: '@${editUser.username}',
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBarComponent(preTitle: widget.preTitle, titleText: title),
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SpaceColumnComponent(
              child: ListItemIconTextInputComponent(
                icon: IconEnum.username.icon,
                textEditingController: userNameTextEditingController,
                onChangeTextField: (value) {
                  String newValue = '';
                  if (!value.startsWith('@')) {
                    newValue = value;
                  } else {
                    newValue = value.substring(1);
                  }
                  userNameTextEditingController.text = '@$newValue';
                  editUser.username = newValue;
                },
              ),
            ),
            SpaceColumnComponent(
                child: ListItemButtonComponent(
              onTap: onTapSave,
              text: 'Save',
              isLoading: isLoading,
            )),
          ],
        ),
      ),
    );
  }

  void onTapSave() async {
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    await usersProvider.update(editUser);

    setState(() {
      isLoading = false;
    });
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }
}
