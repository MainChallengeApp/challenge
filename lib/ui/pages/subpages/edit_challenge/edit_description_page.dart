import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/services/database_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_input_expanded_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';

class EditDescriptionPage extends StatefulWidget {
  final ChallengeModel challenge;

  const EditDescriptionPage({
    super.key,
    required this.challenge,
  });

  @override
  State<EditDescriptionPage> createState() => _EditDescriptionPageState();
}

class _EditDescriptionPageState extends State<EditDescriptionPage> {
  late String _editDescription = widget.challenge.description;

  final String _title = 'Edit Description';

  late final _descriptionTextEditingController =
      TextEditingController(text: _editDescription);

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListItemIconTextInputExpandedComponent(
              icon: IconEnum.description.icon,
              textEditingController: _descriptionTextEditingController,
              lableText: 'Description',
              autoFocus: true,
              hintText: 'Description',
              onChangeTextField: _onChange,
              onSubmitted: (_) => _onTapAccept(),
              maxLength: DatabaseService.maxCharactersLong,
              removeActionIcon: true,
            ),
            SpaceColumnComponent(
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
            ),
          ],
        ),
      ),
    );
  }

  _onChange(value) {
    setState(() {
      _editDescription = value;
    });
  }

  void _onTapAccept() {
    widget.challenge.description = _editDescription;
    Navigator.pop(context);
  }

  void _onTapCancel() {
    Navigator.pop(context);
  }
}
