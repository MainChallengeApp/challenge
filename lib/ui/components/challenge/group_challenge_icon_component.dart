import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:flutter/material.dart';

class GroupChallengeIconComponent extends StatefulWidget {
  final ChallengeModel challenge;

  const GroupChallengeIconComponent({super.key, required this.challenge});

  @override
  State<GroupChallengeIconComponent> createState() =>
      _GroupChallengeIconComponentState();
}

class _GroupChallengeIconComponentState
    extends State<GroupChallengeIconComponent> {
  @override
  Widget build(BuildContext context) {
    return ContainerInContainerComponent(
        margin: const EdgeInsets.only(
            left: CustomContainerComponent.standardPadding),
        padding: const EdgeInsets.all(0),
        height: CustomContainerComponent.standardHeight * 0.55,
        width: CustomContainerComponent.standardHeight * 0.55,
        child: Center(
          child: Icon(
            IconEnum.groupChallenge.icon,
            color: Theme.of(context).colorScheme.tertiary,
            size: Theme.of(context).textTheme.titleLarge?.fontSize,
          ),
        ));
  }
}
