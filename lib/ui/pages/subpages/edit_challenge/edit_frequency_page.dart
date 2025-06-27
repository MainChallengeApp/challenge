import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/services/database_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_dropdown.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_input_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/simple_components/bottom_buttons_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditFrequencyPage extends StatefulWidget {
  final ChallengeModel challenge;

  const EditFrequencyPage({
    Key? key,
    required this.challenge,
  }) : super(key: key);

  @override
  State<EditFrequencyPage> createState() => _EditFrequencyPageState();
}

class _EditFrequencyPageState extends State<EditFrequencyPage> {
  late final ChallengeModel _editChallenge = widget.challenge.copy();
  late final _amountTextEditingController =
      TextEditingController(text: _editChallenge.frequency.amount?.toString());
  bool _isTypeExpanded = false;
  final _amountFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _amountFocusNode.addListener(() {
      if (_amountFocusNode.hasFocus) {
        setState(() {
          _isTypeExpanded = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _amountFocusNode.dispose();
    super.dispose();
  }

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
        appBar: const AppBarComponent(
          title: 'Edit Repetitions',
        ),
        isBottomNavigationVisible: false,
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  _amount(),
                  _type(),
                ],
              ),
            ),
            const SpaceComponent(),
            _actionButtons(),
          ],
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
        keyboardType: const TextInputType.numberWithOptions(),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[1-9]+[0-9]*')),
        ],
        onChangeTextField: (value) {
          setState(() {
            if (value.isEmpty) {
              _editChallenge.frequency.amount = null;
              return;
            }
            _editChallenge.frequency.amount = int.parse(value);
            _editChallenge.calcEndDate();
          });
        },
        onSubmitted: (_) {
          _onTapAccept();
        },
        textInputAction: TextInputAction.next,
        labelText: 'Amount',
        hintText: 'max.',
        maxLength: DatabaseService.maxFrequencyAmountLength,
        removeActionIcon: true,
      ),
    );
  }

  SpaceColumnComponent _type() {
    return SpaceColumnComponent(
        child: ListItemIconDropdown<FrequencyTypeEnum>(
            list: FrequencyTypeEnum.values,
            isExpanded: _isTypeExpanded,
            initialEntry: _editChallenge.frequency.type,
            onTap: _onTapType,
            onTapEntry: _onTapTypeEntry,
            getText: (type) =>
                type.typeToString(_editChallenge.frequency.amount),
            icon: IconEnum.frequencyType.icon,
            labelText: 'Type'));
  }

  _onTapTypeEntry(FrequencyTypeEnum type) {
    setState(() {
      _editChallenge.frequency.type = type;
      _isTypeExpanded = false;
      _editChallenge.calcEndDate();
    });
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
        onTap: _onTapAccept,
        text: 'Accept',
        isMainButton: true,
        margin: EdgeInsets.zero,
      ),
    ]);
  }

  void _onTapAccept() {
    widget.challenge.frequency.amount = _editChallenge.frequency.amount;
    widget.challenge.frequency.type = _editChallenge.frequency.type;
    if (widget.challenge.startDate != null) {
      widget.challenge.calcEndDate();
    } else if (widget.challenge.endDate != null) {
      widget.challenge.calcStartDate();
    }
    Navigator.of(context).pop();
  }

  void _onTapCancel() {
    Navigator.of(context).pop();
  }

  void _onTapType() {
    setState(() {
      _isTypeExpanded = !_isTypeExpanded;
      _amountFocusNode.unfocus();
    });
  }
}
