import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/push_notification_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_child_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/components/simple_components/switch_component.dart';
import 'package:challenge/ui/pages/user/settings/edit_user/edit_picture_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

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
  late final _usersProvider =
      Provider.of<UsersProvider>(context, listen: false);

  late bool editAllowNotifications = _usersProvider.user.allowNotifications;

  final _pushNotificationService = PushNotificationService();

  bool _isLoading = false;

  final String _title = 'Notifications';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ScaffoldComponent(
        appBar: AppBarComponent(
          title: _title,
        ),
        isBottomNavigationVisible: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SpaceColumnComponent(
                    child: ListItemIconTextChildComponent(
                      icon: IconEnum.notification.icon,
                      text: 'Allow Notifications',
                      padding: const EdgeInsets.all(
                              ListItemContainerComponent.standardPadding)
                          .copyWith(
                              right:
                                  ListItemContainerComponent.standardPadding -
                                      5),
                      child: SwitchComponent(
                          value: editAllowNotifications,
                          onChanged: (value) {
                            setState(() {
                              editAllowNotifications = value;
                            });
                          }),
                    ),
                  ),
                ],
              ),
            ),
            SpaceColumnComponent(
              height: 20,
              child: Row(
                children: [
                  Expanded(
                    child: ListItemButtonComponent(
                      onTap: onTapSkipOrCancel,
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
                      onTap: onTapAllowOrSave,
                      isMainButton: true,
                      text: !_usersProvider.user.allowNotifications &&
                              !editAllowNotifications
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

  void onTapAllowOrSave() async {
    if (_isLoading) {
      return;
    }

    setState(() {
      if (!_usersProvider.user.allowNotifications && !editAllowNotifications) {
        editAllowNotifications = true;
      }
    });

    if (_usersProvider.user.allowNotifications == editAllowNotifications) {
      if (widget.isRegistration) {
        nextInRegistration();
        return;
      }
      return;
    }

    if (editAllowNotifications) {
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

    _usersProvider.user.allowNotifications = editAllowNotifications;
    await _usersProvider.update(_usersProvider.user);

    setState(() {
      _isLoading = false;
    });

    if (widget.isRegistration) {
      nextInRegistration();
      return;
    }
  }

  void nextInRegistration() {
    Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        NoAnimationPageRouteComponent(
            builder: (builder) => EditPicturePage(
                user: _usersProvider.user, isRegistration: true))).then((_) {
      setState(() {
        editAllowNotifications = _usersProvider.user.allowNotifications;
      });
    });
  }

  void onTapSkipOrCancel() {
    if (widget.isRegistration) {
      nextInRegistration();
      return;
    }
    Navigator.pop(context);
  }
}
