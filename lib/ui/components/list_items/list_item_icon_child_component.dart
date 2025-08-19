import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/simple_components/icon_container_in_list_item_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
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
        if (widget.infoText != null) _infoText(),
      ],
    );
  }

  Padding _infoText() {
    return Padding(
      padding: const EdgeInsets.only(
          top: ListItemContainerComponent.standardPadding / 2,
          left: ListItemContainerComponent.standardMargin +
              ListItemContainerComponent.standardPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            IconEnum.info.icon,
            color: Theme.of(context).colorScheme.tertiary,
            size: 16,
          ),
          const SpaceComponent(
            width: ListItemContainerComponent.standardPadding / 2,
            height: 0,
          ),
          Expanded(
            child: Text(
              widget.infoText!,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
            ),
          )
        ],
      ),
    );
  }
}
