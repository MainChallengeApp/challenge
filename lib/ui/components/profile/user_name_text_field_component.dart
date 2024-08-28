import 'package:challenge/globals.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:flutter/material.dart';

class UserNameTextFieldComponent extends StatefulWidget {
  final UserModel user;

  const UserNameTextFieldComponent({
    super.key,
    required this.user,
  });

  @override
  State<UserNameTextFieldComponent> createState() =>
      _UserNameTextFieldComponentState();
}

class _UserNameTextFieldComponentState
    extends State<UserNameTextFieldComponent> {
  late final userNameTextEditingController = TextEditingController()
    ..text = '@${widget.user.username}'
    ..selection = TextSelection.collapsed(offset: widget.user.username.length);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: CustomContainerComponent(
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextField(
            style: const TextStyle(fontSize: basicFontSize),
            onChanged: (value) {
              String newValue = '';
              if (!value.startsWith('@')) {
                newValue = value;
              } else {
                newValue = value.substring(1);
              }
              userNameTextEditingController.text = '@$newValue';
              widget.user.username = newValue;
            },
            decoration: const InputDecoration.collapsed(hintText: 'Username'),
            controller: userNameTextEditingController),
      ),
    ));
  }
}
