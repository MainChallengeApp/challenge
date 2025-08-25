import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/unit_model.dart';
import 'package:challenge/services/database_service.dart';
import 'package:challenge/services/util_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_input_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/simple_components/bottom_buttons_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditGoalPage extends StatefulWidget {
  final ChallengeModel challenge;

  const EditGoalPage({
    super.key,
    required this.challenge,
  });

  @override
  State<EditGoalPage> createState() => _EditGoalPageState();
}

class _EditGoalPageState extends State<EditGoalPage> {
  late double _editAmount = widget.challenge.acceptanceCriteria.amount;
  late String _editUnit = widget.challenge.acceptanceCriteria.unit;

  late final _unitTextEditingController =
      TextEditingController(text: _editUnit);
  late final _amountTextEditingController =
      TextEditingController(text: UtilService.doubleAsIntString(_editAmount));

  final _unitFocusNode = FocusNode();
  final _amountFocusNode = FocusNode();

  final List<Unit> _unitsSingularPlural = Unit.getUnits();

  bool _isUnitExpanded = false;

  @override
  void dispose() {
    _unitFocusNode.dispose();
    _amountFocusNode.dispose();
    _unitTextEditingController.dispose();
    _amountTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          _isUnitExpanded = false;
        });
      },
      child: ScaffoldComponent(
        appBar: const AppBarComponent(
          title: 'Edit Goal',
        ),
        isBottomNavigationVisible: false,
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _unit(),
                  _amount(),
                ],
              ),
            ),
            _actionButtons(),
          ],
        ),
      ),
    );
  }

  _actionButtons() {
    return BottomButtonsComponent(buttons: [
      ListItemButtonComponent(
        onTap: _onTapCancel,
        text: 'Cancel',
        isMainButton: false,
        margin: EdgeInsets.zero,
      ),
      ListItemButtonComponent(
        margin: EdgeInsets.zero,
        onTap: _onTapAccept,
        text: 'Accept',
      )
    ]);
  }

  _unit() {
    Unit.sortUnits(_unitsSingularPlural, _editUnit, _editAmount);

    final list = Visibility(
      visible: _isUnitExpanded,
      child: ListItemContainerComponent(
        isHeightDynamic: true,
        padding: const EdgeInsets.only(
            left: CardComponent.standardPadding,
            right: CardComponent.standardPadding,
            bottom: CardComponent.standardPadding,
            top: ListItemContainerComponent.standardHeight +
                SpaceComponent.standardHeight -
                2),
        child: ListView(
          padding: EdgeInsets.zero,
          children: _unitsSingularPlural
              .map((unit) =>
                  _suggestedUnit(unit, unit == _unitsSingularPlural.last))
              .toList(),
        ),
      ),
    );

    final input = SpaceColumnComponent(
      height: _isUnitExpanded ? 0 : null,
      child: ListItemIconTextInputComponent(
        icon: IconEnum.unit.icon,
        focusNode: _unitFocusNode,
        textEditingController: _unitTextEditingController,
        onChangeTextField: (value) {
          setState(() {
            _editUnit = value;
          });
        },
        onSubmitted: (_) {
          setState(() {
            _isUnitExpanded = false;
            _amountFocusNode.requestFocus();
          });
        },
        labelText: 'Unit',
        infoText: _isUnitExpanded ? null : 'What do you want to measure?',
        autoCorrection: false,
        removeActionIcon: true,
        actionIcon:
            _isUnitExpanded ? IconEnum.arrowUp.icon : IconEnum.arrowDown.icon,
        onTapActionIcon: () {
          setState(() {
            _isUnitExpanded = !_isUnitExpanded;
            _amountFocusNode.unfocus();
          });
        },
      ),
    );

    final stack = Stack(
      children: [
        list,
        input,
      ],
    );

    return _isUnitExpanded ? Expanded(child: stack) : input;
  }

  Widget _suggestedUnit(Unit unit, bool isLast) {
    return SpaceColumnComponent(
      height: isLast ? 0 : null,
      child: TapContainerComponent(
        onTap: () {
          setState(() {
            _editUnit = _editAmount == 1 ? unit.singular : unit.plural;
            _unitTextEditingController.text = _editUnit;
            _isUnitExpanded = false;
          });
        },
        child: Row(children: [
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(_editAmount == 1 ? unit.singular : unit.plural),
              const SpaceComponent(width: 4),
              Visibility(
                visible: unit.isSmart,
                child: Icon(
                  IconEnum.isSmart.icon,
                  size: Theme.of(context).textTheme.bodyLarge?.fontSize,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ],
          )),
          Icon(
            IconEnum.autoFill.icon,
            size: Theme.of(context).textTheme.titleLarge?.fontSize,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ]),
      ),
    );
  }

  _amount() {
    return Visibility(
      visible: !_isUnitExpanded,
      child: SpaceColumnComponent(
        child: ListItemIconTextInputComponent(
          icon: IconEnum.numbers.icon,
          textEditingController: _amountTextEditingController,
          focusNode: _amountFocusNode,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          infoText: 'How many do you want to achieve?',
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
            TextInputFormatter.withFunction(
              (oldValue, newValue) => newValue.copyWith(
                text: newValue.text.replaceAll(',', '.'),
              ),
            ),
          ],
          onChangeTextField: (value) {
            setState(() {
              double number = 1;
              if (value.endsWith('.')) {
                number = double.parse(value.split('.')[0]);
                _editAmount = number;
              } else if (value == '') {
                _editAmount = 1;
              } else {
                number = double.parse(value);
                _editAmount = number;
              }

              // Update _editUnit for singular/plural value if exists in unitsSingularPlural
              // Update _editUnit for singular/plural value if exists in unitsSingularPlural
              final matchingUnits = _unitsSingularPlural.where((unit) =>
                  unit.singular.toLowerCase() == _editUnit.toLowerCase() ||
                  unit.plural.toLowerCase() == _editUnit.toLowerCase());

              if (matchingUnits.isNotEmpty) {
                final matchingUnit = matchingUnits.first;
                _editUnit = _editAmount == 1
                    ? matchingUnit.singular
                    : matchingUnit.plural;
                _unitTextEditingController.text = _editUnit;
              }
            });
          },
          onSubmitted: (_) {
            _onTapAccept();
          },
          textInputAction: TextInputAction.next,
          labelText: 'Amount',
          hintText: '1',
          maxLength: DatabaseService.maxAcceptanceCriteriaAmountLength,
          removeActionIcon: true,
        ),
      ),
    );
  }

  void _onTapAccept() {
    widget.challenge.acceptanceCriteria.unit = _editUnit;
    widget.challenge.acceptanceCriteria.amount = _editAmount;
    Navigator.of(context).pop();
  }

  void _onTapCancel() {
    Navigator.of(context).pop();
  }
}
