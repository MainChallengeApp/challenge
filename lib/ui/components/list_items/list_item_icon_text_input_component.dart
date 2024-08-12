// ignore_for_file: must_be_immutable

import 'package:challenge/ui/components/list_items/list_item_icon_child_component.dart';
import 'package:flutter/material.dart';

class ListItemIconTextInputComponent extends StatefulWidget {
  ListItemIconTextInputComponent(
      {super.key,
      this.onChangeTextField,
      required this.icon,
      required this.textEditingController,
      this.errorText,
      this.hintText,
      this.isHidden,
      this.keyboardType});

  Function(String)? onChangeTextField;
  final IconData icon;
  final TextEditingController textEditingController;
  String? errorText;
  String? hintText;
  bool? isHidden;
  TextInputType? keyboardType;

  @override
  State<ListItemIconTextInputComponent> createState() =>
      _ListItemIconTextInputComponentState();
}

class _ListItemIconTextInputComponentState
    extends State<ListItemIconTextInputComponent> {
  @override
  Widget build(BuildContext context) {
    return ListItemIconChildComponent(
        icon: widget.icon,
        child: TextField(
          controller: widget.textEditingController,
          obscureText: widget.isHidden ?? false,
          onChanged: widget.onChangeTextField,
          textAlignVertical: TextAlignVertical.center,
          textAlign: TextAlign.start,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
              isCollapsed: true, // somehow needed to vertically center the text
              border: InputBorder.none,
              hintText: widget.hintText,
              errorText: widget.errorText),
        ));
  }
}
