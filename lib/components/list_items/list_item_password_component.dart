// ignore_for_file: must_be_immutable

import 'package:challenge/components/list_items/list_item_icon_text_input_component.dart';
import 'package:flutter/material.dart';

class ListItemPasswordComponent extends StatefulWidget {
  ListItemPasswordComponent(
      {super.key,
      this.onChangeTextField,
      required this.textEditingController,
      this.errorText});

  Function(String)? onChangeTextField;
  final TextEditingController textEditingController;
  String? errorText;

  @override
  State<ListItemPasswordComponent> createState() =>
      _ListItemPasswordComponentState();
}

class _ListItemPasswordComponentState extends State<ListItemPasswordComponent> {
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return ListItemIconTextInputComponent(
        icon: Icons.password_rounded,
        textEditingController: widget.textEditingController,
        isHidden: true,
        onChangeTextField: onChangeTextField,
        errorText: errorText,
        hintText: 'Password');
  }

  onChangeTextField(value) {
    errorText = null;
    widget.onChangeTextField?.call(value);
  }
}
