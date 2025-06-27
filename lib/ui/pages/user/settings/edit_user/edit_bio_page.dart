import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/database_service.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_input_expanded_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/simple_components/bottom_buttons_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';

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
  final _usersProvider = getIt<UsersProvider>();
  final _tabProvider = getIt<TabProvider>();
  late final UserModel _editUser = widget.user.copy();

  bool _isLoading = false;

  late final _bioTextEditingController = TextEditingController(
    text: _editUser.bio,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ScaffoldComponent(
        appBar: const AppBarComponent(title: 'Edit Bio'),
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
                  _editUser.bio = value;
                });
              },
              onSubmitted: (_) => _onTapSave(),
              removeActionIcon: true,
            ),
            const SpaceComponent(),
            BottomButtonsComponent(
              buttons: [
                ListItemButtonComponent(
                  margin: EdgeInsets.zero,
                  onTap: widget.isRegistration ? _onTapSkip : _onTapCancel,
                  text: widget.isRegistration ? 'Skip' : 'Cancel',
                  isMainButton: false,
                ),
                ListItemButtonComponent(
                  margin: EdgeInsets.zero,
                  onTap: _onTapSave,
                  text: 'Save',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onTapSave() async {
    if (_isLoading) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    await _usersProvider.update(_editUser);

    setState(() {
      _isLoading = false;
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
    _tabProvider.setBottomNavigationVisibility(true);
  }
}
