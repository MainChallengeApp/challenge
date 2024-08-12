import 'dart:async';
import 'dart:math';

import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/progress_model.dart';
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
    return ListItemContainerComponent(
        padding: const EdgeInsets.all(0), child: setProgressButtons());
  }

  Widget setProgressButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
            flex: 1,
            child: TapContainerComponent(
                onLongPress: () {
                  if (widget.challenge.acceptanceCriteria.amount == 0) {
                    return;
                  }
                  timer = Timer.periodic(
                      Duration(
                          milliseconds: (((200 *
                                  log(widget
                                      .challenge.acceptanceCriteria.amount)) ~/
                              widget.challenge.acceptanceCriteria.amount))),
                      (t) {
                    setState(() {
                      subOneFromProgress();
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
                      subOneFromProgress();
                    }),
                borderWith: 0,
                borderColor: Colors.transparent,
                borderRadius:
                    ListItemContainerComponent.standardBorderRadius - 1,
                margin: const EdgeInsets.all(0),
                height: double.infinity,
                child: const Center(
                  child: Text('-1'),
                ))),
        Expanded(
            flex: 1,
            child: TapContainerComponent(
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
                borderWith: 0,
                borderColor: Colors.transparent,
                borderRadius:
                    ListItemContainerComponent.standardBorderRadius - 1,
                margin: const EdgeInsets.all(0),
                height: double.infinity,
                child: const Center(
                  child: Text('+1'),
                ))),
        Expanded(
            flex: 1,
            child: TapContainerComponent(
                onTap: () => setState(() {
                      widget.editProgress.progress =
                          widget.challenge.acceptanceCriteria.amount;
                      widget.progressListSetState();
                      progressTextEditingController.text =
                          DesignUtil.doubleAsIntString(
                              widget.editProgress.progress);
                    }),
                borderWith: 0,
                borderColor: Colors.transparent,
                borderRadius:
                    ListItemContainerComponent.standardBorderRadius - 1,
                margin: const EdgeInsets.all(0),
                height: double.infinity,
                child: const Center(
                  child: Text('100%'),
                )))
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
