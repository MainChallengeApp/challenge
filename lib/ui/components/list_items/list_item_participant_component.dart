import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/challenge/challenge_total_percentage_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_fraction_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/image_in_list_item_component.dart';
import 'package:challenge/ui/components/simple_components/small_container_in_list_item_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListItemParticipantComponent extends StatefulWidget {
  const ListItemParticipantComponent({
    super.key,
    this.onTap,
    required this.groupChallenge,
    required this.participant,
    required this.attempt,
  });

  final dynamic Function()? onTap;
  final GroupChallengeModel groupChallenge;
  final ParticipantModel participant;
  final AttemptModel attempt;

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
        isFailed: widget.attempt.isFailed(widget.groupChallenge),
        onTap: widget.onTap,
        initialProgress:
            widget.attempt.getCurrentPercentage(widget.groupChallenge),
        child: Row(
          children: [
            _position(context),
            Visibility(
              visible: widget.groupChallenge.isGroupChallenge(),
              child: const SpaceComponent(
                width: ListItemContainerComponent.standardPadding,
              ),
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

  _position(BuildContext context) {
    return Visibility(
      visible: widget.groupChallenge.isGroupChallenge(),
      child: ContainerInContainerComponent(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.symmetric(
            horizontal: ContainerInContainerComponent.standardPadding),
        height: SmallContainerInListItemComponent.height,
        child: Center(
          child: Text(
              '${widget.groupChallenge.getPositionOf(widget.participant.user.id)}',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Theme.of(context).colorScheme.tertiary)),
        ),
      ),
    );
  }

  _statusOrPercentage() {
    return widget.participant.isAccepted()
        ? widget.attempt.isInBacklog(widget.groupChallenge)
            ? ContainerInContainerComponent(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.symmetric(
                    horizontal:
                        ContainerInContainerComponent.standardPaddingSmall),
                height: SmallContainerInListItemComponent.height,
                child: Center(
                  child: Text('Accepted',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.tertiary)),
                ),
              )
            : ChallengeTotalPercentageComponent(
                attempt: widget.attempt, groupChallenge: widget.groupChallenge)
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
      visible: widget.groupChallenge.userId == widget.participant.user.id &&
          widget.groupChallenge.isGroupChallenge(),
      child: Row(
        children: [
          ContainerInContainerComponent(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.symmetric(
                horizontal: ContainerInContainerComponent.standardPaddingSmall),
            height: SmallContainerInListItemComponent.height,
            child: Center(
              child: Text('Admin',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.tertiary)),
            ),
          ),
          const SpaceComponent(
            width: CustomContainerComponent.standardPadding,
          ),
        ],
      ),
    );
  }

  _youContainer() {
    return Visibility(
      visible: widget.participant.user.id == _usersProvider.user.id &&
          widget.groupChallenge.isGroupChallenge(),
      child: Row(
        children: [
          ContainerInContainerComponent(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.symmetric(
                horizontal: ContainerInContainerComponent.standardPaddingSmall),
            height: SmallContainerInListItemComponent.height,
            child: Center(
              child: Text('You',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.tertiary)),
            ),
          ),
          const SpaceComponent(
            width: CustomContainerComponent.standardPadding,
          ),
        ],
      ),
    );
  }
}
