import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_input_component.dart';
import 'package:flutter/material.dart';

class ListItemEmailComponent extends StatefulWidget {
  final Function(String)? onChangeTextField;
  final TextEditingController textEditingController;
  final String? errorText;
  final String? hintText;
  final bool autoFocus;
  final String? lableText;

  const ListItemEmailComponent(
      {super.key,
      this.onChangeTextField,
      required this.textEditingController,
      this.errorText,
      this.hintText,
      this.autoFocus = false,
      this.lableText});

  @override
  State<ListItemEmailComponent> createState() => _ListItemEmailComponentState();
}

class _ListItemEmailComponentState extends State<ListItemEmailComponent> {
  @override
  Widget build(BuildContext context) {
    return ListItemIconTextInputComponent(
      icon: IconEnum.email.icon,
      textEditingController: widget.textEditingController,
      onChangeTextField: widget.onChangeTextField,
      errorText: widget.errorText,
      keyboardType: TextInputType.emailAddress,
      autoFocus: widget.autoFocus,
      labelText: widget.lableText ?? 'Email',
      removeActionIcon: true,
      textInputAction: TextInputAction.next,
    );
  }
}
