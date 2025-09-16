import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/media/image_media_model.dart';
import 'package:challenge/models/challenge/media/media_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/models/challenge/progress_model.dart';
import 'package:challenge/models/challenge/repetition_model.dart';
import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/providers/notifications_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/services/util_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/list_items/list_item_media_small_component.dart';
import 'package:challenge/ui/components/list_items/list_item_progress_component.dart';
import 'package:challenge/ui/components/list_items/list_item_progress_controller_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/pages/subpages/media/media_detail_page.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressMediaListPage extends StatefulWidget {
  const ProgressMediaListPage(
      {super.key,
      required this.attempt,
      required this.initialMediaList,
      this.repetition,
      this.progress,
      this.isSaveAndNotEditButtonVisible = true,
      this.amountOfPops = 1,
      required this.groupChallenge,
      required this.participant,
      required this.isEditableByUser});

  final AttemptModel attempt;
  final GroupChallengeModel groupChallenge;
  final ParticipantModel participant;
  final RepetitionModel? repetition;
  final List<MediaModel> initialMediaList;
  final ProgressModel? progress;
  final bool isSaveAndNotEditButtonVisible;
  final int amountOfPops;
  final bool isEditableByUser;

  @override
  State<ProgressMediaListPage> createState() => _ProgressMediaListPageState();
}

class _ProgressMediaListPageState extends State<ProgressMediaListPage> {
  final ScrollController _scrollController = ScrollController();
  late final RepetitionModel _editRepetition = _getEditRepetition();

  late final RepetitionModel? _currentRepetition =
      widget.attempt.getCurrentRepetition(widget.groupChallenge);

  late ProgressModel editProgress = _initializeProgress();

  late TextEditingController progressTextEditingController =
      TextEditingController(
          text: UtilService.doubleAsIntString(editProgress.progress));

  final _groupChallengesProvider = getIt<GroupChallengesProvider>();

  final _notificationsProvider = getIt<NotificationsProvider>();

  final _mediaService = MediaService();

  bool _isSaveLoading = false;
  late bool _isSaveAndNotEditButtonVisible =
      widget.isSaveAndNotEditButtonVisible;

  @override
  void initState() {
    super.initState();
    if (widget.progress == null) {
      editProgress.getSmartProgress(
          widget.initialMediaList, widget.attempt, widget.groupChallenge);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldComponent(
        appBar: AppBarComponent(
            title: widget.progress == null
                ? 'New Progress'
                : 'Progress ${_editRepetition.progressList.indexWhere((element) => element == widget.progress) + 1}'),
        isBottomNavigationVisible: false,
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Stack(
            children: [
              _buildList(),
              widget.isEditableByUser
                  ? _isSaveAndNotEditButtonVisible
                      ? cancelAndSaveButton()
                      : deleteAndEditButton()
                  : Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Row(
                          children: [
                            const SpaceComponent(
                              width: ListItemContainerComponent.standardMargin,
                            ),
                            cancelButton(),
                            const SpaceComponent(
                              width: ListItemContainerComponent.standardMargin,
                            ),
                          ],
                        ),
                      ),
                    )
            ],
          ),
        ));
  }

  Widget _buildList() {
    return CupertinoScrollbar(
      controller: _scrollController,
      child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          itemCount: widget.initialMediaList.length +
              1 +
              (_isSaveAndNotEditButtonVisible
                  ? 2
                  : 0) // +1 for progress controller list item
          , // +1 for progress bar +1 for upload Media
          itemBuilder: (BuildContext content, int index) {
            if (index == 0) {
              return _progressListItem();
            }

            if (index == 1 &&
                _isSaveAndNotEditButtonVisible &&
                widget.isEditableByUser) {
              return _progressControllerListItem();
            }

            if (index == 2 &&
                _isSaveAndNotEditButtonVisible &&
                widget.isEditableByUser) {
              return _uploadMediaListItem();
            }

            return _mediaListItem(index);
          }),
    );
  }

  ProgressModel _initializeProgress() {
    final mediaIds = widget.initialMediaList.map((e) => e.id!).toList();
    final lastProgress = _editRepetition.getLastProgress()?.progress ?? 0;
    final date =
        _editRepetition.repetitionNumber == _currentRepetition?.repetitionNumber
            ? null
            : _editRepetition.startDate;

    return ProgressModel.copyOrCreateProgress(
        widget.progress, mediaIds, lastProgress, date);
  }

  SpaceColumnComponent _mediaListItem(int index) {
    int newIndex = index - (_isSaveAndNotEditButtonVisible ? 3 : 1);
    MediaModel media = widget.initialMediaList.reversed.elementAt(newIndex);
    return SpaceColumnComponent(
      child: ListItemMediaSmallComponent(
        onTap: () => _onTapMedia(context, index: newIndex),
        media: media,
        isEditableByUser: widget.isEditableByUser,
        onTapDeleteMedia: () => _onTapDeleteMedia(media),
      ),
    );
  }

  SpaceColumnComponent _uploadMediaListItem() {
    return SpaceColumnComponent(
      child: ListItemIconTextComponent(
          onTap: _onTapUploadMedia,
          icon: IconEnum.upload.icon,
          title: 'Upload Media'),
    );
  }

  SpaceColumnComponent _progressControllerListItem() {
    return SpaceColumnComponent(
      child: ListItemProgressControllerComponent(
        editProgress: editProgress,
        groupChallenge: widget.groupChallenge,
        attempt: widget.attempt,
        progressTextEditingController: progressTextEditingController,
        progressListSetState: () => setState(() {}),
      ),
    );
  }

  SpaceColumnComponent _progressListItem() {
    return SpaceColumnComponent(
        child: ListItemProgressComponent(
      progress: editProgress,
      attempt: widget.attempt,
      groupChallenge: widget.groupChallenge,
      progressTextEditingController: progressTextEditingController,
      isEditable: _isSaveAndNotEditButtonVisible && widget.isEditableByUser,
      isFailed: _editRepetition.isFailed(),
      unit: widget.attempt.getAcceptanceCriteria(widget.groupChallenge).unit,
      setStateProgressList: () => setState(() {}),
    ));
  }

  void _onTapMedia(BuildContext context, {required int index}) {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => MediaDetailPage(
          mediaList: widget.initialMediaList,
          initialMediaIndex: index,
          groupChallenge: widget.groupChallenge,
          participant: widget.participant,
          attempt: widget.attempt,
          isEditableByUser: widget.isEditableByUser,
          onTapDelete: _onTapDeleteMedia,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  cancelAndSaveButton() {
    return _isSaveAndNotEditButtonVisible
        ? Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: BottomNavigationComponent.standardMargin),
              child: Row(
                children: [
                  const SpaceComponent(
                    width: ListItemContainerComponent.standardMargin,
                  ),
                  cancelButton(),
                  const SpaceComponent(),
                  saveButton(),
                  const SpaceComponent(
                    width: ListItemContainerComponent.standardMargin,
                  ),
                ],
              ),
            ),
          )
        : Container();
  }

  Expanded saveButton() {
    return Expanded(
      child: ListItemButtonComponent(
        text: 'Save',
        onTap: _onTapSave,
        isMainButton: true,
        margin: const EdgeInsets.all(0),
        isLoading: _isSaveLoading,
      ),
    );
  }

  Expanded cancelButton() {
    return Expanded(
      child: ListItemButtonComponent(
        text: 'Cancel',
        onTap: _onTapCancel,
        isMainButton: false,
        margin: const EdgeInsets.all(0),
      ),
    );
  }

  deleteAndEditButton() {
    return !_isSaveAndNotEditButtonVisible
        ? Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: BottomNavigationComponent.standardMargin),
              child: Row(
                children: [
                  deleteButton(),
                  const SpaceComponent(),
                  editButton(),
                ],
              ),
            ),
          )
        : Container();
  }

  Expanded editButton() {
    return Expanded(
      child: ListItemButtonComponent(
        text: 'Edit',
        onTap: onTapEdit,
        isMainButton: true,
        margin: const EdgeInsets.only(
            right: BottomNavigationComponent.standardMargin),
      ),
    );
  }

  void onTapEdit() {
    setState(() {
      _isSaveAndNotEditButtonVisible = true;
    });
  }

  Expanded deleteButton() {
    return Expanded(
      child: ListItemButtonComponent(
        text: 'Delete',
        textColor: Theme.of(context).colorScheme.red,
        onTap: _onTapDelete,
        isMainButton: false,
        margin: const EdgeInsets.only(
            left: BottomNavigationComponent.standardMargin),
      ),
    );
  }

  void _onTapSave() async {
    if (_isSaveLoading) {
      return;
    }

    setState(() {
      _isSaveLoading = true;
    });

    if (widget.attempt.isInBacklog(widget.groupChallenge) &&
        editProgress.progress > 0) {
      widget.attempt.start(widget.groupChallenge);
    }

    if (_editRepetition.isInBacklog() && editProgress.progress > 0) {
      _editRepetition.start();
    }

    if (widget.progress == null) {
      _editRepetition.addProgress(progress: editProgress);
    } else {
      widget.progress!.updateProgress(editProgress);
    }

    int index = widget.attempt.repetitions.indexWhere((repetitionEntry) =>
        repetitionEntry.repetitionNumber == _editRepetition.repetitionNumber);

    if (index == -1) {
      widget.attempt.repetitions.add(_editRepetition);
    } else {
      widget.attempt.repetitions[index] = _editRepetition;
    }

    widget.attempt.startDate ??= widget.attempt.repetitions
        .firstWhere((repetition) => repetition.repetitionNumber == 1,
            orElse: () => _editRepetition)
        .startDate;

    // make acceptanceCriteria fix in case it gets changed after finishing the challenge
    widget.attempt.acceptanceCriteria =
        widget.attempt.getAcceptanceCriteria(widget.groupChallenge);

    await _groupChallengesProvider.updateAttempt(
        widget.groupChallenge, widget.participant, widget.attempt);

    await _notificationsProvider.sendProgressAddedNotification(
        widget.groupChallenge, widget.participant);

    setState(() {
      _isSaveLoading = false;
      _isSaveAndNotEditButtonVisible = false;
    });

    for (int i = 0; i < widget.amountOfPops; i++) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  _onTapUploadMedia() async {
    ImageMediaModel? media = await _mediaService.openImagePicker(context);
    if (media == null) {
      return;
    }
    _groupChallengesProvider.uploadMediaToAttempt(
        widget.groupChallenge, widget.participant, widget.attempt, media);
    setState(() {
      editProgress.mediaIds.add(media.id!);
      widget.initialMediaList.add(media);
    });
  }

  void _onTapCancel() {
    if (!widget.isEditableByUser || widget.progress == null) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      _isSaveAndNotEditButtonVisible = false;
    });
  }

  void _onTapDelete() {
    if (widget.progress == null) {
      return;
    }

    setState(() {
      _editRepetition.deleteProgress(widget.progress!);
    });
    widget.attempt.replaceRepetition(_editRepetition);
    _groupChallengesProvider.updateAttempt(
        widget.groupChallenge, widget.participant, widget.attempt);
    Navigator.pop(context);
  }

  void _onTapDeleteMedia(MediaModel media) {
    _groupChallengesProvider.deleteMediaFromAttempt(
        widget.groupChallenge, widget.participant, widget.attempt, media);
    setState(() {
      widget.initialMediaList.removeWhere((element) => element.id == media.id);
      editProgress.mediaIds.removeWhere((mediaId) => mediaId == media.id);
    });
  }

  RepetitionModel _getEditRepetition() {
    if (widget.repetition != null) {
      return widget.repetition!;
    }

    return widget.attempt.getCurrentRepetition(widget.groupChallenge) ??
        widget.attempt.addRepetition(widget.groupChallenge);
  }
}
