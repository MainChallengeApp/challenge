import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/enums/repetition_status_enum.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/media_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/models/challenge/progress_model.dart';
import 'package:challenge/models/challenge/repetition_model.dart';
import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/providers/notifications_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/services/storage_service.dart';
import 'package:challenge/services/util_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
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
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ProgressMediaListPage extends StatefulWidget {
  ProgressMediaListPage(
      {super.key,
      required this.attempt,
      required this.initialMediaList,
      this.repetition,
      this.progress,
      this.isSaveInsteadOfEditButtonVisible = true,
      this.amountOfPops = 1,
      required this.groupChallenge,
      required this.participant,
      required this.isEditableByUser});

  final AttemptModel attempt;
  final GroupChallengeModel groupChallenge;
  final ParticipantModel participant;
  RepetitionModel? repetition;
  final List<MediaModel> initialMediaList;
  ProgressModel? progress;
  bool isSaveInsteadOfEditButtonVisible;
  int amountOfPops;
  final bool isEditableByUser;

  @override
  State<ProgressMediaListPage> createState() => _ProgressMediaListPageState();
}

class _ProgressMediaListPageState extends State<ProgressMediaListPage> {
  ScrollController scrollController = ScrollController();

  late final RepetitionModel? _currentRepetition =
      widget.attempt.getCurrentRepetition(widget.groupChallenge);

  late ProgressModel editProgress = ProgressModel.copyOrCreateProgress(
      widget.progress,
      widget.initialMediaList.map((e) => e.id!).toList(),
      widget.repetition != null && widget.repetition!.getLastProgress() != null
          ? widget.repetition!.getLastProgress()!.progress
          : 0,
      widget.repetition?.repetitionNumber ==
              _currentRepetition?.repetitionNumber
          ? null
          : widget.repetition?.startDate);

  late TextEditingController progressTextEditingController =
      TextEditingController(
          text: UtilService.doubleAsIntString(editProgress.progress));

  final _groupChallengesProvider = getIt<GroupChallengesProvider>();

  late final _notificationsProvider =
      Provider.of<NotificationsProvider>(context, listen: false);

  MediaService mediaService = MediaService();
  StorageService storageService = StorageService();

  bool _isSaveLoading = false;

  final String _title = 'Progress';

  @override
  Widget build(BuildContext context) {
    return ScaffoldComponent(
        appBar: AppBarComponent(
            title: widget.progress == null
                ? 'New Progress'
                : '$_title ${widget.repetition != null ? widget.repetition!.progressList.indexWhere((element) => element == widget.progress) + 1 : 1}'),
        isBottomNavigationVisible: false,
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Stack(
            children: [
              _buildList(),
              widget.isEditableByUser
                  ? widget.isSaveInsteadOfEditButtonVisible
                      ? cancelAndSaveButton()
                      : deleteAndEditButton()
                  : Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Row(
                          children: [
                            cancelButton(),
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
      controller: scrollController,
      child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          itemCount: widget.initialMediaList.length +
              1 +
              (widget.isSaveInsteadOfEditButtonVisible
                  ? 2
                  : 0) // +1 for progress controller list item
          , // +1 for progress bar +1 for upload Media
          itemBuilder: (BuildContext content, int index) {
            if (index == 0) {
              widget.repetition ??=
                  widget.attempt.addRepetition(widget.groupChallenge);
              return _progressListItem();
            }

            if (index == 1 &&
                widget.isSaveInsteadOfEditButtonVisible &&
                widget.isEditableByUser) {
              return _progressControllerListItem();
            }

            if (index == 2 &&
                widget.isSaveInsteadOfEditButtonVisible &&
                widget.isEditableByUser) {
              return _uploadMediaListItem();
            }

            return _mediaListItem(index);
          }),
    );
  }

  SpaceColumnComponent _mediaListItem(int index) {
    int newIndex = index - (widget.isSaveInsteadOfEditButtonVisible ? 3 : 1);
    MediaModel media = widget.initialMediaList.reversed.elementAt(newIndex);
    return SpaceColumnComponent(
      child: ListItemMediaSmallComponent(
        onTap: () => push(context, index: newIndex),
        media: media,
        isEditableByUser: widget.isEditableByUser,
        onTapDeleteMedia: () => onTapDeleteMedia(media),
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
      isEditable:
          widget.isSaveInsteadOfEditButtonVisible && widget.isEditableByUser,
      isFailed: widget.repetition != null
          ? widget.repetition!.repetitionStatus == RepetitionStatusEnum.failed
          : false,
      unit: widget.attempt.getAcceptanceCriteria(widget.groupChallenge).unit,
      setStateProgressList: () => setState(() {}),
    ));
  }

  void push(BuildContext context, {required int index}) {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => MediaDetailPage(
          mediaList: widget.initialMediaList,
          initialMediaIndex: index,
          attempt: widget.attempt,
          isEditableByUser: widget.isEditableByUser,
          onTapDelete: onTapDeleteMedia,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  cancelAndSaveButton() {
    return widget.isSaveInsteadOfEditButtonVisible
        ? Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: BottomNavigationComponent.standardMargin),
              child: Row(
                children: [
                  cancelButton(),
                  const SpaceComponent(),
                  saveButton(),
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
        onTap: onTapSave,
        isMainButton: true,
        margin: const EdgeInsets.only(right: 20),
        isLoading: _isSaveLoading,
      ),
    );
  }

  Expanded cancelButton() {
    return Expanded(
      child: ListItemButtonComponent(
        text: 'Cancel',
        onTap: onTapCancel,
        isMainButton: false,
        margin: const EdgeInsets.only(
            left: BottomNavigationComponent.standardMargin),
      ),
    );
  }

  deleteAndEditButton() {
    return !widget.isSaveInsteadOfEditButtonVisible
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
        margin: const EdgeInsets.only(right: 20),
      ),
    );
  }

  void onTapEdit() {
    setState(() {
      widget.isSaveInsteadOfEditButtonVisible = true;
    });
  }

  Expanded deleteButton() {
    return Expanded(
      child: ListItemButtonComponent(
        text: 'Delete',
        textColor: Theme.of(context).colorScheme.red,
        onTap: onTapDelete,
        isMainButton: false,
        margin: const EdgeInsets.only(left: 20),
      ),
    );
  }

  void onTapSave() async {
    if (_isSaveLoading) {
      return;
    }

    setState(() {
      _isSaveLoading = true;
    });

    if (widget.attempt.isInBacklog() && editProgress.progress > 0) {
      widget.attempt.start(widget.groupChallenge);
      widget.repetition =
          widget.attempt.getLastRepetition(widget.groupChallenge);
    } else if (widget.attempt.isInProgress() &&
        _currentRepetition != null &&
        _currentRepetition!.isInBacklog() &&
        editProgress.progress > 0) {
      _currentRepetition!.start();
      widget.repetition = _currentRepetition;
    }

    widget.repetition ??= widget.attempt.addRepetition(widget.groupChallenge);

    if (widget.progress == null) {
      widget.repetition!.addProgress(progress: editProgress);
    } else {
      widget.progress!.updateProgress(editProgress);
    }

    int index = widget.attempt.repetitions.indexWhere((repetitionEntry) =>
        repetitionEntry.repetitionNumber ==
        widget.repetition!.repetitionNumber);

    if (index == -1) {
      widget.attempt.repetitions.add(widget.repetition!);
    } else {
      widget.attempt.repetitions[index] = widget.repetition!;
    }

    widget.attempt.startDate ??= widget.attempt.repetitions
        .firstWhere((repetition) => repetition.repetitionNumber == 1,
            orElse: () => widget.repetition!)
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
      widget.isSaveInsteadOfEditButtonVisible = false;
    });

    for (int i = 0; i < widget.amountOfPops; i++) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  _onTapUploadMedia() async {
    MediaModel? media = await mediaService.openImagePicker(context);
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

  void onTapCancel() {
    if (!widget.isEditableByUser || widget.progress == null) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      widget.isSaveInsteadOfEditButtonVisible = false;
    });
  }

  void onTapDelete() {
    if (widget.repetition == null || widget.progress == null) {
      return;
    }

    setState(() {
      widget.repetition!.deleteProgress(widget.progress!);
    });
    widget.attempt.replaceRepetition(widget.repetition!);
    _groupChallengesProvider.updateAttempt(
        widget.groupChallenge, widget.participant, widget.attempt);
    Navigator.pop(context);
  }

  void onTapDeleteMedia(MediaModel media) {
    _groupChallengesProvider.deleteMediaFromAttempt(
        widget.groupChallenge, widget.participant, widget.attempt, media);
    setState(() {
      widget.initialMediaList.removeWhere((element) => element.id == media.id);
      editProgress.mediaIds.removeWhere((mediaId) => mediaId == media.id);
    });
  }
}
