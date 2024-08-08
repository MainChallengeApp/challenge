// ignore_for_file: must_be_immutable

import 'package:challenge/components/list_items/list_item_icon_text_input_component.dart';
import 'package:flutter/material.dart';

class ListItemEmailComponent extends StatefulWidget {
  ListItemEmailComponent(
      {super.key,
      this.onChangeTextField,
      required this.textEditingController,
      this.errorText});

  Function(String)? onChangeTextField;
  final TextEditingController textEditingController;
  String? errorText;

  @override
  State<ListItemEmailComponent> createState() => _ListItemEmailComponentState();
}

class _ListItemEmailComponentState extends State<ListItemEmailComponent> {
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return ListItemIconTextInputComponent(
        icon: Icons.email_rounded,
        textEditingController: widget.textEditingController,
        onChangeTextField: onChangeTextField,
        errorText: errorText,
        keyboardType: TextInputType.emailAddress,
        hintText: 'Email');
  }

  onChangeTextField(value) {
    errorText = null;
    widget.onChangeTextField?.call(value);
  }
}
