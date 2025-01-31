import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_child_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';

class ListItemIconTextChildComponent extends StatefulWidget {
  final void Function()? onTap;
  final IconData icon;
  final Color? iconColor;
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final String text;
  final int flex;
  final String? labelText;
  final bool? isEnabled;

  const ListItemIconTextChildComponent(
      {super.key,
      this.onTap,
      required this.icon,
      required this.child,
      required this.text,
      this.iconColor,
      this.margin,
      this.padding,
      this.flex = 1,
      this.labelText,
      this.isEnabled});

  @override
  State<ListItemIconTextChildComponent> createState() =>
      _ListItemIconTextChildComponentState();
}

class _ListItemIconTextChildComponentState
    extends State<ListItemIconTextChildComponent> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListItemIconChildComponent(
            isEnabled: widget.isEnabled,
            icon: widget.icon,
            onTap: widget.onTap,
            margin: widget.margin,
            padding: widget.padding,
            iconColor: widget.iconColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: widget.flex,
                  child: Text(
                    widget.text,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SpaceComponent(
                  width: 10,
                ),
                widget.child,
              ],
            )),
        _label()
      ],
    );
  }

  Widget _label() {
    return Positioned(
      top: 5,
      left: 2 * ListItemContainerComponent.standardPadding +
          ListItemIconTextComponent.iconContainerSize +
          ListItemContainerComponent.standardMargin -
          1,
      child: Text(
        widget.labelText ?? '',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: Theme.of(context).textTheme.labelSmall?.fontSize,
              color: Theme.of(context).colorScheme.tertiary,
            ),
      ),
    );
  }
}
