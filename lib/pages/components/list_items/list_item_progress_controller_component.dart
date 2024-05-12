import 'dart:async';
import 'dart:math';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:challenge/models/progress_model.dart';
import 'package:challenge/pages/components/list_items/list_item_container_component.dart';
import 'package:challenge/utils/design_util.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ListItemProgressControllerComponent extends StatefulWidget {
  final ProgressModel editProgress;
  final ChallengeModel challenge;
  final Function() progressListSetState;
  final Function(bool)? setIsKeyboardUp;

  const ListItemProgressControllerComponent(
      {super.key,
      required this.editProgress,
      required this.challenge,
      required this.progressListSetState,
      this.setIsKeyboardUp});

  @override
  State<ListItemProgressControllerComponent> createState() =>
      _ListItemProgressControllerComponentState();
}

class _ListItemProgressControllerComponentState
    extends State<ListItemProgressControllerComponent> {
  late BuildContext context2;

  Timer? timer;

  late TextEditingController progressTextEditingController =
      TextEditingController(
          text: DesignUtil.doubleAsIntString(widget.editProgress.progress));

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: ListItemContainerComponent.standardHeight,
      margin: const EdgeInsets.only(left: 20, right: 20),
      padding: const EdgeInsets.only(
          left: ListItemContainerComponent.standardPadding,
          right: ListItemContainerComponent.standardPadding),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1, color: themeColor5),
          borderRadius: const BorderRadius.all(Radius.circular(
              ListItemContainerComponent.standardBorderRadius))),
      child: setProgressButtons(),
    );
  }

  Widget setProgressButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onLongPress: () {
              if (widget.challenge.acceptanceCriteria.amount == 0) {
                return;
              }
              timer = Timer.periodic(
                  Duration(
                      milliseconds: (((200 *
                              log(widget
                                  .challenge.acceptanceCriteria.amount)) ~/
                          widget.challenge.acceptanceCriteria.amount))), (t) {
                setState(() {
                  subOneFromProgress();
                });
              });
            },
            // onLongPressDown: (details) {
            //   isSubOnePressed = true;
            //   if (isSubOnePressed) {
            //     if (widget.challenge.acceptanceCriteria.amount == 0) {
            //       return;
            //     }
            //     int amount = 1 ~/ widget.challenge.acceptanceCriteria.amount;
            //     if (amount == 0) {
            //       amount = 1;
            //     }
            //     timer = Timer.periodic(
            //         Duration(milliseconds: (200 * log(amount).toInt())), (t) {
            //       setState(() {
            //         subOneFromProgress();
            //       });
            //     });
            //   }
            // },
            onLongPressUp: () {
              timer?.cancel();
            },
            onLongPressCancel: () {
              timer?.cancel();
            },
            onTap: () => setState(() {
              subOneFromProgress();
            }),
            child: Container(
              color: Colors.transparent,
              child: const Center(
                child: Text('-1'),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onLongPress: () {
              timer = Timer.periodic(
                  Duration(
                      milliseconds: (200 *
                              log(widget
                                  .challenge.acceptanceCriteria.amount)) ~/
                          widget.challenge.acceptanceCriteria.amount), (t) {
                setState(() {
                  if (widget.editProgress.progress + 1 <=
                      widget.challenge.acceptanceCriteria.amount) {
                    addOneToProgress();
                  } else {
                    widget.editProgress.progress =
                        widget.challenge.acceptanceCriteria.amount;
                  }
                });
              });
            },
            onLongPressUp: () {
              timer?.cancel();
            },
            onLongPressCancel: () {
              timer?.cancel();
            },
            onTap: () => setState(() {
              addOneToProgress();
            }),
            child: Container(
              color: Colors.transparent,
              child: const Center(
                child: Text('+1'),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            flex: 1,
            child: GestureDetector(
                onTap: () => setState(() {
                      widget.editProgress.progress =
                          widget.challenge.acceptanceCriteria.amount;
                      widget.progressListSetState();
                      progressTextEditingController.text =
                          DesignUtil.doubleAsIntString(
                              widget.editProgress.progress);
                    }),
                child: Container(
                  color: Colors.transparent,
                  child: const Center(
                    child: Text('100%'),
                  ),
                ))),
      ],
    );
  }

  void addOneToProgress() {
    widget.editProgress.progress += 1;
    widget.progressListSetState();
    progressTextEditingController.text =
        DesignUtil.doubleAsIntString(widget.editProgress.progress);
  }

  void subOneFromProgress() {
    double newProgress = widget.editProgress.progress - 1;
    if (newProgress >= 0) {
      widget.editProgress.progress = newProgress;
    } else {
      widget.editProgress.progress = 0;
    }
    widget.progressListSetState();
    progressTextEditingController.text =
        DesignUtil.doubleAsIntString(widget.editProgress.progress);
  }
}
