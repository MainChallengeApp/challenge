import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/loading_circle/loading_circle_component.dart';
import 'package:flutter/material.dart';

class ListItemButtonComponent extends StatelessWidget {
  final VoidCallback onTap;
  final bool isMainButton;
  final String text;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? textColor;
  final bool isLoading;
  final IconData? icon;

  const ListItemButtonComponent(
      {super.key,
      required this.onTap,
      this.isMainButton = true,
      required this.text,
      this.icon,
      this.margin,
      this.padding,
      this.textColor,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return ListItemContainerComponent(
      backgroundColor: isMainButton
          ? Theme.of(context).colorScheme.secondary
          : Theme.of(context).colorScheme.surface,
      onTap: onTap,
      onTapColor: isMainButton ? Colors.white.withAlpha(20) : null,
      margin: margin,
      padding: padding,
      child: Center(
          child: isLoading
              ? LoadingCircleComponent(
                  color: isMainButton
                      ? Theme.of(context).colorScheme.onSecondary
                      : null,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null)
                      Icon(icon,
                          color: textColor ??
                              (isMainButton
                                  ? Theme.of(context).colorScheme.onSecondary
                                  : Theme.of(context).colorScheme.onSurface)),
                    Text(text,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: textColor ??
                                    (isMainButton
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onSecondary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface))),
                  ],
                )),
    );
  }
}
