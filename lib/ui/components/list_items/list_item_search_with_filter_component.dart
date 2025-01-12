import 'package:challenge/enums/search_filter_enum.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_search_bar_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';

class ListItemSearchWithFilterComponent extends StatefulWidget {
  final Function(SearchFilterEnum) onTapFilter;
  final Function(PointerDownEvent)? onTapOutside;
  final TextEditingController textEditingController;
  final bool autoFocus;
  final bool isUserSearchActive;
  final Function()? onTapActionIcon;
  final SearchFilterEnum initialSearchFilter;

  final Function(String)? onChangeList;
  final Function(String)? onSubmitted;

  const ListItemSearchWithFilterComponent({
    super.key,
    required this.textEditingController,
    this.isUserSearchActive = false,
    this.autoFocus = false,
    this.onTapActionIcon,
    this.onChangeList,
    this.onSubmitted,
    this.initialSearchFilter = SearchFilterEnum.all,
    required this.onTapFilter,
    this.onTapOutside,
  });

  @override
  State<ListItemSearchWithFilterComponent> createState() =>
      _ListItemSearchWithFilterComponentState();
}

class _ListItemSearchWithFilterComponentState
    extends State<ListItemSearchWithFilterComponent> {
  late BuildContext context2;

  bool isTapVisible = false;

  late SearchFilterEnum selectedSearchFilter = widget.initialSearchFilter;

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
                    filterContainer(SearchFilterEnum.all),
                    filterContainer(SearchFilterEnum.challenges),
                    filterContainer(SearchFilterEnum.users),
                  ],
                )),
          ),
        ),
        ListItemSearchBarComponent(
          textEditingController: widget.textEditingController,
          autoFocus: widget.autoFocus,
          hintText: selectedSearchFilter == SearchFilterEnum.all
              ? 'Search for Challenges and Users'
              : selectedSearchFilter == SearchFilterEnum.challenges
                  ? 'Search for Challenges'
                  : 'Search for Users',
          onTapActionIcon: widget.onTapActionIcon,
          onTapOutside: widget.onTapOutside,
          changeList: widget.onChangeList,
          onSubmitted: widget.onSubmitted,
        )
      ],
    );
  }

  filterContainer(SearchFilterEnum searchFilter) {
    return Expanded(
      child: TapContainerComponent(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(0),
        isHeightDynamic: true,
        borderColor: Colors.transparent,
        backgroundColor: selectedSearchFilter == searchFilter
            ? Theme.of(context).colorScheme.themeColor4
            : Colors.transparent,
        onTap: () {
          widget.onTapFilter(searchFilter);
          setState(() {
            selectedSearchFilter = searchFilter;
          });
        },
        borderRadius: ListItemContainerComponent.standardBorderRadius,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            searchFilter.text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
