import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/challenge/challenge_total_percentage_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_fraction_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_component.dart';
import 'package:challenge/ui/components/simple_components/image_in_list_item_component.dart';
import 'package:challenge/ui/components/simple_components/small_container_in_list_item_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListItemParticipantComponent extends StatefulWidget {
  const ListItemParticipantComponent({
    super.key,
    required this.onTap,
    required this.participant,
    required this.position,
    required this.groupChallenge,
  });

  final dynamic Function() onTap;
  final ParticipantModel participant;
  final GroupChallengeModel groupChallenge;
  final int position;

  @override
  State<ListItemParticipantComponent> createState() =>
      _ListItemParticipantComponentState();
}

class _ListItemParticipantComponentState
    extends State<ListItemParticipantComponent> {
  late final _usersProvider =
      Provider.of<UsersProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return ListItemFractionComponent(
        isFailed: widget.participant.getLatestAttempt().isFailed(),
        onTap: widget.onTap,
        initialProgress: widget.participant
            .getLatestAttempt()
            .getCurrentPercentage(widget.groupChallenge),
        child: Row(
          children: [
            ContainerInContainerComponent(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              height: SmallContainerInListItemComponent.height,
              child: Center(
                child: Text('${widget.position}.',
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
                url: widget.participant.user.pictureUrl),
            Expanded(
              child: Text(
                widget.participant.user.username,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            _youContainer(),
            _adminContainer(),
            _statusOrPercentage(),
          ],
        ));
  }

  _statusOrPercentage() {
    return widget.participant.isAccepted()
        ? widget.participant.getLatestAttempt().isInBacklog()
            ? ContainerInContainerComponent(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                height: SmallContainerInListItemComponent.height,
                child: Center(
                  child: Text('Accepted',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.tertiary)),
                ),
              )
            : ChallengeTotalPercentageComponent(
                attempt: widget.participant.getLatestAttempt(),
                groupChallenge: widget.groupChallenge)
        : ContainerInContainerComponent(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: SmallContainerInListItemComponent.height,
            child: Center(
              child: Text('Invited',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.tertiary)),
            ),
          );
  }

  _adminContainer() {
    return Visibility(
      visible: widget.groupChallenge.userId == widget.participant.user.id,
      child: Row(
        children: [
          ContainerInContainerComponent(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: SmallContainerInListItemComponent.height,
            child: Center(
              child: Text('Admin',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.tertiary)),
            ),
          ),
          const SpaceComponent(
            width: ListItemContainerComponent.standardPadding,
          ),
        ],
      ),
    );
  }

  _youContainer() {
    return Visibility(
      visible: widget.participant.user.id == _usersProvider.user.id,
      child: Row(
        children: [
          ContainerInContainerComponent(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: SmallContainerInListItemComponent.height,
            child: Center(
              child: Text('You',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.tertiary)),
            ),
          ),
          const SpaceComponent(
            width: ListItemContainerComponent.standardPadding,
          ),
        ],
      ),
    );
  }
}
