// ignore_for_file: must_be_immutable

import 'package:challenge/ui/components/list_items/list_item_icon_child_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ListItemIconTextInputComponent extends StatefulWidget {
  Function(String)? onChangeTextField;
  final IconData icon;
  final TextEditingController textEditingController;
  String? errorText;
  String? hintText;
  bool? isHidden;
  TextInputType? keyboardType;
  TextInputAction? textInputAction;
  final IconData? actionIcon;
  final Function()? onTapActionIcon;
  final Function()? onTap;
  final bool? isEnabled;
  final bool? autoFocus;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;

  ListItemIconTextInputComponent({
    super.key,
    this.onChangeTextField,
    required this.icon,
    required this.textEditingController,
    this.errorText,
    this.hintText,
    this.isHidden,
    this.keyboardType,
    this.textInputAction,
    this.actionIcon,
    this.onTapActionIcon,
    this.onTap,
    this.isEnabled,
    this.autoFocus,
    this.focusNode,
    this.inputFormatters,
  });

  @override
  State<ListItemIconTextInputComponent> createState() =>
      _ListItemIconTextInputComponentState();
}

class _ListItemIconTextInputComponentState
    extends State<ListItemIconTextInputComponent> {
  late FocusNode focusNode = widget.focusNode ?? FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (!focusNode.hasFocus &&
          widget.keyboardType != TextInputType.visiblePassword) {
        widget.textEditingController.text =
            widget.textEditingController.text.trim();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

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
                textInputAction: widget.textInputAction,
                inputFormatters: widget.inputFormatters,
                keyboardType: widget.keyboardType,
                style: Theme.of(context).textTheme.bodyMediumBlack,
                enabled: widget.isEnabled,
                autofocus: widget.autoFocus ?? false,
                focusNode: focusNode,
                decoration: InputDecoration(
                    isCollapsed:
                        true, // somehow needed to vertically center the text
                    border: InputBorder.none,
                    hintText: widget.hintText,
                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                    errorText: widget.errorText),
              ),
            ),
            Visibility(
                visible: widget.actionIcon != null,
                child: GestureDetector(
                    onTap: widget.onTapActionIcon,
                    child: Icon(widget.actionIcon,
                        color: Theme.of(context).colorScheme.tertiary)))
          ],
        ));
  }
}
