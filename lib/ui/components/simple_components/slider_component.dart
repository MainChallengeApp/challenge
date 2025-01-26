import 'package:challenge/ui/animations/sliding_animation.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
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
  final Duration duration;

  const SliderComponent(
      {super.key,
      this.children = const [],
      this.scrollPhysics = const NeverScrollableScrollPhysics(),
      this.onTap,
      required this.icon,
      required this.label,
      this.foregroundColor,
      this.duration = SlidingAnimation.slidingDuration});

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
                    Slidable.of(context)!.close(duration: duration);
                    Future.delayed(duration, () => {onTap?.call()});
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
