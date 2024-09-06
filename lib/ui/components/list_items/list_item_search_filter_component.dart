import 'package:challenge/globals.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:flutter/material.dart';

class ListItemSearchFilterComponent extends StatefulWidget {
  final Function() onTapChallenges;
  final Function() onTapUsers;

  const ListItemSearchFilterComponent(
      {super.key, required this.onTapChallenges, required this.onTapUsers});

  @override
  State<ListItemSearchFilterComponent> createState() =>
      _ListItemSearchFilterComponentState();
}

class _ListItemSearchFilterComponentState
    extends State<ListItemSearchFilterComponent> {
  late BuildContext context2;

  bool isTapVisible = false;

  bool isFilterOnChallenges = true;

  @override
  Widget build(BuildContext context) {
    return ListItemContainerComponent(
        padding: const EdgeInsets.all(0),
        child: Row(
          children: [
            filterContainer('Challenges', () {
              setState(() {
                isFilterOnChallenges = true;
              });
              widget.onTapChallenges.call();
            }, isFilterOnChallenges),
            filterContainer('Users', () {
              setState(() {
                isFilterOnChallenges = false;
              });
              widget.onTapUsers.call();
            }, !isFilterOnChallenges),
          ],
        ));
  }

  filterContainer(String text, Function() onTap, bool isSelected) {
    return Expanded(
      child: TapContainerComponent(
        margin: const EdgeInsets.all(0),
        isHeightDynamic: true,
        borderColor: Colors.transparent,
        backgroundColor: isSelected ? themeColor4 : Colors.transparent,
        onTap: onTap,
        borderRadius: ListItemContainerComponent.standardBorderRadius,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
