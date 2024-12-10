import 'package:challenge/enums/tab_item_enum.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/models/notification/progress_added_notification_model.dart';
import 'package:challenge/providers/notifications_provider.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/user/user_picture_min_component.dart';
import 'package:challenge/ui/pages/home/home_challenge_page.dart';
import 'package:challenge/ui/pages/home/leader_board_page.dart';
import 'package:challenge/ui/pages/home/repetition/repetition_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  late final notificationsProvider =
      Provider.of<NotificationsProvider>(context, listen: false);

  late final tabProvider = Provider.of<TabProvider>(context, listen: false);

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
    await notificationsProvider
        .deleteNotification(widget.progressAddedNotification.id);

    tabProvider.selectTab(TabItemEnum.home);
    var homeNavigator =
        tabProvider.navigatorKeys[TabItemEnum.home]!.currentState!;
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
            preTitle: 'Home',
          );
        },
      ),
    );

    homeNavigator.push(
      NoAnimationPageRouteComponent(
        builder: (context) {
          return LeaderBoardPage(
            groupChallenge: groupChallenge,
            preTitle: 'Home/${groupChallenge.title}',
          );
        },
      ),
    );

    homeNavigator.push(
      NoAnimationPageRouteComponent(
        builder: (context) {
          return RepetitionPage(
            groupChallenge: groupChallenge,
            participant: participant,
            attempt: participant.getLatestAttempt(),
            preTitle:
                'Home/${groupChallenge.title}/Leader Board/${participant.user.username}',
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
