import 'package:challenge/ui/components/simple_components/custom_card_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SliderComponent extends StatelessWidget {
  final List<Widget> children;
  final ScrollPhysics scrollPhysics;
  final Function? onTap;
  final IconData icon;
  final String label;
  final Color? foregroundColor;

  const SliderComponent(
      {super.key,
      this.children = const [],
      this.scrollPhysics = const NeverScrollableScrollPhysics(),
      this.onTap,
      required this.icon,
      required this.label,
      this.foregroundColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding:
            const EdgeInsets.only(bottom: CardComponent.standardBottomMargin),
        child: CustomContainerComponent(
          height: double.infinity,
          borderRadius: CardComponent.standardBorderRadius,
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              SlidableAction(
                  onPressed: (context) {
                    Slidable.of(context)!.close(duration: Duration.zero);
                    onTap?.call();
                  },
                  borderRadius: BorderRadius.circular(
                      CardComponent.standardBorderRadius -
                          1), // - 1 to adjust the onTap visualization
                  label: label,
                  icon: icon,
                  foregroundColor: foregroundColor,
                  padding: const EdgeInsets.all(0)),
            ],
          ),
        ),
      ),
    );
  }
}
