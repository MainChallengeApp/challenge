import 'package:challenge/globals.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/simple_components/custom_card_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EditBioPage extends StatefulWidget {
  final UserModel user;
  final String preTitle;

  const EditBioPage({
    super.key,
    required this.user,
    required this.preTitle,
  });

  @override
  State<EditBioPage> createState() => _EditBioPageState();
}

class _EditBioPageState extends State<EditBioPage> {
  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);

  late UserModel editUser = widget.user.copy();

  bool isLoading = false;

  String title = 'Bio';

  late var bioTextEditingController = TextEditingController(
    text: editUser.bio,
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
            Flexible(
              child: CustomContainerComponent(
                isHeightDynamic: true,
                borderRadius: CardComponent.standardBorderRadius,
                margin: const EdgeInsets.only(
                    left: ListItemContainerComponent.standardMargin,
                    right: ListItemContainerComponent.standardMargin,
                    bottom: ListItemContainerComponent.standardMargin),
                child: IntrinsicHeight(
                  child: TextField(
                    controller: bioTextEditingController,
                    maxLines: null,
                    style: const TextStyle(
                      fontSize: basicFontSize,
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Bio',
                    ),
                    inputFormatters: [
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        if (newValue.text.isNotEmpty &&
                            newValue.text[0] == '\n') {
                          final newText = newValue.text.substring(1);
                          return TextEditingValue(
                            text: newText,
                            selection: TextSelection.collapsed(
                                offset: newValue.selection.end - 1),
                          );
                        }
                        return newValue;
                      }),
                    ],
                    onChanged: (value) => editUser.bio = value,
                  ),
                ),
              ),
            ),
            SpaceColumnComponent(
              height: 20,
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
                      onTap: onTapSave,
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

  void onTapCancel() {
    Navigator.pop(context);
  }
}
