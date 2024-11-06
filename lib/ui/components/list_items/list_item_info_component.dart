import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/icon_container_in_list_item_component.dart';
import 'package:flutter/material.dart';

class ListItemInfoComponent extends StatelessWidget {
  final String text;

  const ListItemInfoComponent({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return CustomContainerComponent(
      padding: const EdgeInsets.all(ListItemContainerComponent.standardPadding),
      isHeightDynamic: true,
      borderRadius: CardComponent.standardBorderRadius,
      margin: const EdgeInsets.symmetric(
          horizontal: CardComponent.standardSideMargin),
      child: Row(
        children: [
          IconContainerInListItemComponent(icon: IconEnum.info.icon),
          Expanded(
            child: Text(
              text,
              maxLines: null,
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          )
        ],
      ),
    );
  }
}
