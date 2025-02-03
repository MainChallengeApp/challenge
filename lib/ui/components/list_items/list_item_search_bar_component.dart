import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_input_component.dart';
import 'package:flutter/material.dart';

class ListItemSearchBarComponent extends StatefulWidget {
  final String hintText;
  final Function(String)? changeList;
  final TextEditingController textEditingController;
  final bool isEnabled;
  final bool isEditable;
  final bool autoFocus;
  final Function()? onTap;
  final Function(PointerDownEvent)? onTapOutside;

  const ListItemSearchBarComponent(
      {super.key,
      this.changeList,
      required this.textEditingController,
      this.isEnabled = true,
      this.autoFocus = false,
      this.hintText = 'Search',
      this.onTap,
      this.onTapOutside,
      this.isEditable = true});

  @override
  State<ListItemSearchBarComponent> createState() =>
      _ListItemSearchBarComponentState();
}

class _ListItemSearchBarComponentState
    extends State<ListItemSearchBarComponent> {
  @override
  Widget build(BuildContext context) {
    return ListItemIconTextInputComponent(
      onTap: widget.onTap,
      onTapOutside: widget.onTapOutside,
      icon: IconEnum.search.icon,
      textEditingController: widget.textEditingController,
      isEnabled: widget.isEnabled,
      isEditable: widget.isEditable,
      hintText: widget.hintText,
      textInputAction: TextInputAction.search,
      autoFocus: widget.autoFocus,
      autoCorrection: false,
      enableSuggestions: true,
      onChangeTextField: (value) {
        setState(() {
          widget.changeList?.call(value);
        });
      },
      removeActionIcon: true,
    );
  }
}
