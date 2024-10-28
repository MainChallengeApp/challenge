import 'package:challenge/models/challenge/acceptance_criteria_model.dart';
import 'package:challenge/models/unit_model.dart';
import 'package:challenge/services/database_service.dart';
import 'package:challenge/services/util_service.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
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
          text:
              UtilService.doubleAsIntString(widget.acceptanceCriteria.amount));
  late TextEditingController unitTextEditingController =
      TextEditingController(text: widget.acceptanceCriteria.unit.toString());

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        amount(),
        const SpaceComponent(),
        unitDropDown(),
      ],
    );
  }

  Expanded unitDropDown() {
    List<Unit> unitsSingularPlural = [
      Unit(singular: 'Piece', plural: 'Pieces'),
      Unit(singular: 'Point', plural: 'Points'),
      Unit(singular: 'Hour', plural: 'Hours'),
      Unit(singular: 'Minute', plural: 'Minutes'),
      Unit(singular: 'Kilogram', plural: 'Kilograms'),
      Unit(singular: 'Gram', plural: 'Grams'),
      Unit(singular: 'Liter', plural: 'Liters'),
      Unit(singular: 'Milliliter', plural: 'Milliliters'),
      Unit(singular: 'Kilometer', plural: 'Kilometers'),
      Unit(singular: 'Meter', plural: 'Meters'),
      Unit(singular: 'Centimeter', plural: 'Centimeters'),
    ];

    List<String> unitsDropDown = unitsSingularPlural
        .map((e) =>
            widget.acceptanceCriteria.amount == 1 ? e.singular : e.plural)
        .toList();

    // if (!unitsDropDown.contains(widget.acceptanceCriteria.unit)) {
    //   unitsDropDown.insert(0, widget.acceptanceCriteria.unit);
    // }

    return Expanded(
        flex: 2,
        child: CustomContainerComponent(
          child: DropdownButton<String>(
            borderRadius:
                BorderRadius.circular(CustomContainerComponent.standardRadius),
            isExpanded: true,
            underline: Container(),
            value: '',
            icon: const Icon(Icons.expand_more),
            style: Theme.of(context).textTheme.textInputSmall,
            hint: Text(
              'Unit',
              style: Theme.of(context).textTheme.textInputHintSmall,
            ),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                if (value != null && value != '') {
                  widget.acceptanceCriteria.unit = value;
                  unitTextEditingController.text = value;
                }
              });
              widget.onReloadSearchListPage?.call();
            },
            items: createUnitDropDownMenu(unitsDropDown),
          ),
        ));
  }

  List<DropdownMenuItem<String>> createUnitDropDownMenu(
      List<String> unitsDropDown) {
    List<DropdownMenuItem<String>> unitDropDownMenu = [
      DropdownMenuItem<String>(
          value: '',
          child: TextField(
            maxLength: DatabaseService.maxCharactersShort,
            buildCounter: (_,
                    {required currentLength,
                    required isFocused,
                    required maxLength}) =>
                null,
            style: Theme.of(context).textTheme.textInputSmall,
            decoration: InputDecoration.collapsed(
                hintText: 'Unit',
                hintStyle: Theme.of(context).textTheme.textInputHintSmall),
            controller: unitTextEditingController,
            onChanged: (value) => widget.acceptanceCriteria.unit = value,
            onSubmitted: (String value) {
              widget.acceptanceCriteria.unit = value.trim();
              unitTextEditingController.text = value.trim();
            },
            onTapOutside: (_) {
              widget.acceptanceCriteria.unit =
                  unitTextEditingController.text.trim();
              unitTextEditingController.text =
                  unitTextEditingController.text.trim();
            },
          ))
    ];

    unitDropDownMenu.addAll(unitsDropDown.map((e) {
      return DropdownMenuItem<String>(
          value: e,
          child: Text(
            e,
            style: Theme.of(context).textTheme.textInputSmall,
          ));
    }).toList());
    return unitDropDownMenu;
  }

  Expanded amount() {
    return Expanded(
        child: CustomContainerComponent(
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextField(
          maxLength: DatabaseService.maxCharactersShort,
          style: Theme.of(context).textTheme.textInputSmall,
          textAlign: TextAlign.end,
          controller:
              amountTextEditingController, // somehow TextEditingController()..text = does not work anymore!?
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
          decoration: InputDecoration.collapsed(
              hintText: '1',
              hintStyle: Theme.of(context).textTheme.textInputHintSmall),
        ),
      ),
    ));
  }
}
