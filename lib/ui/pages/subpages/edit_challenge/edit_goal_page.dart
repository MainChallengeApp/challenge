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
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
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

  final String _title = 'Edit Goal';

  late final _unitTextEditingController =
      TextEditingController(text: _editUnit);
  late final _amountTextEditingController =
      TextEditingController(text: UtilService.doubleAsIntString(_editAmount));

  final _unitFocusNode = FocusNode();

  List<Unit> unitsSingularPlural = Unit.getUnits();

  @override
  initState() {
    super.initState();
    _unitFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _unitFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ScaffoldComponent(
        appBar: AppBarComponent(
          title: _title,
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

  SpaceColumnComponent _actionButtons() {
    return SpaceColumnComponent(
      height: BottomNavigationComponent.standardMargin,
      isSpaceOnTop: true,
      child: Row(
        children: [
          const SpaceComponent(
            width: ListItemContainerComponent.standardMargin,
          ),
          Expanded(
            child: ListItemButtonComponent(
              onTap: _onTapCancel,
              text: 'Cancel',
              isMainButton: false,
              margin: EdgeInsets.zero,
            ),
          ),
          const SpaceComponent(),
          Expanded(
            child: ListItemButtonComponent(
              margin: EdgeInsets.zero,
              onTap: _onTapAccept,
              text: 'Accept',
            ),
          ),
          const SpaceComponent(
            width: ListItemContainerComponent.standardMargin,
          ),
        ],
      ),
    );
  }

  _unit() {
    List<Unit> filteredUnits = unitsSingularPlural
        .where((unit) =>
            unit.singular.toLowerCase().contains(_editUnit.toLowerCase()) &&
                _editAmount == 1 ||
            unit.plural.toLowerCase().contains(_editUnit.toLowerCase()) &&
                _editAmount != 1)
        .toList();
    filteredUnits.sort((a, b) => a.singular.compareTo(b.singular));
    return Expanded(
      child: Stack(
        children: [
          Visibility(
            visible: _unitFocusNode.hasFocus && filteredUnits.isNotEmpty,
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
                    children: filteredUnits
                        .map((unit) =>
                            _suggestedUnit(unit, unit == filteredUnits.last))
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
            onSubmitted: (_) => _onTapAccept(),
            lableText: 'Unit',
            autoCorrection: false,
            removeActionIcon: true,
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
          });
        },
        onSubmitted: (_) {
          _onTapAccept();
        },
        textInputAction: TextInputAction.next,
        lableText: 'Amount',
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
