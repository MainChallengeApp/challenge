import 'dart:math';

import 'package:challenge/enums/challenge_status_enum.dart';
import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/user_challenge_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/util_service.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_text_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AcceptanceCriteriaComponent extends StatefulWidget {
  final void Function() onTap;
  final ChallengeModel challenge;
  final void Function() onTapNewProgress;

  const AcceptanceCriteriaComponent(
      {super.key,
      required this.onTap,
      required this.challenge,
      required this.onTapNewProgress});

  @override
  State<AcceptanceCriteriaComponent> createState() =>
      _AcceptanceCriteriaComponentState();
}

class _AcceptanceCriteriaComponentState
    extends State<AcceptanceCriteriaComponent> {
  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);

  late UserChallengeModel? userChallenge =
      widget.challenge is UserChallengeModel
          ? widget.challenge as UserChallengeModel
          : widget.challenge is GroupChallengeModel
              ? (widget.challenge as GroupChallengeModel)
                  .toUserChallengeModel(usersProvider.user.id)
              : null;

  @override
  Widget build(BuildContext context) {
    if (userChallenge == null) {
      return Container();
    }
    return SizedBox(
      height: 55,
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: !userChallenge!.isInProgress()
                ? min(userChallenge!.getCurrentPercentage(), 1)
                : min(
                    userChallenge!.getCurrentRepetitionProgressPercentage(), 1),
            heightFactor: 1,
            child: Container(
              // width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: userChallenge!.status == ChallengeStatusEnum.failed
                      ? Theme.of(context).colorScheme.red
                      : Theme.of(context).colorScheme.green,
                  borderRadius: const BorderRadius.all(Radius.circular(
                      CustomContainerComponent.standardRadius))),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.white,
                    width: 10,
                    strokeAlign: BorderSide.strokeAlignOutside),
                borderRadius: const BorderRadius.all(
                    Radius.circular(CustomContainerComponent.standardRadius))),
          ),
          TapContainerComponent(
              onTap: widget.onTap,
              backgroundColor: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          repetition(),
                          repetitionProgressAbsolute(),
                        ],
                      ),
                    ),
                  ),
                  newProgress()
                ],
              ))
        ],
      ),
    );
  }

  Visibility newProgress() {
    return Visibility(
      visible: userChallenge!.isInProgress(),
      child: GestureDetector(
        onTap: widget.onTapNewProgress,
        child: ContainerInContainerComponent(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            margin: const EdgeInsets.only(left: 10),
            color: Colors.white,
            border: Border.all(
                color: Theme.of(context).colorScheme.themeColor5, width: 1),
            child: Center(
              child: Icon(
                IconEnum.newChallenge.icon,
                size: 20,
                color: Colors.black,
              ),
            )),
      ),
    );
  }

  repetition() {
    return (userChallenge!.frequency.amount == 1 &&
            userChallenge!.frequency.type == FrequencyTypeEnum.time)
        ? Container()
        : userChallenge!.isInBacklog()
            ? ContainerInContainerTextComponent(
                text:
                    '${userChallenge!.frequency.amount ?? '∞'} ${userChallenge!.frequency.typeToString()}')
            : ContainerInContainerTextComponent(
                text:
                    '${userChallenge!.getCurrentRepetitionNumber()}/${userChallenge!.frequency.amount ?? '∞'} ${userChallenge!.frequency.typeToString()}');
  }

  repetitionProgressAbsolute() {
    return userChallenge!.acceptanceCriteria.unit != '' ||
            userChallenge!.acceptanceCriteria.amount != 0
        ? userChallenge!.isInProgress() ||
                (userChallenge!.frequency.amount != null &&
                        userChallenge!.frequency.amount! == 1) &&
                    !userChallenge!.isInBacklog()
            ? ContainerInContainerTextComponent(
                text:
                    '${UtilService.doubleAsIntString(userChallenge!.getCurrentRepetitionProgressAbsolute())}/${UtilService.doubleAsIntString(userChallenge!.acceptanceCriteria.amount)} ${userChallenge!.acceptanceCriteria.unit}')
            : ContainerInContainerTextComponent(
                text:
                    '${UtilService.doubleAsIntString(userChallenge!.acceptanceCriteria.amount)} ${userChallenge!.acceptanceCriteria.unit}')
        : Container();
  }
}
