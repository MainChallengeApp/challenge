import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_input_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';

class EditTitlePage extends StatefulWidget {
  final ChallengeModel challenge;

  const EditTitlePage({
    super.key,
    required this.challenge,
  });

  @override
  State<EditTitlePage> createState() => _EditTitlePageState();
}

class _EditTitlePageState extends State<EditTitlePage> {
  late String _editTitle = widget.challenge.title;

  final String _title = 'Edit Title';
  String? _errorText;

  late final _titleTextEditingController =
      TextEditingController(text: _editTitle);

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
            SpaceColumnComponent(
              child: ListItemIconTextInputComponent(
                icon: IconEnum.title.icon,
                textEditingController: _titleTextEditingController,
                errorText: _errorText,
                autoFocus: true,
                onChangeTextField: (value) {
                  setState(() {
                    _editTitle = value;
                    _errorText = null;
                  });
                },
                lableText: 'Title',
              ),
            ),
            SpaceColumnComponent(
              height: BottomNavigationComponent.standardMargin,
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

  void _onTapAccept() {
    widget.challenge.title = _editTitle;
    Navigator.pop(context);
  }

  void _onTapCancel() {
    Navigator.pop(context);
  }
}
