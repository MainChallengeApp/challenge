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
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
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
  initState() {
    super.initState();
    _unitFocusNode.addListener(() {
      setState(() {
        if (_unitFocusNode.hasFocus) {
          _isUnitExpanded = true;
        }
      });
    });
    _amountFocusNode.addListener(() {
      setState(() {
        if (_amountFocusNode.hasFocus) {
          _isUnitExpanded = false;
        }
      });
    });
  }

  @override
  void dispose() {
    _unitFocusNode.dispose();
    _amountFocusNode.dispose();
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
            _amount(),
            _unit(),
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
    _unitsSingularPlural.sort((a, b) {
      // Function to calculate how well a unit matches the search term
      int matchScore(Unit unit) {
        String unitName = _editAmount == 1 ? unit.singular : unit.plural;
        String lowerUnitName = unitName.toLowerCase();
        String lowerEditUnit = _editUnit.toLowerCase();

        if (lowerUnitName == lowerEditUnit) return 3; // Exact match
        if (lowerUnitName.startsWith(lowerEditUnit)) return 2; // Starts with
        if (lowerUnitName.contains(lowerEditUnit)) return 1; // Contains
        return 0; // No match
      }

      int aScore = matchScore(a);
      int bScore = matchScore(b);

      if (aScore != bScore) {
        return bScore.compareTo(aScore); // Higher score first
      } else {
        // If scores are equal, sort alphabetically
        String aName = _editAmount == 1 ? a.singular : a.plural;
        String bName = _editAmount == 1 ? b.singular : b.plural;
        return aName.toLowerCase().compareTo(bName.toLowerCase());
      }
    });

    return Expanded(
      child: Stack(
        children: [
          Visibility(
            visible: _isUnitExpanded,
            child: Align(
              alignment: Alignment.topCenter,
              child: ListItemContainerComponent(
                isHeightDynamic: true,
                padding: const EdgeInsets.only(
                    left: CardComponent.standardPadding,
                    right: CardComponent.standardPadding,
                    bottom: CardComponent.standardPadding,
                    top: ListItemContainerComponent.standardHeight +
                        SpaceComponent.standardHeight -
                        2),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _unitsSingularPlural
                        .map((unit) => _suggestedUnit(
                            unit, unit == _unitsSingularPlural.last))
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
          ListItemIconTextInputComponent(
            icon: IconEnum.unit.icon,
            focusNode: _unitFocusNode,
            textEditingController: _unitTextEditingController,
            onChangeTextField: (value) {
              setState(() {
                _editUnit = value;
              });
            },
            onSubmitted: (_) => _unitFocusNode.unfocus(),
            labelText: 'Unit',
            autoCorrection: false,
            removeActionIcon: true,
            actionIcon: _isUnitExpanded
                ? IconEnum.arrowUp.icon
                : IconEnum.arrowDown.icon,
            onTapActionIcon: () {
              setState(() {
                _isUnitExpanded = !_isUnitExpanded;
                _amountFocusNode.unfocus();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _suggestedUnit(Unit unit, bool isLast) {
    return SpaceColumnComponent(
      height: isLast ? 0 : null,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _editUnit = _editAmount == 1 ? unit.singular : unit.plural;
            _unitTextEditingController.text = _editUnit;
            _isUnitExpanded = false;
          });
        },
        child: CustomContainerComponent(
          child: Row(children: [
            Expanded(
                child: Text(_editAmount == 1 ? unit.singular : unit.plural)),
            Icon(
              IconEnum.autoFill.icon,
              size: Theme.of(context).textTheme.titleLarge?.fontSize,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ]),
        ),
      ),
    );
  }

  SpaceColumnComponent _amount() {
    return SpaceColumnComponent(
      child: ListItemIconTextInputComponent(
        icon: IconEnum.numbers.icon,
        textEditingController: _amountTextEditingController,
        autoFocus: true,
        focusNode: _amountFocusNode,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
