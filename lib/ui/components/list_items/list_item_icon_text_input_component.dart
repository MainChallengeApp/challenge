// ignore_for_file: must_be_immutable

import 'package:challenge/globals.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_child_component.dart';
import 'package:flutter/material.dart';

class ListItemIconTextInputComponent extends StatefulWidget {
  Function(String)? onChangeTextField;
  final IconData icon;
  final TextEditingController textEditingController;
  String? errorText;
  String? hintText;
  bool? isHidden;
  TextInputType? keyboardType;
  final IconData? actionIcon;
  final Function()? onTapActionIcon;
  final Function()? onTap;
  final bool? isEnabled;
  final bool? autoFocus;

  ListItemIconTextInputComponent(
      {super.key,
      this.onChangeTextField,
      required this.icon,
      required this.textEditingController,
      this.errorText,
      this.hintText,
      this.isHidden,
      this.keyboardType,
      this.actionIcon,
      this.onTapActionIcon,
      this.onTap,
      this.isEnabled,
      this.autoFocus});

  @override
  State<ListItemIconTextInputComponent> createState() =>
      _ListItemIconTextInputComponentState();
}

class _ListItemIconTextInputComponentState
    extends State<ListItemIconTextInputComponent> {
  @override
  Widget build(BuildContext context) {
    return ListItemIconChildComponent(
        onTap: widget.onTap,
        icon: widget.icon,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextField(
                controller: widget.textEditingController,
                obscureText: widget.isHidden ?? false,
                onChanged: widget.onChangeTextField,
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.start,
                keyboardType: widget.keyboardType,
                style: const TextStyle(fontSize: basicFontSize),
                enabled: widget.isEnabled,
                autofocus: widget.autoFocus ?? false,
                decoration: InputDecoration(
                    isCollapsed:
                        true, // somehow needed to vertically center the text
                    border: InputBorder.none,
                    hintText: widget.hintText,
                    hintStyle: const TextStyle(color: themeColor3),
                    errorText: widget.errorText),
              ),
            ),
            Visibility(
                visible: widget.actionIcon != null,
                child: GestureDetector(
                    onTap: widget.onTapActionIcon,
                    child: Icon(widget.actionIcon, color: themeColor3)))
          ],
        ));
  }
}
