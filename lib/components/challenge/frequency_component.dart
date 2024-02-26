import 'package:challenge/components/simple_components/custom_container_component.dart';
import 'package:challenge/components/simple_components/space_component.dart';
import 'package:challenge/enums/frequence_type_enum.dart.dart';
import 'package:challenge/models/acceptance_criteria_model.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FrequencyComponent extends StatefulWidget {
  final ChallengeModel challenge;
  final Function? setIsKeyboardUp;

  const FrequencyComponent(
      {super.key, required this.challenge, this.setIsKeyboardUp});

  @override
  State<FrequencyComponent> createState() => _FrequencyComponentState();
}

class _FrequencyComponentState extends State<FrequencyComponent> {
  TextEditingController frequenceAmountTextEditingController =
      TextEditingController();

  bool isKeyboardUp = false;

  @override
  Widget build(BuildContext context) {
    AcceptanceCriteriaModel acceptanceCriteria =
        widget.challenge.acceptanceCriterias[0];
    return acceptanceCriteria.frequence.type == FrequenceTypeEnum.time
        ? timeFrequence(acceptanceCriteria)
        : acceptanceCriteria.frequence.type == FrequenceTypeEnum.daily
            ? dayFrequence(acceptanceCriteria)
            : frequenceDropDown(acceptanceCriteria);
  }

  CustomContainerComponent frequenceDropDown(
      AcceptanceCriteriaModel acceptanceCriteria) {
    Map<FrequenceTypeEnum, String> frequenceMap = {
      FrequenceTypeEnum.time: 'Time',
      FrequenceTypeEnum.daily: 'Day',
    };

    return CustomContainerComponent(
        child: DropdownButton<String>(
      borderRadius: BorderRadius.circular(16),
      isExpanded: true,
      underline: Container(),
      value: acceptanceCriteria.frequence.type.toString().split('.')[1],
      icon: const Icon(Icons.expand_more),
      style: const TextStyle(color: Colors.black),
      hint: const Text('Frequence'),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          acceptanceCriteria.frequence.type = FrequenceTypeEnum.factory(value!);
        });
      },
      items: frequenceMap.entries.map((e) {
        return DropdownMenuItem<String>(
            value: e.key.toString2(),
            child: Text(acceptanceCriteria.frequence.amount != 1
                ? '${e.value}s'
                : e.value));
      }).toList(),
    ));
  }

  timeFrequence(AcceptanceCriteriaModel acceptanceCriteria) {
    return Row(
      children: [
        frequencyAmountInput(acceptanceCriteria),
        const SpaceComponent(),
        Expanded(child: frequenceDropDown(acceptanceCriteria))
      ],
    );
  }

  frequencyAmountInput(AcceptanceCriteriaModel acceptanceCriteria) {
    if (acceptanceCriteria.frequence.amount != null) {
      frequenceAmountTextEditingController.text =
          acceptanceCriteria.frequence.amount.toString();
    }
    return CustomContainerComponent(
      isQuadratic: true,
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextField(
          textAlign: TextAlign.center,
          controller:
              frequenceAmountTextEditingController, // somehow TextEditingController()..text = doesnt work anymore!?
          keyboardType: const TextInputType.numberWithOptions(),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
            TextInputFormatter.withFunction(
              (oldValue, newValue) => newValue.copyWith(
                text: newValue.text.replaceAll(',', '.'),
              ),
            ),
          ],
          onChanged: (value) {
            setState(() {
              acceptanceCriteria.frequence.amount =
                  value == '' ? null : int.parse(value);
            });
          },
          onTap: () => setState(() {
            if (widget.setIsKeyboardUp != null) {
              widget.setIsKeyboardUp!(true);
            }
          }),
          decoration: const InputDecoration.collapsed(hintText: '∞'),
        ),
      ),
    );
  }

  dayFrequence(AcceptanceCriteriaModel acceptanceCriteria) {
    return Row(
      children: [
        frequencyAmountInput(acceptanceCriteria),
        const SpaceComponent(),
        Expanded(child: frequenceDropDown(acceptanceCriteria))
      ],
    );
  }
}
