import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';

class InfoTextComponent extends StatefulWidget {
  final String text;

  const InfoTextComponent({super.key, required this.text});

  @override
  State<InfoTextComponent> createState() => _InfoTextComponentState();
}

class _InfoTextComponentState extends State<InfoTextComponent> {
  @override
  Widget build(BuildContext context) {
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
              widget.text,
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
