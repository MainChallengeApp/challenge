import 'package:challenge/globals.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_search_bar_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:flutter/material.dart';

class ListItemSearchWithFilterComponent extends StatefulWidget {
  final Function() onTapChallenges;
  final Function() onTapUsers;
  final TextEditingController textEditingController;
  final Function(String) changeList;
  final bool autoFocus;
  final bool isFilterOnChallenges;

  const ListItemSearchWithFilterComponent(
      {super.key,
      required this.onTapChallenges,
      required this.onTapUsers,
      required this.textEditingController,
      required this.changeList,
      this.autoFocus = false,
      required this.isFilterOnChallenges});

  @override
  State<ListItemSearchWithFilterComponent> createState() =>
      _ListItemSearchWithFilterComponentState();
}

class _ListItemSearchWithFilterComponentState
    extends State<ListItemSearchWithFilterComponent> {
  late BuildContext context2;

  bool isTapVisible = false;

  late bool isFilterOnChallenges = widget.isFilterOnChallenges;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListItemContainerComponent(
          padding: const EdgeInsets.all(0),
          height: ListItemContainerComponent.standardHeight + 40,
          child: Align(
              alignment: Alignment.bottomCenter,
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
              )),
        ),
        ListItemSearchBarComponent(
          textEditingController: widget.textEditingController,
          changeList: widget.changeList,
          autoFocus: widget.autoFocus,
        )
      ],
    );
    // return ListItemContainerComponent(
    //     padding: const EdgeInsets.all(0),
    //     child: Row(
    //       children: [
    //         filterContainer('Challenges', () {
    //           setState(() {
    //             isFilterOnChallenges = true;
    //           });
    //           widget.onTapChallenges.call();
    //         }, isFilterOnChallenges),
    //         filterContainer('Users', () {
    //           setState(() {
    //             isFilterOnChallenges = false;
    //           });
    //           widget.onTapUsers.call();
    //         }, !isFilterOnChallenges),
    //       ],
    //     ));
  }

  filterContainer(String text, Function() onTap, bool isSelected) {
    return Expanded(
      child: TapContainerComponent(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(0),
        isHeightDynamic: true,
        borderColor: Colors.transparent,
        backgroundColor: isSelected ? themeColor4 : Colors.transparent,
        onTap: onTap,
        borderRadius: ListItemContainerComponent.standardBorderRadius,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            text,
            style: const TextStyle(
              color: themeColor3,
            ),
          ),
        ),
      ),
    );
  }
}
