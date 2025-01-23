// ignore_for_file: must_be_immutable
import 'package:challenge/services/database_service.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_child_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ListItemIconTextInputComponent extends StatefulWidget {
  final Function(String)? onChangeTextField;
  final Function(String)? onSubmitted;
  final Function(PointerDownEvent)? onTapOutside;
  final IconData icon;
  final TextEditingController textEditingController;
  String? errorText;
  String? hintText;
  bool? isHidden;
  TextInputType? keyboardType;
  TextInputAction? textInputAction;
  final IconData? actionIcon;
  final Function()? onTapActionIcon;
  final Function()? onTap;
  final bool? isEnabled;
  final bool? autoFocus;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final bool autoCorrection;
  final bool enableSuggestions;
  final String? lableText;

  ListItemIconTextInputComponent({
    super.key,
    this.onChangeTextField,
    required this.icon,
    required this.textEditingController,
    this.errorText,
    this.hintText,
    this.isHidden,
    this.keyboardType,
    this.textInputAction,
    this.actionIcon,
    this.onTapActionIcon,
    this.onTap,
    this.isEnabled,
    this.autoFocus,
    this.focusNode,
    this.inputFormatters,
    this.onSubmitted,
    this.onTapOutside,
    this.autoCorrection = true,
    this.enableSuggestions = true,
    this.lableText,
  });

  @override
  State<ListItemIconTextInputComponent> createState() =>
      _ListItemIconTextInputComponentState();
}

class _ListItemIconTextInputComponentState
    extends State<ListItemIconTextInputComponent>
    with SingleTickerProviderStateMixin {
  late FocusNode focusNode = widget.focusNode ?? FocusNode();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    focusNode.addListener(_handleFocusChange);
    widget.textEditingController.addListener(_handleTextChange);

    // Initialize label position based on whether there's initial text
    if (widget.textEditingController.text.isNotEmpty) {
      _animationController.value = 1.0;
    }
  }

  void _handleFocusChange() {
    if (focusNode.hasFocus) {
      _animationController.forward();
    } else if (!focusNode.hasFocus &&
        widget.textEditingController.text.isEmpty) {
      _animationController.reverse();
    }
    if (!focusNode.hasFocus &&
        widget.keyboardType != TextInputType.visiblePassword) {
      widget.textEditingController.text =
          widget.textEditingController.text.trim();
    }
  }

  void _handleTextChange() {
    if (widget.textEditingController.text.isNotEmpty && !focusNode.hasFocus) {
      _animationController.forward();
    } else if (widget.textEditingController.text.isEmpty &&
        !focusNode.hasFocus) {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    focusNode.removeListener(_handleFocusChange);
    widget.textEditingController.removeListener(_handleTextChange);
    _animationController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _listItem(),
        _animatedLabel(),
        _errorText(),
      ],
    );
  }

  _listItem() {
    return ListItemIconChildComponent(
      onTap: widget.onTap,
      icon: widget.icon,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              maxLength: DatabaseService.maxCharactersMedium,
              buildCounter: (_,
                      {required currentLength,
                      required isFocused,
                      required maxLength}) =>
                  null,
              controller: widget.textEditingController,
              obscureText: widget.isHidden ?? false,
              onChanged: widget.onChangeTextField,
              onSubmitted: widget.onSubmitted,
              onTapOutside: widget.onTapOutside,
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.start,
              textInputAction: widget.textInputAction,
              inputFormatters: widget.inputFormatters,
              keyboardType: widget.keyboardType,
              style: Theme.of(context).textTheme.bodyMediumBlack,
              enabled: widget.isEnabled,
              autofocus: widget.autoFocus ?? false,
              focusNode: focusNode,
              autocorrect: widget.autoCorrection,
              enableSuggestions: widget.enableSuggestions,
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: widget.hintText,
                hintStyle: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          Visibility(
            visible: widget.actionIcon != null,
            child: GestureDetector(
              onTap: widget.onTapActionIcon,
              child: Icon(
                widget.actionIcon,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _animatedLabel() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          top: Tween<double>(
            begin: ListItemContainerComponent.standardPadding +
                ListItemIconTextComponent.iconContainerSize / 2 -
                (_getTextSize(widget.lableText,
                            Theme.of(context).textTheme.titleMedium)
                        .height /
                    2) +
                1,
            end: 5,
          ).evaluate(_animation),
          left: 2 * ListItemContainerComponent.standardPadding +
              ListItemIconTextComponent.iconContainerSize +
              ListItemContainerComponent.standardMargin -
              1,
          child: GestureDetector(
            onTap: () {
              focusNode.requestFocus();
            },
            child: Text(
              widget.lableText ?? '',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: Tween<double?>(
                      begin: Theme.of(context).textTheme.titleMedium?.fontSize,
                      end: Theme.of(context).textTheme.labelSmall?.fontSize,
                    ).evaluate(_animation),
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
            ),
          ),
        );
      },
    );
  }

  Widget _errorText() {
    return Positioned(
      bottom: 5,
      left: 2 * ListItemContainerComponent.standardPadding +
          ListItemIconTextComponent.iconContainerSize +
          ListItemContainerComponent.standardMargin,
      child: Text(
        widget.errorText ?? '',
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: Theme.of(context).colorScheme.error),
      ),
    );
  }

  Size _getTextSize(String? text, TextStyle? style,
      {double maxWidth = double.infinity}) {
    if (text == null || text.isEmpty || style == null) {
      return Size.zero;
    }
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: maxWidth);

    return textPainter.size;
  }
}
