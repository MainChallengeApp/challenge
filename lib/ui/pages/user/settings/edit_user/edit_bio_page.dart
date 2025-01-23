import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/database_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_input_expanded_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditBioPage extends StatefulWidget {
  final UserModel user;
  final bool isRegistration;

  const EditBioPage({
    super.key,
    required this.user,
    this.isRegistration = false,
  });

  @override
  State<EditBioPage> createState() => _EditBioPageState();
}

class _EditBioPageState extends State<EditBioPage> {
  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);
  late UserModel editUser = widget.user.copy();

  bool isLoading = false;

  final String _title = 'Edit Bio';

  late final _bioTextEditingController = TextEditingController(
    text: editUser.bio,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ScaffoldComponent(
        appBar: AppBarComponent(title: _title),
        isBottomNavigationVisible: false,
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            ListItemIconTextInputExpandedComponent(
              icon: IconEnum.bio.icon,
              textEditingController: _bioTextEditingController,
              lableText: 'Bio',
              autoFocus: true,
              hintText: 'Bio',
              maxLength: DatabaseService.maxCharactersMedium,
              onChangeTextField: (value) {
                setState(() {
                  editUser.bio = value;
                });
              },
              onSubmitted: (_) => _onTapSave(),
            ),
            SpaceColumnComponent(
              height: BottomNavigationComponent.standardMargin,
              isSpaceOnTop: true,
              child: Row(
                children: [
                  Expanded(
                    child: ListItemButtonComponent(
                      onTap: widget.isRegistration ? _onTapSkip : _onTapCancel,
                      text: widget.isRegistration ? 'Skip' : 'Cancel',
                      isMainButton: false,
                      margin: const EdgeInsets.only(
                          left: ListItemContainerComponent.standardMargin),
                    ),
                  ),
                  const SpaceComponent(),
                  Expanded(
                    child: ListItemButtonComponent(
                      margin: const EdgeInsets.only(
                          right: ListItemContainerComponent.standardMargin),
                      onTap: _onTapSave,
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

  void _onTapSave() async {
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
      _nextInRegistration();
      return;
    }

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  void _onTapCancel() {
    Navigator.pop(context);
  }

  void _onTapSkip() {
    _nextInRegistration();
  }

  void _nextInRegistration() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
