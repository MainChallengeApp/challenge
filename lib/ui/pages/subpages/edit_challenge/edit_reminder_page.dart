import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/models/challenge/reminder_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/services/time_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_child_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/list_items/list_item_info_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/components/simple_components/switch_component.dart';
import 'package:challenge/ui/pages/user/settings/edit_notification_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditReminderPage extends StatefulWidget {
  final ParticipantModel participant;

  const EditReminderPage({
    Key? key,
    required this.participant,
  }) : super(key: key);

  @override
  State<EditReminderPage> createState() => _EditReminderPageState();
}

class _EditReminderPageState extends State<EditReminderPage> {
  final _usersProvider = getIt<UsersProvider>();

  late final ReminderModel _editReminder =
      widget.participant.reminder?.copy() ?? ReminderModel.empty();

  @override
  Widget build(BuildContext context) {
    return ScaffoldComponent(
      appBar: const AppBarComponent(
        title: 'Edit Daily Reminder',
      ),
      isBottomNavigationVisible: false,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                _information(),
                _allowNotificationsInSettings(),
                _isReminderActive(),
                _picker(),
              ],
            ),
          ),
          _actionButtons(),
        ],
      ),
    );
  }

  _allowNotificationsInSettings() {
    return Visibility(
      visible: !_usersProvider.user.allowNotifications,
      child: SpaceColumnComponent(
        child: ListItemIconTextComponent(
          icon: IconEnum.settings.icon,
          title: 'Allow Notifications in Settings',
          onTap: _onTapAllowNotificationsInSettings,
        ),
      ),
    );
  }

  SpaceColumnComponent _isReminderActive() {
    return SpaceColumnComponent(
      child: ListItemIconTextChildComponent(
        isEnabled: _usersProvider.user.allowNotifications,
        icon: IconEnum.notification.icon,
        padding:
            const EdgeInsets.all(ListItemContainerComponent.standardPadding)
                .copyWith(
                    right: ListItemContainerComponent.standardPadding - 5),
        text: 'Daily Reminder',
        child: SwitchComponent(
            value: _editReminder.isActive,
            onChanged: (isActive) {
              setState(() {
                _editReminder.isActive = isActive;
              });
            }),
      ),
    );
  }

  SpaceColumnComponent _picker() {
    return SpaceColumnComponent(
        child: ListItemContainerComponent(
            padding: EdgeInsets.zero,
            isHeightDynamic: true,
            isEnabled: _editReminder.isActive &&
                _usersProvider.user.allowNotifications,
            child: SizedBox(
              height: ListItemContainerComponent.standardHeight * 4,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                use24hFormat: true,
                initialDateTime: TimeService.now().copyWith(
                  hour: _editReminder.hours,
                  minute: _editReminder.minutes,
                ),
                onDateTimeChanged: _onChangeTime,
              ),
            )));
  }

  void _onChangeTime(DateTime newDateTime) {
    setState(() {
      _editReminder.hours = newDateTime.hour;
      _editReminder.minutes = newDateTime.minute;
    });
  }

  SpaceColumnComponent _actionButtons() {
    return SpaceColumnComponent(
      height: BottomNavigationComponent.standardMargin,
      isSpaceOnTop: true,
      child: Row(
        children: [
          const SpaceComponent(
            width: ListItemContainerComponent.standardMargin,
          ),
          Expanded(
            child: ListItemButtonComponent(
              onTap: _onTapCancel,
              text: 'Cancel',
              isMainButton: false,
              margin: EdgeInsets.zero,
            ),
          ),
          const SpaceComponent(),
          Expanded(
            child: ListItemButtonComponent(
              margin: EdgeInsets.zero,
              onTap: _onTapAccept,
              text: 'Accept',
            ),
          ),
          const SpaceComponent(
            width: ListItemContainerComponent.standardMargin,
          ),
        ],
      ),
    );
  }

  void _onTapAccept() {
    widget.participant.reminder = _editReminder;
    Navigator.of(context).pop();
  }

  void _onTapCancel() {
    Navigator.of(context).pop();
  }

  _information() {
    return const SpaceColumnComponent(
      child: ListItemInfoComponent(
        text:
            'This is a local reminder. It will not be shared with other participants.',
      ),
    );
  }

  void _onTapAllowNotificationsInSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditNotificationPage(),
      ),
    ).then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }
}
