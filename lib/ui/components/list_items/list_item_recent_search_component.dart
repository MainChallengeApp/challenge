import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_child_component.dart';
import 'package:flutter/material.dart';

class ListItemRecentSearchComponent extends StatelessWidget {
  final String recentSearch;
  final Function() onTap;
  final Function() onTapActionIcon;

  const ListItemRecentSearchComponent(
      {super.key,
      required this.recentSearch,
      required this.onTap,
      required this.onTapActionIcon});

  @override
  Widget build(BuildContext context) {
    return ListItemIconTextChildComponent(
      onTap: onTap,
      icon: IconEnum.recent.icon,
      text: recentSearch,
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: onTapActionIcon,
          child: Icon(
            IconEnum.remove.icon,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ),
    );
  }
}
