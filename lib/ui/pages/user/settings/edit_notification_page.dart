import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/services/local_push_notification_service.dart';
import 'package:challenge/services/push_notification_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_child_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/components/simple_components/switch_component.dart';
import 'package:challenge/ui/dialogs/error_occurred_dialog.dart';
import 'package:challenge/ui/pages/user/settings/edit_user/edit_picture_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class EditNotificationPage extends StatefulWidget {
  final bool isRegistration;

  const EditNotificationPage({
    super.key,
    this.isRegistration = false,
  });

  @override
  State<EditNotificationPage> createState() => _EditNotificationPageState();
}

class _EditNotificationPageState extends State<EditNotificationPage> {
  final _usersProvider = getIt<UsersProvider>();

  late bool _editAllowNotifications = _usersProvider.user.allowNotifications;

  final _pushNotificationService = PushNotificationService();
  final _localNotificationService = LocalPushNotificationService();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ScaffoldComponent(
        appBar: const AppBarComponent(
          title: 'Notifications',
        ),
        isBottomNavigationVisible: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  _allowNotificationsSwitch(),
                ],
              ),
            ),
            SpaceColumnComponent(
              height: BottomNavigationComponent.standardMargin,
              child: Row(
                children: [
                  Expanded(
                    child: ListItemButtonComponent(
                      onTap: _onTapSkipOrCancel,
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
                      onTap: _onTapAllowOrSave,
                      isMainButton: true,
                      text: !_usersProvider.user.allowNotifications &&
                              !_editAllowNotifications
                          ? 'Allow'
                          : 'Save',
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

  SpaceColumnComponent _allowNotificationsSwitch() {
    return SpaceColumnComponent(
      child: ListItemIconTextChildComponent(
        icon: IconEnum.notification.icon,
        text: 'Allow Notifications',
        padding:
            const EdgeInsets.all(ListItemContainerComponent.standardPadding)
                .copyWith(
                    right: ListItemContainerComponent.standardPadding - 5),
        child: SwitchComponent(
            value: _editAllowNotifications,
            onChanged: (value) {
              setState(() {
                _editAllowNotifications = value;
              });
            }),
      ),
    );
  }

  void _onTapAllowOrSave() async {
    if (_isLoading) {
      return;
    }

    setState(() {
      if (!_usersProvider.user.allowNotifications && !_editAllowNotifications) {
        _editAllowNotifications = true;
      }
    });

    if (_usersProvider.user.allowNotifications == _editAllowNotifications) {
      if (widget.isRegistration) {
        _nextInRegistration();
        return;
      }
      return;
    }

    if (_editAllowNotifications) {
      final settings = await _pushNotificationService.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        openAppSettings();
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.authorized) {
        await _usersProvider.addFcmToken();
      }
    }

    setState(() {
      _isLoading = true;
    });
    try {
      _usersProvider.user.allowNotifications = _editAllowNotifications;
      await _usersProvider.update(_usersProvider.user);
      if (_usersProvider.user.allowNotifications) {
        await _localNotificationService.activateAllChallengeNotifications();
      } else {
        await _localNotificationService.cancelAllNotifications();
      }
    } catch (_) {
      ErrorOccurredDialog.show(
          errorText: 'Error occurred during updating user');
    }

    setState(() {
      _isLoading = false;
    });

    if (widget.isRegistration) {
      _nextInRegistration();
      return;
    }
  }

  void _nextInRegistration() {
    Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
            builder: (builder) => EditPicturePage(
                user: _usersProvider.user, isRegistration: true))).then((_) {
      setState(() {
        _editAllowNotifications = _usersProvider.user.allowNotifications;
      });
    });
  }

  void _onTapSkipOrCancel() {
    if (widget.isRegistration) {
      _nextInRegistration();
      return;
    }
    Navigator.pop(context);
  }
}
