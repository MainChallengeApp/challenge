import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/icon_container_in_list_item_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';

class ListItemInfoComponent extends StatefulWidget {
  final String text;
  final String? title;

  const ListItemInfoComponent({super.key, required this.text, this.title});

  @override
  State<ListItemInfoComponent> createState() => _ListItemInfoComponentState();
}

class _ListItemInfoComponentState extends State<ListItemInfoComponent> {
  late final bool _isExpanded = widget.title != null;

  @override
  Widget build(BuildContext context) {
    return CustomContainerComponent(
      padding: const EdgeInsets.all(ListItemContainerComponent.standardPadding),
      isHeightDynamic: true,
      borderRadius: CardComponent.standardBorderRadius,
      margin: const EdgeInsets.symmetric(
          horizontal: CardComponent.standardSideMargin),
      child: _isExpanded ? _expanded() : _slim(),
    );
  }

  Row _slim() {
    return Row(
      children: [
        IconContainerInListItemComponent(icon: IconEnum.info.icon),
        Expanded(
          child: Text(
            widget.text,
            maxLines: null,
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        )
      ],
    );
  }

  _expanded() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconContainerInListItemComponent(icon: IconEnum.info.icon),
            Expanded(
              child: Text(
                widget.title ?? '',
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            )
          ],
        ),
        const SpaceComponent(
          height: ListItemContainerComponent.standardPadding - 5,
        ),
        Text(
          widget.text,
          maxLines: null,
          softWrap: true,
          overflow: TextOverflow.visible,
          textHeightBehavior: const TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
          ),
        )
      ],
    );
  }
}
