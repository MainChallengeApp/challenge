import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/simple_components/icon_container_in_list_item_component.dart';
import 'package:challenge/ui/components/simple_components/info_text_component.dart';
import 'package:flutter/material.dart';

class ListItemIconChildComponent extends StatefulWidget {
  final void Function()? onTap;
  final IconData icon;
  final Color? iconColor;
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool? isEnabled;
  final String? infoText;

  const ListItemIconChildComponent(
      {super.key,
      this.onTap,
      required this.icon,
      required this.child,
      this.iconColor,
      this.margin,
      this.padding,
      this.isEnabled,
      this.infoText});

  @override
  State<ListItemIconChildComponent> createState() =>
      _ListItemIconChildComponentState();
}

class _ListItemIconChildComponentState
    extends State<ListItemIconChildComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListItemContainerComponent(
          isEnabled: widget.isEnabled,
          margin: widget.margin,
          padding: widget.padding,
          onTap: widget.onTap,
          child: Row(
            children: [
              IconContainerInListItemComponent(
                icon: widget.icon,
                iconColor:
                    widget.iconColor ?? Theme.of(context).colorScheme.tertiary,
              ),
              Expanded(
                child: widget.child,
              )
            ],
          ),
        ),
        if (widget.infoText != null) InfoTextComponent(text: widget.infoText!),
      ],
    );
  }
}
