import 'dart:math';

import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_text_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';

class ChallengeTotalPercentageComponent extends StatefulWidget {
  final AttemptModel attempt;

  const ChallengeTotalPercentageComponent({super.key, required this.attempt});

  @override
  State<ChallengeTotalPercentageComponent> createState() =>
      _ChallengeTotalPercentageComponentState();
}

class _ChallengeTotalPercentageComponentState
    extends State<ChallengeTotalPercentageComponent> {
  @override
  Widget build(BuildContext context) {
    return ContainerInContainerTextComponent(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.symmetric(horizontal: 6),
        height: CustomContainerComponent.standardHeight * 0.55,
        color: (widget.attempt.isFailed()
            ? Theme.of(context).colorScheme.red
            : widget.attempt.isSucceeded()
                ? Theme.of(context).colorScheme.green
                : null),
        textColor: widget.attempt.isFailed() || widget.attempt.isSucceeded()
            ? Theme.of(context).colorScheme.surface
            : Theme.of(context).colorScheme.tertiary,
        text:
            '${(min(widget.attempt.getCurrentPercentage(), 1) * 100).floor()} %',
        textStyle: Theme.of(context).textTheme.titleSmall);
  }
}
