import 'package:challenge/globals.dart';
import 'package:challenge/models/acceptance_criteria_model.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:challenge/pages/components/simple_components/custom_container_component.dart';
import 'package:challenge/utils/design_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountAndUnitComponent extends StatefulWidget {
  final ChallengeModel challenge;
  final Function(bool)? setIsKeyboardUp;

  const AmountAndUnitComponent(
      {super.key, required this.challenge, this.setIsKeyboardUp});

  @override
  State<AmountAndUnitComponent> createState() => _AmountAndUnitComponentState();
}

class _AmountAndUnitComponentState extends State<AmountAndUnitComponent> {
  TextEditingController amountTextEditingController = TextEditingController();
  TextEditingController unitTextEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    amountTextEditingController.text = DesignUtil.doubleAsInt(
        widget.challenge.acceptanceCriterias.first.amount);
    unitTextEditingController.text =
        widget.challenge.acceptanceCriterias.first.unit.toString();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.challenge.acceptanceCriterias.isEmpty) return Container();
    AcceptanceCriteriaModel acceptanceCriteria =
        widget.challenge.acceptanceCriterias.first;
    return Row(
      children: [
        Expanded(
            child: CustomContainerComponent(
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextField(
              style: const TextStyle(fontSize: basicFontSize),
              textAlign: TextAlign.end,
              controller:
                  amountTextEditingController, // somehow TextEditingController()..text = doesnt work anymore!?
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
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
                    acceptanceCriteria.amount = number;
                  } else if (value == '') {
                    acceptanceCriteria.amount = 0;
                  } else {
                    number = double.parse(value);
                    acceptanceCriteria.amount = number;
                  }
                });
              },
              onTap: () => widget.setIsKeyboardUp ?? (true),
              decoration: const InputDecoration.collapsed(hintText: '0'),
            ),
          ),
        )),
        const SizedBox(
          width: 16,
        ),
        Expanded(
            flex: 2,
            child: CustomContainerComponent(
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextField(
                  style: const TextStyle(fontSize: basicFontSize),
                  controller: unitTextEditingController,
                  onChanged: (value) {
                    acceptanceCriteria.unit = value;
                  },
                  onTap: () => widget.setIsKeyboardUp ?? (true),
                  onSubmitted: (_) => widget.setIsKeyboardUp ?? (false),
                  onEditingComplete: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    widget.setIsKeyboardUp ?? (false);
                  },
                  decoration: const InputDecoration.collapsed(hintText: 'Unit'),
                ),
              ),
            )),
      ],
    );
  }
}
