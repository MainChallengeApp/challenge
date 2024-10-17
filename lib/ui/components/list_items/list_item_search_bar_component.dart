// ignore_for_file: must_be_immutable

import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_input_component.dart';
import 'package:flutter/material.dart';

class ListItemSearchBarComponent extends StatefulWidget {
  final String hintText;
  Function(String)? changeList;
  TextEditingController textEditingController;
  final bool isEnabled;
  final bool autoFocus;
  final Function()? onTap;
  final Function()? onTapActionIcon;

  ListItemSearchBarComponent(
      {super.key,
      this.changeList,
      required this.textEditingController,
      this.isEnabled = true,
      this.autoFocus = false,
      this.hintText = 'Search...',
      this.onTap,
      this.onTapActionIcon});

  @override
  State<ListItemSearchBarComponent> createState() =>
      _ListItemSearchBarComponentState();
}

class _ListItemSearchBarComponentState
    extends State<ListItemSearchBarComponent> {
  @override
  Widget build(BuildContext context) {
    widget.textEditingController.selection = TextSelection.collapsed(
        offset: widget.textEditingController.text.length);
    return ListItemIconTextInputComponent(
        onTap: widget.onTap,
        icon: IconEnum.search.icon,
        actionIcon: widget.textEditingController.text == ''
            ? null
            : IconEnum.remove.icon,
        onTapActionIcon: onTapActionIcon,
        textEditingController: widget.textEditingController,
        isEnabled: widget.isEnabled,
        hintText: widget.hintText,
        textInputAction: TextInputAction.search,
        autoFocus: widget.autoFocus,
        onChangeTextField: (value) {
          setState(() {
            widget.changeList?.call(value);
          });
        });
  }

  onTapActionIcon() {
    setState(() {
      widget.textEditingController.clear();
      widget.changeList?.call('');
      widget.onTapActionIcon?.call();
    });
  }
}
