import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/simple_components/icon_container_in_list_item_component.dart';
import 'package:challenge/ui/components/simple_components/info_text_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListItemIconTextInputExpandedComponent extends StatefulWidget {
  final Function(String)? onChangeTextField;
  final Function(String)? onSubmitted;
  final Function(PointerDownEvent)? onTapOutside;
  final IconData icon;
  final TextEditingController textEditingController;
  final String? hintText;
  final IconData? actionIcon;
  final Function()? onTapActionIcon;
  final bool? autoFocus;
  final FocusNode? focusNode;
  final bool autoCorrection;
  final bool enableSuggestions;
  final String lableText;
  final int? maxLength;
  final bool removeActionIcon;
  final String? infoText;

  const ListItemIconTextInputExpandedComponent({
    super.key,
    this.onChangeTextField,
    required this.icon,
    required this.textEditingController,
    this.hintText,
    this.actionIcon,
    this.onTapActionIcon,
    this.autoFocus,
    this.onSubmitted,
    this.onTapOutside,
    this.autoCorrection = true,
    this.enableSuggestions = true,
    required this.lableText,
    this.maxLength,
    this.focusNode,
    this.removeActionIcon = false,
    this.infoText,
  });

  @override
  State<ListItemIconTextInputExpandedComponent> createState() =>
      _ListItemIconTextInputExpandedComponentState();
}

class _ListItemIconTextInputExpandedComponentState
    extends State<ListItemIconTextInputExpandedComponent> {
  final _scrollController = ScrollController();

  late final _focusNode = widget.focusNode ?? FocusNode();

  @override
  void dispose() {
    super.dispose();
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    widget.textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ListItemContainerComponent(
              isHeightDynamic: true,
              onTapColor: Colors.transparent,
              onTap: _onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _iconAndTitle(),
                  const SpaceComponent(
                    height: ListItemContainerComponent.standardPadding,
                  ),
                  Expanded(
                    child: CupertinoScrollbar(
                      controller: _scrollController,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: TextField(
                          maxLines: null,
                          controller: widget.textEditingController,
                          maxLength: widget.maxLength,
                          buildCounter: (BuildContext context,
                                  {required int currentLength,
                                  required bool isFocused,
                                  int? maxLength}) =>
                              null,
                          style: Theme.of(context).textTheme.textInputSmall,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: widget.hintText,
                            hintStyle:
                                Theme.of(context).textTheme.textInputHintSmall,
                            contentPadding: const EdgeInsets.only(
                                bottom:
                                    BottomNavigationComponent.standardMargin),
                            isDense: true,
                          ),
                          onChanged: widget.onChangeTextField,
                          onSubmitted: widget.onSubmitted,
                          autofocus: widget.autoFocus ?? false,
                          focusNode: _focusNode,
                          enableSuggestions: widget.enableSuggestions,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.maxLength != null,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        '${widget.textEditingController.text.length}/${widget.maxLength}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          if (widget.infoText != null)
            InfoTextComponent(text: widget.infoText!),
        ],
      ),
    );
  }

  _onTap() {
    _focusNode.requestFocus();
  }

  Row _iconAndTitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconContainerInListItemComponent(icon: widget.icon),
        Expanded(
          child: Text(
            widget.lableText,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Theme.of(context).colorScheme.tertiary),
          ),
        ),
        Visibility(
          visible: widget.actionIcon != null,
          child: GestureDetector(
            onTap: widget.onTapActionIcon,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: ListItemContainerComponent.standardPadding),
              child: Icon(
                widget.actionIcon,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.removeActionIcon &&
              widget.textEditingController.text.isNotEmpty,
          child: GestureDetector(
            onTap: _onTapRemoveActionIcon,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: ListItemContainerComponent.standardPadding),
              child: Icon(
                IconEnum.remove.icon,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ),
        )
      ],
    );
  }

  void _onTapRemoveActionIcon() {
    widget.textEditingController.clear();
    widget.onChangeTextField?.call('');
    _focusNode.requestFocus();
  }
}
