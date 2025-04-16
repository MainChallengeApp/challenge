import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_input_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/pages/user/settings/edit_notification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EditUsernamePage extends StatefulWidget {
  final UserModel user;
  final bool isRegistration;
  final bool isKeyBoardAutoFocus;

  const EditUsernamePage({
    super.key,
    required this.user,
    this.isRegistration = false,
    this.isKeyBoardAutoFocus = true,
  });

  @override
  State<EditUsernamePage> createState() => _EditUsernamePageState();
}

class _EditUsernamePageState extends State<EditUsernamePage> {
  late final _usersProvider =
      Provider.of<UsersProvider>(context, listen: false);

  late final UserModel _editUser = widget.user.copy();

  bool _isLoading = false;

  final String _title = 'Edit Username';

  late final _userNameTextEditingController = TextEditingController(
    text: _editUser.username,
  );

  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ScaffoldComponent(
        appBar: AppBarComponent(
          title: _title,
          isFirstPageInRoute: widget.isRegistration,
        ),
        isBottomNavigationVisible: false,
        resizeToAvoidBottomInset: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SpaceColumnComponent(
              child: ListItemIconTextInputComponent(
                icon: IconEnum.username.icon,
                textEditingController: _userNameTextEditingController,
                hintText: _usersProvider.user.username,
                errorText: _errorText,
                autoCorrection: false,
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
                autoFocus: widget.isKeyBoardAutoFocus,
                onChangeTextField: (value) {
                  setState(() {
                    _editUser.username = value;
                    _errorText = null;
                  });
                },
                labelText: 'Username',
                removeActionIcon: true,
              ),
            ),
            SpaceColumnComponent(
              height: 20,
              child: Row(
                children: [
                  Expanded(
                    child: ListItemButtonComponent(
                      onTap: _onTapCancel,
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
                      onTap: _onTapSave,
                      isMainButton:
                          _userNameTextEditingController.text.trim().isNotEmpty,
                      text: 'Save',
                      isLoading: _isLoading,
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
    if (_isLoading) {
      return;
    }

    _editUser.username = _editUser.username.trim();
    if (_editUser.username.isEmpty) {
      setState(() {
        _errorText = 'Username cannot be empty';
      });
      return;
    }

    if (_editUser.username == widget.user.username) {
      if (widget.isRegistration) {
        _nextInRegistration();
        return;
      }

      Navigator.pop(context);
      return;
    }

    setState(() {
      _isLoading = true;
    });
    var result = await _usersProvider.updateUsername(_editUser);

    setState(() {
      _isLoading = false;
      if (!result) {
        _errorText = 'Username already taken';
      }
    });
    if (!result) {
      return;
    }

    if (widget.isRegistration) {
      _nextInRegistration();
      return;
    }

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  void _nextInRegistration() {
    // ignore: use_build_context_synchronously
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.push(
        //      ignore: use_build_context_synchronously
        context,
        NoAnimationPageRouteComponent(
            disableSwipeBack: true,
            builder: (builder) => EditUsernamePage(
                  user: _editUser,
                  isRegistration: true,
                  isKeyBoardAutoFocus: false,
                )));

    Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
            builder: (builder) =>
                const EditNotificationPage(isRegistration: true)));
    return;
  }

  void _onTapCancel() {
    if (widget.isRegistration) {
      _usersProvider.logout();
      return;
    }
    Navigator.pop(context);
  }
}
