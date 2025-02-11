import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/small_container_in_list_item_component.dart';
import 'package:flutter/material.dart';

class GroupChallengeIconComponent extends StatefulWidget {
  final GroupChallengeModel groupChallenge;
  final ParticipantModel? participant;

  const GroupChallengeIconComponent(
      {super.key, required this.groupChallenge, required this.participant});

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
        padding: const EdgeInsets.symmetric(
            horizontal: ContainerInContainerComponent.standardPaddingSmall),
        height: SmallContainerInListItemComponent.height,
        child: Center(
          child: Row(
            children: [
              Text(
                  '${widget.participant == null ? '' : widget.participant!.getLatestAttempt().isInBacklog(widget.groupChallenge) ? '' : '${widget.groupChallenge.getPositionOf(widget.participant!.user.id)} | '}${widget.groupChallenge.participants.length} ',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.tertiary)),
              Icon(
                IconEnum.groupChallenge.icon,
                color: Theme.of(context).colorScheme.tertiary,
                size: Theme.of(context).textTheme.titleLarge?.fontSize,
              ),
            ],
          ),
        ));
  }
}
