// ignore_for_file: must_be_immutable

import 'package:challenge/ui/components/list_items/list_item_icon_text_input_component.dart';
import 'package:flutter/material.dart';

class ListItemEmailComponent extends StatefulWidget {
  const ListItemEmailComponent(
      {super.key,
      this.onChangeTextField,
      required this.textEditingController,
      this.errorText});

  final Function(String)? onChangeTextField;
  final TextEditingController textEditingController;
  final String? errorText;

  @override
  State<ListItemEmailComponent> createState() => _ListItemEmailComponentState();
}

class _ListItemEmailComponentState extends State<ListItemEmailComponent> {
  @override
  Widget build(BuildContext context) {
    return ListItemIconTextInputComponent(
        icon: Icons.email_rounded,
        textEditingController: widget.textEditingController,
        onChangeTextField: widget.onChangeTextField,
        errorText: widget.errorText,
        keyboardType: TextInputType.emailAddress,
        hintText: 'Email');
  }
}
