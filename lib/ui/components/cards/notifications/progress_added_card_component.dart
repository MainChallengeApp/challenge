import 'package:challenge/enums/tab_item_enum.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/models/notification/progress_added_notification_model.dart';
import 'package:challenge/providers/notifications_provider.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/user/user_picture_min_component.dart';
import 'package:challenge/ui/pages/home/home_challenge_page.dart';
import 'package:challenge/ui/pages/home/ranking_page.dart';
import 'package:challenge/ui/pages/home/repetition/repetition_page.dart';
import 'package:flutter/material.dart';

class ProgressAddedCardComponent extends StatefulWidget {
  final ProgressAddedNotificationModel progressAddedNotification;

  const ProgressAddedCardComponent({
    super.key,
    required this.progressAddedNotification,
  });

  @override
  State<ProgressAddedCardComponent> createState() =>
      _ProgressAddedCardComponentState();
}

class _ProgressAddedCardComponentState
    extends State<ProgressAddedCardComponent> {
  bool isLoadingAcceptButton = false;

  final _notificationsProvider = getIt<NotificationsProvider>();
  final _tabProvider = getIt<TabProvider>();

  @override
  Widget build(BuildContext context) {
    return CardComponent(
      children: [
        SpaceColumnComponent(
            child: UserPictureMinComponent(
                userPictureUrl:
                    widget.progressAddedNotification.fromUser.pictureUrl)),
        SpaceColumnComponent(
            child: CustomContainerComponent(
                isHeightDynamic: true,
                child: Center(
                    child: Text(widget.progressAddedNotification.body,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium)))),
        const Expanded(child: SizedBox()),
        Row(
          children: [
            Expanded(
              child: CustomButtonComponent(
                text: 'View Progress',
                isLoading: isLoadingAcceptButton,
                isPrimaryButton: true,
                onTap: onTapAccept,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void onTapAccept() async {
    setState(() {
      isLoadingAcceptButton = true;
    });
    await _notificationsProvider
        .deleteNotification(widget.progressAddedNotification.id);

    _tabProvider.selectTab(TabItemEnum.home);
    var homeNavigator =
        _tabProvider.navigatorKeys[TabItemEnum.home]!.currentState!;
    homeNavigator.popUntil((route) => route.isFirst);
    GroupChallengeModel groupChallenge =
        widget.progressAddedNotification.groupChallenge;
    ParticipantModel participant = groupChallenge.participants.firstWhere(
        (participantEntry) =>
            participantEntry.user.id ==
            widget.progressAddedNotification.fromUser.id);
    homeNavigator.push(
      NoAnimationPageRouteComponent(
        builder: (context) {
          return HomeChallengePage(
            initialChallengeId: groupChallenge.id,
          );
        },
      ),
    );

    homeNavigator.push(
      NoAnimationPageRouteComponent(
        builder: (context) {
          return RankingPage(
            groupChallenge: groupChallenge,
          );
        },
      ),
    ).then((_) {
      _tabProvider.setBottomNavigationVisibility(true);
      if (mounted) {
        setState(() {});
      }
    });

    homeNavigator.push(
      NoAnimationPageRouteComponent(
        builder: (context) {
          return RepetitionPage(
            groupChallenge: groupChallenge,
            participant: participant,
            attempt: participant.getLatestAttempt(),
          );
        },
      ),
    );

    if (mounted) {
      setState(() {
        isLoadingAcceptButton = false;
      });
    }
  }
}
