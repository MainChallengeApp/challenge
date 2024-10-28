import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/database_service.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/simple_components/custom_card_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditBioPage extends StatefulWidget {
  final UserModel user;
  final String preTitle;
  final bool isRegistration;

  const EditBioPage({
    super.key,
    required this.user,
    required this.preTitle,
    this.isRegistration = false,
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
                padding: const EdgeInsets.symmetric(
                    horizontal: ListItemContainerComponent.standardPadding,
                    vertical: ListItemContainerComponent.standardPadding - 5),
                margin: const EdgeInsets.only(
                    left: ListItemContainerComponent.standardMargin,
                    right: ListItemContainerComponent.standardMargin,
                    bottom: ListItemContainerComponent.standardMargin),
                child: TextField(
                  controller: bioTextEditingController,
                  maxLength: DatabaseService.maxCharactersMedium,
                  maxLines: null,
                  style: Theme.of(context).textTheme.textInputSmall,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Bio',
                    hintStyle: Theme.of(context).textTheme.textInputHintSmall,
                  ),
                  onChanged: (value) => editUser.bio = value,
                  onSubmitted: (value) {
                    bioTextEditingController.text = value.trim();
                    editUser.bio = value.trim();
                  },
                  onTapOutside: (_) {
                    bioTextEditingController.text =
                        bioTextEditingController.text.trim();
                    editUser.bio = bioTextEditingController.text.trim();
                  },
                ),
              ),
            ),
            SpaceColumnComponent(
              height: 20,
              child: Row(
                children: [
                  Expanded(
                    child: ListItemButtonComponent(
                      onTap: widget.isRegistration ? onTapSkip : onTapCancel,
                      text: widget.isRegistration ? 'Skip' : 'Cancel',
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

    if (widget.isRegistration) {
      nextInRegistration();
      return;
    }

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  void onTapCancel() {
    Navigator.pop(context);
  }

  void onTapSkip() {
    nextInRegistration();
  }

  void nextInRegistration() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
