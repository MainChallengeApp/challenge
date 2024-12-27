// ignore_for_file: must_be_immutable

import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_input_component.dart';
import 'package:flutter/material.dart';

class ListItemEmailComponent extends StatefulWidget {
  const ListItemEmailComponent(
      {super.key,
      this.onChangeTextField,
      required this.textEditingController,
      this.errorText,
      this.hintText});

  final Function(String)? onChangeTextField;
  final TextEditingController textEditingController;
  final String? errorText;
  final String? hintText;

  @override
  State<ListItemEmailComponent> createState() => _ListItemEmailComponentState();
}

class _ListItemEmailComponentState extends State<ListItemEmailComponent> {
  @override
  Widget build(BuildContext context) {
    return ListItemIconTextInputComponent(
        icon: IconEnum.email.icon,
        actionIcon: widget.textEditingController.text == ''
            ? null
            : IconEnum.remove.icon,
        onTapActionIcon: onTapActionIcon,
        textEditingController: widget.textEditingController,
        onChangeTextField: widget.onChangeTextField,
        errorText: widget.errorText,
        keyboardType: TextInputType.emailAddress,
        hintText: widget.hintText ?? 'Email');
  }

  onTapActionIcon() {
    setState(() {
      widget.textEditingController.clear();
      widget.onChangeTextField?.call('');
    });
  }
}
