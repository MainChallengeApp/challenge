import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_search_bar_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';

class ListItemSearchWithFilterComponent extends StatefulWidget {
  final Function() onTapChallenges;
  final Function() onTapUsers;
  final TextEditingController textEditingController;
  final bool autoFocus;
  final bool isFilterOnChallenges;
  final bool isUserSearchActive;
  final Function()? onTapActionIcon;

  final Function(String)? onChangeList;

  const ListItemSearchWithFilterComponent({
    super.key,
    required this.onTapChallenges,
    required this.onTapUsers,
    required this.textEditingController,
    required this.isFilterOnChallenges,
    this.isUserSearchActive = false,
    this.autoFocus = false,
    this.onTapActionIcon,
    this.onChangeList,
  });

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
        Visibility(
          visible: widget.isUserSearchActive,
          child: ListItemContainerComponent(
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
        ),
        ListItemSearchBarComponent(
          textEditingController: widget.textEditingController,
          autoFocus: widget.autoFocus,
          hintText:
              'Search for Challenges${widget.isUserSearchActive ? ' or Users' : ''}...',
          onTapActionIcon: widget.onTapActionIcon,
          changeList: widget.onChangeList,
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
        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.themeColor4
            : Colors.transparent,
        onTap: onTap,
        borderRadius: ListItemContainerComponent.standardBorderRadius,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
