import 'package:challenge/models/notification/group_challenge_request_notification_model.dart';
import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/challenge/acceptance_criteria_component.dart';
import 'package:challenge/ui/components/challenge/description_component.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/components/user/user_picture_min_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupChallengeRequestCard extends StatefulWidget {
  final GroupChallengeRequestNotificationModel
      groupChallengeRequestNotification;

  const GroupChallengeRequestCard({
    super.key,
    required this.groupChallengeRequestNotification,
  });

  @override
  State<GroupChallengeRequestCard> createState() =>
      _GroupChallengeRequestCardState();
}

class _GroupChallengeRequestCardState extends State<GroupChallengeRequestCard> {
  bool _isLoadingAcceptButton = false;
  bool _isLoadingDeclineButton = false;
  bool _isDescriptionExpanded = false;

  late final _groupChallengeProvider =
      Provider.of<GroupChallengesProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return CardComponent(
      children: [
        SpaceColumnComponent(
            child: UserPictureMinComponent(
                userPictureUrl: widget
                    .groupChallengeRequestNotification.fromUser.pictureUrl)),
        SpaceColumnComponent(
            child: CustomContainerComponent(
                isHeightDynamic: true,
                child: Center(
                    child: Text(
                        '${widget.groupChallengeRequestNotification.fromUser.username} ${widget.groupChallengeRequestNotification.body}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium)))),
        _description(),
        Visibility(
          visible: !_isDescriptionExpanded,
          child: SpaceColumnComponent(
              child: AcceptanceCriteriaComponent(
                  groupChallenge:
                      widget.groupChallengeRequestNotification.groupChallenge)),
        ),
        Visibility(
            visible: !_isDescriptionExpanded,
            child: const Expanded(child: SizedBox())),
        actionButtons(),
      ],
    );
  }

  _description() {
    DescriptionComponent descriptionComponent = DescriptionComponent(
      challenge: widget.groupChallengeRequestNotification.groupChallenge,
      isDescriptionExpanded: _isDescriptionExpanded,
      onTap: () => setState(() {
        _isDescriptionExpanded = !_isDescriptionExpanded;
      }),
    );
    return _isDescriptionExpanded
        ? Expanded(
            child: Column(
            children: [
              Expanded(child: descriptionComponent),
              widget.groupChallengeRequestNotification.groupChallenge
                      .description.isNotEmpty
                  ? const SpaceComponent()
                  : Container()
            ],
          ))
        : Column(
            children: [
              descriptionComponent,
              widget.groupChallengeRequestNotification.groupChallenge
                      .description.isNotEmpty
                  ? const SpaceComponent()
                  : Container()
            ],
          );
  }

  Row actionButtons() {
    return Row(
      children: [
        Expanded(
          child: CustomButtonComponent(
            text: 'Decline',
            isLoading: _isLoadingDeclineButton,
            onTap: onTapDecline,
          ),
        ),
        const SpaceComponent(),
        Expanded(
          child: CustomButtonComponent(
            text: 'Accept',
            isLoading: _isLoadingAcceptButton,
            isPrimaryButton: true,
            onTap: onTapAccept,
          ),
        ),
      ],
    );
  }

  void onTapAccept() async {
    setState(() {
      _isLoadingAcceptButton = true;
    });
    await _groupChallengeProvider
        .acceptChallengeRequest(widget.groupChallengeRequestNotification);
    if (mounted) {
      setState(() {
        _isLoadingAcceptButton = false;
      });
    }
  }

  void onTapDecline() async {
    setState(() {
      _isLoadingDeclineButton = true;
    });
    await _groupChallengeProvider
        .declineChallengeRequest(widget.groupChallengeRequestNotification);
    if (mounted) {
      setState(() {
        _isLoadingDeclineButton = false;
      });
    }
  }
}
