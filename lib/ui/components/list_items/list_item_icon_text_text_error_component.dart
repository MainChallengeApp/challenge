import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_child_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';

class ListItemIconTextTextErrorComponent extends StatelessWidget {
  final void Function()? onTap;
  final IconData icon;
  final Color? iconColor;
  final EdgeInsetsGeometry? margin;
  final String text;
  final String text2;
  final String? errorText;
  final bool? isEnabled;

  const ListItemIconTextTextErrorComponent(
      {super.key,
      this.onTap,
      required this.icon,
      required this.text,
      this.iconColor,
      this.margin,
      required this.text2,
      this.errorText,
      this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return ListItemIconChildComponent(
        isEnabled: isEnabled,
        icon: icon,
        onTap: onTap,
        margin: margin,
        padding: const EdgeInsets.symmetric(
            horizontal: ListItemContainerComponent.standardPadding),
        child: Row(
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
            const SpaceComponent(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Expanded(child: SizedBox()),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        text2.replaceAll('\n', ' '),
                        style: Theme.of(context)
                            .textTheme
                            .titleMediaNormalTertiary,
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                      child: errorText == null
                          ? const SizedBox()
                          : Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                errorText!,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .error),
                              ),
                            )),
                ],
              ),
            ),
          ],
        ));
  }
}
