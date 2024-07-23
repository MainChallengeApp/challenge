import 'package:challenge/models/frequency_model.dart';
import 'package:challenge/components/simple_components/custom_container_component.dart';
import 'package:challenge/components/simple_components/space_component.dart';
import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/acceptance_criteria_model.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FrequencyComponent extends StatefulWidget {
  final ChallengeModel challenge;
  final Function? setIsKeyboardUp;
  final Function? reloadSearchChallengePage;

  const FrequencyComponent({
    super.key,
    required this.challenge,
    this.setIsKeyboardUp,
    this.reloadSearchChallengePage,
  });

  @override
  State<FrequencyComponent> createState() => _FrequencyComponentState();
}

class _FrequencyComponentState extends State<FrequencyComponent> {
  TextEditingController frequencyAmountTextEditingController =
      TextEditingController();

  bool isKeyboardUp = false;

  late FrequencyModel frequency = widget.challenge.frequency;

  @override
  Widget build(BuildContext context) {
    AcceptanceCriteriaModel acceptanceCriteria =
        widget.challenge.acceptanceCriteria;
    return frequency.type == FrequencyTypeEnum.time
        ? timeFrequency(acceptanceCriteria)
        : frequency.type == FrequencyTypeEnum.daily
            ? dayFrequency(acceptanceCriteria)
            : frequencyDropDown(acceptanceCriteria);
  }

  frequencyDropDown(AcceptanceCriteriaModel acceptanceCriteria) {
    Map<FrequencyTypeEnum, String> frequencyMap = {
      FrequencyTypeEnum.time: 'Time',
      FrequencyTypeEnum.daily: 'Day',
    };

    return Expanded(
      flex: 2,
      child: CustomContainerComponent(
          child: DropdownButton<String>(
        borderRadius: BorderRadius.circular(16),
        isExpanded: true,
        underline: Container(),
        value: frequency.type.toString().split('.')[1],
        icon: const Icon(Icons.expand_more),
        style: const TextStyle(color: Colors.black, fontSize: basicFontSize),
        hint: const Text('Frequency'),
        onChanged: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            frequency.type = FrequencyTypeEnum.factory(value!);
          });
          widget.challenge.setFrequencyAmount();
          widget.challenge.setEndDate();
          widget.reloadSearchChallengePage?.call();
        },
        items: frequencyMap.entries.map((e) {
          return DropdownMenuItem<String>(
              value: e.key.toString2(),
              child: Text(
                frequency.amount != 1 ? '${e.value}s' : e.value,
                style: const TextStyle(fontSize: basicFontSize),
              ));
        }).toList(),
      )),
    );
  }

  timeFrequency(AcceptanceCriteriaModel acceptanceCriteria) {
    return Row(
      children: [
        frequencyAmountInput(acceptanceCriteria),
        const SpaceComponent(),
        frequencyDropDown(acceptanceCriteria)
      ],
    );
  }

  frequencyAmountInput(AcceptanceCriteriaModel acceptanceCriteria) {
    if (frequency.amount != null) {
      frequencyAmountTextEditingController.text = frequency.amount.toString();
    } else {
      frequencyAmountTextEditingController.text = '';
    }
    return Expanded(
      flex: 1,
      child: CustomContainerComponent(
        // isQuadratic: true,
        child: Align(
          alignment: Alignment.centerLeft,
          child: TextField(
            style: const TextStyle(fontSize: basicFontSize),
            textAlign: TextAlign.end,
            controller:
                frequencyAmountTextEditingController, // somehow TextEditingController()..text = does not work anymore!?
            keyboardType: const TextInputType.numberWithOptions(),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(
                  RegExp(r'[1-9]+[,.]{0,1}[0-9]*')),
              TextInputFormatter.withFunction(
                (oldValue, newValue) => newValue.copyWith(
                  text: newValue.text.replaceAll(',', '.'),
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                frequency.amount = value == '' ? null : int.parse(value);
              });
              widget.challenge.setEndDate();
              widget.reloadSearchChallengePage?.call();
            },
            onTap: () => setState(() {
              widget.setIsKeyboardUp?.call(true);
            }),
            decoration: const InputDecoration.collapsed(hintText: '∞'),
          ),
        ),
      ),
    );
  }

  dayFrequency(AcceptanceCriteriaModel acceptanceCriteria) {
    return Row(
      children: [
        frequencyAmountInput(acceptanceCriteria),
        const SpaceComponent(),
        frequencyDropDown(acceptanceCriteria),
        const SpaceComponent(),
        frequencyFrequencyDropDown(acceptanceCriteria),
      ],
    );
  }

  frequencyFrequencyDropDown(AcceptanceCriteriaModel acceptanceCriteria) {
    return const Expanded(
        flex: 2,
        child: CustomContainerComponent(
            child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Every Day',
            style: TextStyle(fontSize: basicFontSize),
          ),
        )));
  }
}
