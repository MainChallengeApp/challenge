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
  final Function(PointerDownEvent)? onTapOutside;

  ListItemSearchBarComponent(
      {super.key,
      this.changeList,
      required this.textEditingController,
      this.isEnabled = true,
      this.autoFocus = false,
      this.hintText = 'Search',
      this.onTap,
      this.onTapActionIcon,
      this.onTapOutside});

  @override
  State<ListItemSearchBarComponent> createState() =>
      _ListItemSearchBarComponentState();
}

class _ListItemSearchBarComponentState
    extends State<ListItemSearchBarComponent> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  // TODO: prevent error idk if this is good :)
  // @override
  // void dispose() {
  //   _focusNode.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    widget.textEditingController.selection = TextSelection.collapsed(
        offset: widget.textEditingController.text.length);
    return ListItemIconTextInputComponent(
      onTap: widget.onTap,
      onTapOutside: widget.onTapOutside,
      icon: IconEnum.search.icon,
      actionIcon:
          widget.textEditingController.text == '' ? null : IconEnum.remove.icon,
      onTapActionIcon: onTapActionIcon,
      textEditingController: widget.textEditingController,
      isEnabled: widget.isEnabled,
      hintText: widget.hintText,
      textInputAction: TextInputAction.search,
      autoFocus: widget.autoFocus,
      focusNode: _focusNode,
      onChangeTextField: (value) {
        setState(() {
          widget.changeList?.call(value);
        });
      },
    );
  }

  onTapActionIcon() {
    setState(() {
      widget.textEditingController.clear();
      widget.changeList?.call('');
      widget.onTapActionIcon?.call();
      _focusNode.requestFocus();
    });
  }
}
