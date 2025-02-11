import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/challenge/challenge_total_percentage_component.dart';
import 'package:challenge/ui/components/challenge/group_challenge_icon_component.dart';
import 'package:challenge/ui/components/list_items/list_item_image_child_component.dart';
import 'package:challenge/ui/components/simple_components/app_icon_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ListItemChallengeSmallComponent extends StatefulWidget {
  const ListItemChallengeSmallComponent({
    super.key,
    required this.onTap,
    required this.challenge,
    this.attempt,
    this.isSearch = false,
    this.onTapDeleteChallenge,
    this.participant,
    this.onTapEditChallenge,
  });

  final dynamic Function() onTap;
  final ChallengeModel challenge;
  final ParticipantModel? participant;
  final bool isSearch;
  final AttemptModel? attempt;
  final void Function()? onTapDeleteChallenge;
  final void Function()? onTapEditChallenge;

  @override
  State<ListItemChallengeSmallComponent> createState() =>
      _ListItemChallengeSmallComponentState();
}

class _ListItemChallengeSmallComponentState
    extends State<ListItemChallengeSmallComponent> {
  final mediaService = MediaService();

  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return ListItemImageChildComponent(
        url: widget.challenge.thumbnail?.url ?? AppIconComponent.path,
        endActionPane: endActionPane,
        onTap: widget.onTap,
        scale: widget.challenge.thumbnail?.scale ?? AppIconComponent.scale,
        isBackgroundBlurred:
            widget.challenge.thumbnail?.isBackgroundBlurred ?? false,
        fit: widget.challenge.thumbnail?.fit.fit,
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.challenge.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            _groupChallengeIcon(),
            _percentageDone()
          ],
        ));
  }

  _percentageDone() {
    return Visibility(
        visible: widget.attempt != null &&
            !widget.attempt!
                .isInBacklog(widget.challenge as GroupChallengeModel),
        child: Padding(
          padding: const EdgeInsets.only(
              left: CustomContainerComponent.standardPadding),
          child:
              widget.attempt == null && widget.challenge is! GroupChallengeModel
                  ? Container()
                  : ChallengeTotalPercentageComponent(
                      groupChallenge: widget.challenge as GroupChallengeModel,
                      attempt: widget.attempt!,
                    ),
        ));
  }

  ActionPane? endActionPane(Function closeSlidable) {
    return widget.isSearch
        ? null
        : ActionPane(
            extentRatio: 0.44,
            motion: const ScrollMotion(),
            // dismissible: DismissiblePane(
            //   onDismissed: () {
            //     log('delete');
            //   },
            // ),
            children: [
                editSlider(closeSlidable),
                const SpaceComponent(
                  width: 20,
                ),
                deleteSlider(closeSlidable),
                const SpaceComponent(
                  width: 20,
                )
              ]);
  }

  deleteSlider(Function closeSlidable) {
    return Expanded(
      child: TapContainerComponent(
        height: double.infinity,
        borderRadius: 24,
        onTap: () async {
          await closeSlidable();
          widget.onTapDeleteChallenge?.call();
        },
        child: Center(
            child: Icon(
          IconEnum.delete.icon,
          color: Theme.of(context).colorScheme.red,
        )),
      ),
    );
  }

  _groupChallengeIcon() {
    if (widget.challenge is! GroupChallengeModel) return Container();
    return Visibility(
        visible: widget.challenge is GroupChallengeModel &&
            (widget.challenge as GroupChallengeModel).participants.length > 1,
        child: GroupChallengeIconComponent(
            groupChallenge: widget.challenge as GroupChallengeModel,
            participant: widget.participant));
  }

  editSlider(Function closeSlidable) {
    return Expanded(
      child: TapContainerComponent(
        height: double.infinity,
        borderRadius: 24,
        onTap: () async {
          await closeSlidable();
          widget.onTapEditChallenge?.call();
        },
        child: Center(
            child: Icon(
          IconEnum.edit.icon,
          color: Theme.of(context).colorScheme.tertiary,
        )),
      ),
    );
  }
}
