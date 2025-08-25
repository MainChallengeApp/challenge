import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_child_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';

class ListItemIconDropdown<T> extends StatefulWidget {
  final List<T> list;
  final Function(T) onTapEntry;
  final String Function(T) getText;
  final Function()? onTap;
  final IconData icon;
  final String labelText;
  final bool isExpanded;
  final T? initialEntry;
  final String? infoText;

  const ListItemIconDropdown(
      {super.key,
      required this.list,
      required this.onTapEntry,
      required this.getText,
      required this.icon,
      required this.labelText,
      this.isExpanded = false,
      this.onTap,
      this.initialEntry,
      this.infoText});

  @override
  State<ListItemIconDropdown<T>> createState() =>
      _ListItemIconDropdownState<T>();
}

class _ListItemIconDropdownState<T> extends State<ListItemIconDropdown<T>> {
  bool _isExpanded = false;
  late T _selected = widget.initialEntry ?? widget.list.first;

  @override
  void didUpdateWidget(covariant ListItemIconDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _isExpanded = widget.isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: _isExpanded,
          child: Align(
            alignment: Alignment.topCenter,
            child: ListItemContainerComponent(
              isHeightDynamic: true,
              padding: const EdgeInsets.only(
                  left: CardComponent.standardPadding,
                  right: CardComponent.standardPadding,
                  bottom: CardComponent.standardPadding,
                  top: ListItemContainerComponent.standardHeight +
                      SpaceComponent.standardHeight -
                      2),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.list
                      .map((listEntry) =>
                          _entry(listEntry, listEntry == widget.list.last))
                      .toList(),
                ),
              ),
            ),
          ),
        ),
        ListItemIconTextChildComponent(
          infoText: _isExpanded ? null : widget.infoText,
          onTap: () {
            setState(() => _isExpanded = !_isExpanded);
            widget.onTap?.call();
          },
          icon: widget.icon,
          text: widget.getText(_selected),
          labelText: widget.labelText,
          child: Align(
            alignment: Alignment.centerRight,
            child: Icon(
              _isExpanded ? IconEnum.arrowUp.icon : IconEnum.arrowDown.icon,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _entry(T listEntry, bool isLast) {
    return SpaceColumnComponent(
      height: isLast ? 0 : null,
      child: GestureDetector(
        onTap: () => _onTapListEntry(listEntry),
        child: CustomContainerComponent(
          child: Row(children: [
            Expanded(
              child: Text(
                widget.getText(listEntry),
              ),
            ),
            Icon(
              IconEnum.autoFill.icon,
              size: Theme.of(context).textTheme.titleLarge?.fontSize,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ]),
        ),
      ),
    );
  }

  _onTapListEntry(T listEntry) {
    setState(() {
      _isExpanded = false;
      _selected = listEntry;
    });
    widget.onTapEntry(listEntry);
  }
}
