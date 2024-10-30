import 'package:challenge/ui/components/simple_components/card_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String? text;
  final Widget? child;
  final List<Widget> buttons;

  const CustomDialog(
      {super.key,
      this.child,
      required this.buttons,
      required this.title,
      this.text});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: CustomContainerComponent(
      borderRadius: CardComponent.standardBorderRadius,
      padding: const EdgeInsets.all(CardComponent.standardPadding),
      isHeightDynamic: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
            overflow: TextOverflow.ellipsis,
          ),
          const SpaceComponent(),
          Visibility(
            visible: text != null,
            child: Text(
              text ?? '',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Visibility(visible: child != null, child: child ?? Container()),
          Row(
            children: buttons,
          )
        ],
      ),
    ));
  }
}
