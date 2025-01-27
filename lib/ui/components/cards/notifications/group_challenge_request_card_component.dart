import 'package:challenge/enums/tab_item_enum.dart';
import 'package:challenge/models/notification/group_challenge_request_notification_model.dart';
import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/challenge/acceptance_criteria_component.dart';
import 'package:challenge/ui/components/challenge/description_component.dart';
import 'package:challenge/ui/components/challenge/start_and_end_date_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/components/user/user_picture_min_component.dart';
import 'package:challenge/ui/pages/home/home_challenge_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupChallengeRequestCardComponent extends StatefulWidget {
  final GroupChallengeRequestNotificationModel
      groupChallengeRequestNotification;

  const GroupChallengeRequestCardComponent({
    super.key,
    required this.groupChallengeRequestNotification,
  });

  @override
  State<GroupChallengeRequestCardComponent> createState() =>
      _GroupChallengeRequestCardComponentState();
}

class _GroupChallengeRequestCardComponentState
    extends State<GroupChallengeRequestCardComponent> {
  bool _isLoadingAcceptButton = false;
  bool _isLoadingDeclineButton = false;
  bool _isDescriptionExpanded = false;

  late final _groupChallengeProvider =
      Provider.of<GroupChallengesProvider>(context, listen: false);
  final _tabProvider = getIt<TabProvider>();

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
                    child: Text(widget.groupChallengeRequestNotification.body,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium)))),
        _description(),
        Visibility(
            visible: !_isDescriptionExpanded,
            child: SpaceColumnComponent(
              child: StartAndEndDateComponent.challenge(
                editChallenge:
                    widget.groupChallengeRequestNotification.groupChallenge,
              ),
            )),
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
    _tabProvider.selectTab(TabItemEnum.home);
    final homeNavigator =
        _tabProvider.navigatorKeys[TabItemEnum.home]!.currentState!;
    homeNavigator.popUntil((route) => route.isFirst);
    homeNavigator.push(NoAnimationPageRouteComponent(
      builder: (context) {
        return HomeChallengePage(
          initialChallengeId:
              widget.groupChallengeRequestNotification.groupChallenge.id,
        );
      },
    ));
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
