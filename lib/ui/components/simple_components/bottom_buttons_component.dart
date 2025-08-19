import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';

class BottomButtonsComponent extends StatelessWidget {
  const BottomButtonsComponent(
      {super.key, required this.buttons, this.hasTopMargin = true});

  final List<Widget> buttons;
  final bool hasTopMargin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: hasTopMargin,
          child: const SpaceComponent(),
        ),
        SpaceColumnComponent(
          height: BottomNavigationComponent.standardMargin,
          child: Row(
            children: [
              const SpaceComponent(
                width: BottomNavigationComponent.standardMargin,
              ),
              ..._buttons(),
              const SpaceComponent(
                width: BottomNavigationComponent.standardMargin,
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buttons() {
    final buttonsResult = [];
    for (var button in buttons) {
      buttonsResult.add(
        Expanded(
          child: button,
        ),
      );
      if (button != buttons.last) {
        buttonsResult.add(
          const SpaceComponent(),
        );
      }
    }
    return buttonsResult;
  }
}
