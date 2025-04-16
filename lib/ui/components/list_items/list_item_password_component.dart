import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_input_component.dart';
import 'package:flutter/material.dart';

class ListItemPasswordComponent extends StatefulWidget {
  final Function(String)? onChangeTextField;
  final Function(String)? onSubmitted;
  final TextEditingController textEditingController;
  final String? errorText;
  final String? hintText;

  const ListItemPasswordComponent(
      {super.key,
      this.onChangeTextField,
      required this.textEditingController,
      this.errorText,
      this.hintText,
      this.onSubmitted});

  @override
  State<ListItemPasswordComponent> createState() =>
      _ListItemPasswordComponentState();
}

class _ListItemPasswordComponentState extends State<ListItemPasswordComponent> {
  bool isHidden = true;

  @override
  void initState() {
    super.initState();
    isHidden = true;
  }

  @override
  Widget build(BuildContext context) {
    return ListItemIconTextInputComponent(
      icon: IconEnum.password.icon,
      actionIcon: isHidden ? IconEnum.visible.icon : IconEnum.notVisible.icon,
      onTapActionIcon: onTapActionIcon,
      textEditingController: widget.textEditingController,
      isHidden: isHidden,
      onChangeTextField: widget.onChangeTextField,
      onSubmitted: widget.onSubmitted,
      errorText: widget.errorText,
      lableText: 'Password',
      keyboardType: TextInputType.visiblePassword,
      removeActionIcon: true,
    );
  }

  onTapActionIcon() {
    setState(() {
      isHidden = !isHidden;
    });
  }
}
