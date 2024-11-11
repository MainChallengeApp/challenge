import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/ui/components/challenge/challenge_total_percentage_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_fraction_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/image_in_list_item_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';

class ListItemParticipantComponent extends StatefulWidget {
  const ListItemParticipantComponent({
    super.key,
    required this.onTap,
    required this.participant,
    required this.position,
    required this.groupChallenge,
    required this.user,
  });

  final dynamic Function() onTap;
  final ParticipantModel participant;
  final UserModel user;
  final GroupChallengeModel groupChallenge;
  final int position;

  @override
  State<ListItemParticipantComponent> createState() =>
      _ListItemParticipantComponentState();
}

class _ListItemParticipantComponentState
    extends State<ListItemParticipantComponent> {
  @override
  Widget build(BuildContext context) {
    return ListItemFractionComponent(
        onTap: widget.onTap,
        initialProgress: widget.participant
            .getLatestAttempt()
            .getCurrentPercentage(widget.groupChallenge),
        child: Row(
          children: [
            ContainerInContainerComponent(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              height: CustomContainerComponent.standardHeight * 0.55,
              child: Center(
                child: Text('${widget.position + 1}.',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.tertiary)),
              ),
            ),
            const SpaceComponent(
              width: ListItemContainerComponent.standardPadding,
            ),
            ImageInListItemComponent(
                margin: const EdgeInsets.only(
                    right: ListItemContainerComponent.standardPadding),
                icon: IconEnum.user.icon,
                url: widget.user.pictureUrl),
            Expanded(
              child: Text(
                widget.user.username,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ChallengeTotalPercentageComponent(
                attempt: widget.participant.getLatestAttempt(),
                groupChallenge: widget.groupChallenge),
          ],
        ));
  }
}
