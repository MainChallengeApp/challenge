import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/media/media_model.dart';
import 'package:challenge/models/challenge/media/note_media_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/services/database_service.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_input_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/simple_components/bottom_buttons_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/pages/home/repetition/progress_media_list_page.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MediaNotePage extends StatefulWidget {
  final AttemptModel attempt;
  final GroupChallengeModel groupChallenge;
  final ParticipantModel participant;
  final NoteMediaModel noteMedia;
  final bool autoFocus;
  final bool isEdit;

  const MediaNotePage({
    Key? key,
    required this.attempt,
    required this.groupChallenge,
    required this.participant,
    required this.noteMedia,
    this.autoFocus = true,
    this.isEdit = false,
  }) : super(key: key);

  @override
  State<MediaNotePage> createState() => _MediaNotePageState();
}

class _MediaNotePageState extends State<MediaNotePage> {
  late String _editContent = widget.noteMedia.content;
  late String _editTitle = widget.noteMedia.title;

  late final _contentTextEditingController =
      TextEditingController(text: _editContent);
  late final _titleTextEditingController = TextEditingController(
    text: _editTitle,
  );

  final _groupChallengesProvider = getIt<GroupChallengesProvider>();

  final _scrollController = ScrollController();
  final _maxLength = 5000;
  final _focusNode = FocusNode();
  bool _isLoadingSave = false;

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ScaffoldComponent(
        appBar: const AppBarComponent(
          title: 'Note',
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
                labelText: 'Title',
                autoFocus: false,
                hintText: widget.noteMedia.title,
                maxLength: DatabaseService.maxCharactersShort,
                removeActionIcon: true,
                onChangeTextField: _onChangeTitle,
              ),
            ),
            Expanded(
              child: ListItemContainerComponent(
                onTap: () => _focusNode.requestFocus(),
                onTapColor: Colors.transparent,
                isHeightDynamic: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CupertinoScrollbar(
                        controller: _scrollController,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: TextField(
                            maxLines: null,
                            controller: _contentTextEditingController,
                            focusNode: _focusNode,
                            maxLength: _maxLength,
                            buildCounter: (BuildContext context,
                                    {required int currentLength,
                                    required bool isFocused,
                                    int? maxLength}) =>
                                null,
                            style: Theme.of(context).textTheme.textInputSmall,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Content',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .textInputHintSmall,
                              contentPadding: const EdgeInsets.only(
                                  bottom:
                                      BottomNavigationComponent.standardMargin),
                              isDense: true,
                            ),
                            onChanged: _onChangeContent,
                            autofocus: widget.autoFocus,
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        '${_contentTextEditingController.text.length}/$_maxLength',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SpaceComponent(),
            BottomButtonsComponent(
              buttons: [
                _cancelButton(),
                _acceptOrSaveButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _acceptOrSaveButton() {
    return widget.isEdit
        ? ListItemButtonComponent(
            margin: EdgeInsets.zero,
            onTap: _onTapSave,
            isLoading: _isLoadingSave,
            text: 'Save',
          )
        : ListItemButtonComponent(
            margin: EdgeInsets.zero,
            onTap: _onTapAccept,
            text: 'Accept',
          );
  }

  _cancelButton() {
    return ListItemButtonComponent(
      onTap: _onTapCancel,
      text: 'Cancel',
      isMainButton: false,
      margin: EdgeInsets.zero,
    );
  }

  _onChangeContent(value) {
    setState(() {
      _editContent = value;
    });
  }

  _onChangeTitle(value) {
    setState(() {
      _editTitle = value;
    });
  }

  void _onTapAccept() {
    widget.noteMedia.content = _editContent;
    widget.noteMedia.title =
        _editTitle.trim().isEmpty ? widget.noteMedia.title : _editTitle;
    widget.attempt.addMedia(widget.noteMedia);
    List<MediaModel> initialMediaList = [widget.noteMedia];
    Navigator.push(context, MaterialPageRoute(builder: (builder) {
      return ProgressMediaListPage(
        attempt: widget.attempt,
        groupChallenge: widget.groupChallenge,
        participant: widget.participant,
        initialMediaList: initialMediaList,
        isEditableByUser: true,
        amountOfPops: 2,
      );
    }));
  }

  void _onTapCancel() {
    Navigator.pop(context);
  }

  void _onTapSave() async {
    if (_isLoadingSave) {
      return;
    }
    setState(() {
      _isLoadingSave = true;
    });
    widget.noteMedia.content = _editContent;
    widget.noteMedia.title =
        _editTitle.trim().isEmpty ? widget.noteMedia.title : _editTitle;
    await _groupChallengesProvider.updateAttempt(
        widget.groupChallenge, widget.participant, widget.attempt);
    setState(() {
      _isLoadingSave = false;
    });
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }
}
