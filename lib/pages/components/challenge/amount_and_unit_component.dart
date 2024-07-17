import 'package:challenge/globals.dart';
import 'package:challenge/models/acceptance_criteria_model.dart';
import 'package:challenge/pages/components/simple_components/custom_container_component.dart';
import 'package:challenge/pages/components/simple_components/space_component.dart';
import 'package:challenge/utils/design_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountAndUnitComponent extends StatefulWidget {
  final AcceptanceCriteriaModel acceptanceCriteria;
  final Function(bool)? setIsKeyboardUp;
  final Function()? onReloadSearchListPage;

  const AmountAndUnitComponent(
      {super.key,
      required this.acceptanceCriteria,
      this.setIsKeyboardUp,
      this.onReloadSearchListPage});

  @override
  State<AmountAndUnitComponent> createState() => _AmountAndUnitComponentState();
}

class _AmountAndUnitComponentState extends State<AmountAndUnitComponent> {
  late TextEditingController amountTextEditingController =
      TextEditingController(
          text: DesignUtil.doubleAsIntString(widget.acceptanceCriteria.amount));
  late TextEditingController unitTextEditingController =
      TextEditingController(text: widget.acceptanceCriteria.unit.toString());

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        amount(),
        const SpaceComponent(),
        unit(),
      ],
    );
  }

  Expanded unit() {
    return Expanded(
        flex: 2,
        child: CustomContainerComponent(
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextField(
              style: const TextStyle(fontSize: basicFontSize),
              controller: unitTextEditingController,
              onChanged: (value) {
                widget.acceptanceCriteria.unit = value;
              },
              onTap: () => widget.setIsKeyboardUp?.call(true),
              onSubmitted: (_) => widget.setIsKeyboardUp?.call(false),
              onEditingComplete: () {
                FocusManager.instance.primaryFocus?.unfocus();
                widget.setIsKeyboardUp?.call(false);
              },
              decoration: const InputDecoration.collapsed(hintText: 'Unit'),
            ),
          ),
        ));
  }

  Expanded amount() {
    return Expanded(
        child: CustomContainerComponent(
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextField(
          style: const TextStyle(fontSize: basicFontSize),
          textAlign: TextAlign.end,
          controller:
              amountTextEditingController, // somehow TextEditingController()..text = doesnt work anymore!?
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
              double number = 1;
              if (value.endsWith('.')) {
                number = double.parse(value.split('.')[0]);
                widget.acceptanceCriteria.amount = number;
              } else if (value == '') {
                widget.acceptanceCriteria.amount = 1;
              } else {
                number = double.parse(value);
                widget.acceptanceCriteria.amount = number;
              }
            });
          },
          onTap: () => widget.setIsKeyboardUp?.call(true),
          decoration: const InputDecoration.collapsed(hintText: '1'),
        ),
      ),
    ));
  }
}
