// Currently not used in v1.0.0
// Refactor/Clean when used...
import 'package:challenge/components/navigation/app_bar_component.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:flutter/services.dart';

import 'package:challenge/models/acceptance_criteria_model.dart';

class AddAcceptanceCriteriaPage extends StatefulWidget {
  const AddAcceptanceCriteriaPage(
      {super.key,
      required this.preTitle,
      required this.challenge,
      required this.acceptanceCriteria,
      required this.acceptanceCriteriaIndex,
      this.areButtonsVisible = true});
  final String preTitle;
  final ChallengeModel challenge;
  final AcceptanceCriteriaModel acceptanceCriteria;
  final int? acceptanceCriteriaIndex;
  final bool areButtonsVisible;

  @override
  State<AddAcceptanceCriteriaPage> createState() =>
      _AddAcceptanceCriteriaPageState();
}

class _AddAcceptanceCriteriaPageState extends State<AddAcceptanceCriteriaPage> {
  @override
  Widget build(BuildContext context) {
    String title = widget.acceptanceCriteriaIndex == null
        ? 'Add Acceptance Criteria'
        : widget.acceptanceCriteria.title;
    return Scaffold(
      appBar: AppBarComponent(preTitle: widget.preTitle, titleText: title),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(bottom: 16, left: 20, right: 20),
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            height: 120 + 8 * 64 + 2,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
                borderRadius: const BorderRadius.all(Radius.circular(24))),
            child: Column(
              children: [
                activityText(),
                amountAndUnit(),
                const SizedBox(
                  height: 32,
                ),
                frequence(),
                // const SizedBox(
                //   height: 32,
                // ),
                // tracking(),
                const Expanded(child: SizedBox()),
                widget.areButtonsVisible ? buttons() : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onTapDeleteAcceptanceCriteria,
            child: Container(
              height: 55,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
                  borderRadius: const BorderRadius.all(Radius.circular(16))),
              child: const Center(
                  child: Text(
                'Delete',
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
              )),
            ),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: GestureDetector(
            onTap: onTapSaveAcceptanceCriteria,
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                  color: themeColor2,
                  border: Border.all(
                      width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
                  borderRadius: const BorderRadius.all(Radius.circular(16))),
              child: const Center(
                  child: Text(
                'Save',
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
              )),
            ),
          ),
        ),
      ],
    );
  }

  singleAcceptanceCriteria(int index) {
    return Stack(
      children: [
        FractionallySizedBox(
          widthFactor: widget.challenge.acceptanceCriterias[index]
                      .calcProgressRatio() >
                  1
              ? 1
              : widget.challenge.acceptanceCriterias[index].calcProgressRatio(),
          heightFactor: 1,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(16))),
          ),
        ),
        Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white.withAlpha(170),
                border: Border.all(
                    width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
                borderRadius: const BorderRadius.all(Radius.circular(16))),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      color: themeColor4,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Text(
                    '${widget.challenge.acceptanceCriterias[index].title} ${widget.challenge.acceptanceCriterias[index].amount} ${widget.challenge.acceptanceCriterias[index].unit}',
                    style: const TextStyle(fontSize: 12, color: themeColor3),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      color: themeColor4,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Text(
                    widget.challenge.acceptanceCriterias[index].frequence,
                    style: const TextStyle(fontSize: 12, color: themeColor3),
                  ),
                ),
                Expanded(child: Container()),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      color: themeColor4,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Icon(getIconData(index), color: themeColor3, size: 14),
                ),
              ],
            ))
      ],
    );
  }

  Container acceptanceCriteriaButton() {
    // TODO: Acceptance criteria list with first listitem is add acceptance criteria
    return standardContainer(
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.only(right: 10),
            decoration: const BoxDecoration(
                color: themeColor4,
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: const Center(
                child: Icon(
              Icons.add_rounded,
              color: themeColor3,
            )),
          ),
          const SizedBox(
            width: 200,
            height: 40,
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Add Acceptance Criteria')),
          ),
          const Expanded(
            child: SizedBox(),
          ),
          const Icon(
            Icons.chevron_right_outlined,
            color: themeColor3,
          )
        ],
      ),
    );
  }

  List<String> list2 = <String>['camera'];
  tracking() {
    return standardContainer(
        child: DropdownButton<String>(
      isExpanded: true,
      value: widget.acceptanceCriteria.tracking == ''
          ? null
          : widget.acceptanceCriteria.tracking,
      icon: const Icon(Icons.expand_more),
      style: const TextStyle(color: Colors.black),
      hint: Text('Tracking'),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          widget.acceptanceCriteria.tracking = value!;
        });
      },
      items: list2.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    ));
  }

  List<String> list = <String>['once', 'daily', 'weekly', 'monthly'];
  frequence() {
    return standardContainer(
        child: DropdownButton<String>(
      isExpanded: true,
      value: widget.acceptanceCriteria.frequence == ''
          ? null
          : widget.acceptanceCriteria.frequence,
      icon: const Icon(Icons.expand_more),
      style: const TextStyle(color: Colors.black),
      hint: Text('Frequence'),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          widget.acceptanceCriteria.frequence = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    ));
  }

  amountAndUnit() {
    return Row(
      children: [
        Expanded(
            child: standardContainer(
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextField(
              controller: TextEditingController()
                ..text = widget.acceptanceCriteria.amount == 0
                    ? ''
                    : widget.acceptanceCriteria.amount.toString(),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                if (value.endsWith('.')) {
                  widget.acceptanceCriteria.amount =
                      double.parse(value.split('.')[0]);
                } else if (value == '') {
                  widget.acceptanceCriteria.amount = 0;
                } else {
                  widget.acceptanceCriteria.amount = double.parse(value);
                }
              },
              decoration: InputDecoration.collapsed(hintText: 'Amount'),
            ),
          ),
        )),
        const SizedBox(
          width: 16,
        ),
        Expanded(
            child: standardContainer(
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextField(
              controller: TextEditingController()
                ..text = widget.acceptanceCriteria.unit,
              onChanged: (value) {
                widget.acceptanceCriteria.unit = value;
              },
              decoration: const InputDecoration.collapsed(hintText: 'Unit'),
            ),
          ),
        )),
      ],
    );
  }

  Container activityText() {
    return standardContainer(
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextField(
          onChanged: (value) => widget.acceptanceCriteria.title = value,
          decoration: const InputDecoration.collapsed(hintText: 'Activity'),
          controller: TextEditingController()
            ..text = widget.acceptanceCriteria.title,
        ),
      ),
    );
  }

  standardContainer({required Widget child, double heightFactor = 1}) {
    return Container(
      // width: double.infinity,
      height: 55 * heightFactor,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      child: child,
    );
  }

  int selectedAcceptanceCriteria = 0;

  acceptanceCriteria() {
    return SizedBox(
        height: 71,
        child: PageView.builder(
          itemCount: widget.challenge.acceptanceCriterias.length,
          controller: PageController(viewportFraction: 1),
          onPageChanged: (int index) =>
              setState(() => selectedAcceptanceCriteria = index),
          itemBuilder: (_, i) {
            return Transform.scale(
              scale: i == selectedAcceptanceCriteria ? 1 : 0.9,
              child: singleAcceptanceCriteria(i),
            );
          },
        ));
  }

  IconData getIconData(int index) {
    if (widget.challenge.acceptanceCriterias[index].tracking == 'camera') {
      return Icons.camera_alt_outlined;
    } else if (widget.challenge.acceptanceCriterias[index].tracking == 'gps') {
      return Icons.gps_not_fixed;
    } else if (widget.challenge.acceptanceCriterias[index].tracking ==
        'notes') {
      return Icons.notes;
    } else if (widget.challenge.acceptanceCriterias[index].tracking ==
        'numbers') {
      return Icons.numbers;
    } else {
      return Icons.not_accessible;
    }
  }

  dots() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
            widget.challenge.acceptanceCriterias.length,
            (index) => Padding(
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 10, bottom: 23),
                  child: Icon(
                    Icons.fiber_manual_record,
                    size: 6,
                    color: index == selectedAcceptanceCriteria
                        ? themeColor3
                        : themeColor3.withAlpha(100),
                  ),
                )));
  }

  void onTapSaveAcceptanceCriteria() {
    try {
      if (widget.acceptanceCriteriaIndex == null) {
        widget.challenge.acceptanceCriterias
            .insert(0, widget.acceptanceCriteria);
      } else {
        widget.challenge.acceptanceCriterias[widget.acceptanceCriteriaIndex!] =
            widget.acceptanceCriteria;
      }

      Navigator.pop(context);
    } catch (e) {
      // Todo: Fehlerbehebung
      print(e);
    }
  }

  void onTapDeleteAcceptanceCriteria() {
    if (widget.acceptanceCriteriaIndex != null) {
      widget.challenge.acceptanceCriterias
          .removeAt(widget.acceptanceCriteriaIndex!);
    }
    Navigator.pop(context);
  }
}
