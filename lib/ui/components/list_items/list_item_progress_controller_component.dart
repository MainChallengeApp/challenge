import 'dart:async';
import 'dart:math';

import 'package:challenge/models/challenge/progress_model.dart';
import 'package:challenge/services/util_service.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ListItemProgressControllerComponent extends StatefulWidget {
  final ProgressModel editProgress;
  final Function() progressListSetState;
  final Function(bool)? setIsKeyboardUp;

  const ListItemProgressControllerComponent(
      {super.key,
      required this.editProgress,
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
          text: UtilService.doubleAsIntString(widget.editProgress.progress));

  @override
  Widget build(BuildContext context) {
    return ListItemContainerComponent(
        padding: const EdgeInsets.all(0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [minusOne(), plusOne(), hundredPercent(), textInput()],
        ));
  }

  textInput() {
    return Expanded(
        flex: 2,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: progressTextEditingController,
            style: Theme.of(context).textTheme.textInputSmall,
            textAlign: TextAlign.center,
            decoration: InputDecoration.collapsed(
                hintText: '0',
                hintStyle: Theme.of(context).textTheme.textInputHintSmall),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(
                  RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
              TextInputFormatter.withFunction(
                (oldValue, newValue) => newValue.copyWith(
                  text: newValue.text.replaceAll(',', '.'),
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                double number = 0;
                if (value.endsWith('.')) {
                  number = double.parse(value.split('.')[0]);
                  widget.editProgress.progress = number;
                } else if (value == '') {
                  widget.editProgress.progress = 0;
                } else {
                  number = double.parse(value);
                  widget.editProgress.progress = number;
                }
              });
              widget.progressListSetState();
            },
          ),
        ));
  }

  Expanded hundredPercent() {
    return Expanded(
        flex: 1,
        child: TapContainerComponent(
            onTap: () => setState(() {
                  widget.editProgress.progress = widget.editProgress.goal;
                  widget.progressListSetState();
                  progressTextEditingController.text =
                      UtilService.doubleAsIntString(
                          widget.editProgress.progress);
                }),
            borderWidth: 0,
            borderColor: Colors.transparent,
            borderRadius: ListItemContainerComponent.standardBorderRadius - 1,
            margin: const EdgeInsets.all(0),
            height: double.infinity,
            child: Center(
              child: Text(
                '100%',
                style: Theme.of(context).textTheme.bodyMediumBlack,
              ),
            )));
  }

  Expanded plusOne() {
    return Expanded(
        flex: 1,
        child: TapContainerComponent(
            onLongPress: () {
              timer = Timer.periodic(
                  Duration(
                      milliseconds: (200 * log(widget.editProgress.goal)) ~/
                          widget.editProgress.goal), (t) {
                setState(() {
                  if (widget.editProgress.progress + 1 <=
                      widget.editProgress.goal) {
                    addOneToProgress();
                  } else {
                    widget.editProgress.progress = widget.editProgress.goal;
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
            borderWidth: 0,
            borderColor: Colors.transparent,
            borderRadius: ListItemContainerComponent.standardBorderRadius - 1,
            margin: const EdgeInsets.all(0),
            height: double.infinity,
            child: Center(
              child: Text('+1',
                  style: Theme.of(context).textTheme.bodyMediumBlack),
            )));
  }

  Expanded minusOne() {
    return Expanded(
        flex: 1,
        child: TapContainerComponent(
            onLongPress: () {
              if (widget.editProgress.goal == 0) {
                return;
              }
              timer = Timer.periodic(
                  Duration(
                      milliseconds: (((200 * log(widget.editProgress.goal)) ~/
                          widget.editProgress.goal))), (t) {
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
            borderWidth: 0,
            borderColor: Colors.transparent,
            borderRadius: ListItemContainerComponent.standardBorderRadius - 1,
            margin: const EdgeInsets.all(0),
            height: double.infinity,
            child: Center(
              child: Text('-1',
                  style: Theme.of(context).textTheme.bodyMediumBlack),
            )));
  }

  void addOneToProgress() {
    widget.editProgress.progress += 1;
    widget.progressListSetState();
    progressTextEditingController.text =
        UtilService.doubleAsIntString(widget.editProgress.progress);
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
        UtilService.doubleAsIntString(widget.editProgress.progress);
  }
}
