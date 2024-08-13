import 'package:challenge/ui/components/simple_components/custom_card_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String text;
  final List<Widget> buttons;

  const CustomDialog({super.key, required this.text, required this.buttons});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding:
          const EdgeInsets.only(top: 150, bottom: 200, left: 50, right: 50),
      alignment: Alignment.center,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24))),
      child: SingleChildScrollView(
        child: CustomContainerComponent(
          borderRadius: CardComponent.standardBorderRadius,
          padding: const EdgeInsets.all(15),
          height: 230,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                textAlign: TextAlign.center,
              ),
              Row(
                children: buttons,
              )
            ],
          ),
        ),
      ),
    );
  }
}
