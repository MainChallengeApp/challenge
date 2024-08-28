import 'package:challenge/globals.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:flutter/material.dart';

class UserNameTextFieldComponent extends StatelessWidget {
  final UserModel user;

  const UserNameTextFieldComponent({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: CustomContainerComponent(
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextField(
            style: const TextStyle(fontSize: basicFontSize),
            onChanged: (value) => user.username = value,
            decoration: const InputDecoration.collapsed(hintText: 'Title'),
            controller: TextEditingController()
              ..text = user.username
              ..selection =
                  TextSelection.collapsed(offset: user.username.length)),
      ),
    ));
  }
}
