// ignore_for_file: must_be_immutable

import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_input_component.dart';
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
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return ListItemIconTextInputComponent(
        icon: IconEnum.password.icon,
        actionIcon: isHidden
            ? Icons.visibility_outlined
            : Icons.visibility_off_outlined,
        onTap: onTapActionIcon,
        textEditingController: widget.textEditingController,
        isHidden: isHidden,
        onChangeTextField: widget.onChangeTextField,
        errorText: widget.errorText,
        keyboardType: TextInputType.visiblePassword,
        hintText: 'Password');
  }

  onTapActionIcon() {
    setState(() {
      isHidden = !isHidden;
    });
  }
}
