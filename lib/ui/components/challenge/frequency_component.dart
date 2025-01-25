import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/frequency_model.dart';
import 'package:challenge/services/database_service.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
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
    return frequency.type == FrequencyTypeEnum.time
        ? timeFrequency()
        : frequency.type == FrequencyTypeEnum.daily
            ? dayFrequency()
            : frequencyDropDown();
  }

  frequencyDropDown() {
    Map<FrequencyTypeEnum, String> frequencyMap = {
      FrequencyTypeEnum.time: 'Time',
      FrequencyTypeEnum.daily: 'Day',
    };

    return Expanded(
      flex: 2,
      child: CustomContainerComponent(
          child: DropdownButton<String>(
        borderRadius:
            BorderRadius.circular(CustomContainerComponent.standardRadius),
        isExpanded: true,
        underline: Container(),
        value: frequency.type.toString().split('.')[1],
        icon: Icon(IconEnum.arrowDown.icon,
            size: Theme.of(context).textTheme.titleLarge?.fontSize),
        style: Theme.of(context).textTheme.textInputSmall,
        hint: Text(
          'Frequency',
          style: Theme.of(context).textTheme.textInputHintSmall,
        ),
        onChanged: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            frequency.type = FrequencyTypeEnum.fromString(value!);
          });
          widget.challenge.setFrequencyAmount();
          widget.challenge.calcEndDate();
          widget.reloadSearchChallengePage?.call();
        },
        items: frequencyMap.entries.map((e) {
          return DropdownMenuItem<String>(
              value: e.key.text,
              child: Text(
                frequency.amount != 1 ? '${e.value}s' : e.value,
                style: Theme.of(context).textTheme.textInputSmall,
              ));
        }).toList(),
      )),
    );
  }

  timeFrequency() {
    return Row(
      children: [
        frequencyAmountInput(),
        const SpaceComponent(),
        frequencyDropDown()
      ],
    );
  }

  frequencyAmountInput() {
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
            maxLength: DatabaseService.maxCharactersShort,
            buildCounter: (_,
                    {required currentLength,
                    required isFocused,
                    required maxLength}) =>
                null,
            style: Theme.of(context).textTheme.textInputSmall,
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
              widget.challenge.calcEndDate();
              widget.reloadSearchChallengePage?.call();
            },
            onTap: () => setState(() {
              widget.setIsKeyboardUp?.call(true);
            }),
            decoration: InputDecoration.collapsed(
                hintText: '∞',
                hintStyle: Theme.of(context).textTheme.textInputHintSmall),
          ),
        ),
      ),
    );
  }

  dayFrequency() {
    return Row(
      children: [
        frequencyAmountInput(),
        const SpaceComponent(),
        frequencyDropDown(),
        const SpaceComponent(),
        frequencyFrequencyDropDown(),
      ],
    );
  }

  frequencyFrequencyDropDown() {
    return Expanded(
        flex: 2,
        child: CustomContainerComponent(
            child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Every Day',
            style: Theme.of(context).textTheme.textInputSmall,
          ),
        )));
  }
}
