import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/services/database_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_child_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_input_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditFrequencyPage extends StatefulWidget {
  final ChallengeModel challenge;

  const EditFrequencyPage({
    super.key,
    required this.challenge,
  });

  @override
  State<EditFrequencyPage> createState() => _EditFrequencyPageState();
}

class _EditFrequencyPageState extends State<EditFrequencyPage> {
  late int? _editAmount = widget.challenge.frequency.amount;
  late FrequencyTypeEnum _editType = widget.challenge.frequency.type;

  final String _title = 'Edit Repetitions';

  late final _amountTextEditingController =
      TextEditingController(text: _editAmount?.toString());

  bool _isTypeExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          _isTypeExpanded = false;
        });
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
            _type(),
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

  _type() {
    return Expanded(
      child: Stack(
        children: [
          Visibility(
            visible: _isTypeExpanded,
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
                    children: FrequencyTypeEnum.values
                        .map((type) => _typeEntry(
                            type, type == FrequencyTypeEnum.values.last))
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
          ListItemIconTextChildComponent(
            onTap: _onTapType,
            icon: IconEnum.frequencyType.icon,
            text: _editType.typeToString(_editAmount),
            labelText: 'Type',
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(
                _isTypeExpanded
                    ? IconEnum.arrowUp.icon
                    : IconEnum.arrowDown.icon,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _typeEntry(FrequencyTypeEnum type, bool isLast) {
    return SpaceColumnComponent(
      height: isLast ? 0 : null,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _editType = type;
          });
        },
        child: CustomContainerComponent(
          child: Row(children: [
            Expanded(child: Text(type.typeToString(_editAmount))),
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
        keyboardType: const TextInputType.numberWithOptions(),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[1-9]+[0-9]*')),
        ],
        onChangeTextField: (value) {
          setState(() {
            if (value.isEmpty) {
              _editAmount = null;
              return;
            }
            _editAmount = int.parse(value);
          });
        },
        onSubmitted: (_) {
          _onTapAccept();
        },
        textInputAction: TextInputAction.next,
        lableText: 'Amount',
        hintText: 'max.',
        maxLength: DatabaseService.maxAmountLength,
        removeActionIcon: true,
      ),
    );
  }

  void _onTapAccept() {
    widget.challenge.frequency.amount = _editAmount;
    widget.challenge.frequency.type = _editType;
    Navigator.of(context).pop();
  }

  void _onTapCancel() {
    Navigator.of(context).pop();
  }

  void _onTapType() {
    setState(() {
      _isTypeExpanded = !_isTypeExpanded;
    });
  }
}
