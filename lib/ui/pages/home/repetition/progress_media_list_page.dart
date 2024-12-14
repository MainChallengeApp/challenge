import 'dart:math';

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
import 'package:challenge/services/media_service.dart';
import 'package:challenge/services/storage_service.dart';
import 'package:challenge/services/util_service.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/list_items/list_item_media_small_component.dart';
import 'package:challenge/ui/components/list_items/list_item_progress_component.dart';
import 'package:challenge/ui/components/list_items/list_item_progress_controller_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/pages/subpages/media/media_detail_page.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
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

  late ProgressModel editProgress = ProgressModel.copyOrCreateProgress(
      widget.progress,
      max(1, widget.attempt.getCurrentRepetitionNumber(widget.groupChallenge)),
      widget.initialMediaList.map((e) => e.id!).toList(),
      widget.repetition != null
          ? (widget.repetition!.getLastProgress() != null
              ? widget.repetition!.getLastProgress()!.progress
              : 0)
          : 0);

  late TextEditingController progressTextEditingController =
      TextEditingController(
          text: UtilService.doubleAsIntString(editProgress.progress));

  late final groupChallengeProvider = Provider.of<GroupChallengesProvider>(
    context,
    listen: false,
  );

  late final _notificationsProvider =
      Provider.of<NotificationsProvider>(context, listen: false);

  MediaService mediaService = MediaService();
  StorageService storageService = StorageService();

  bool _isSaveLoading = false;

  final String _title = 'Progress';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarComponent(
            title: widget.progress == null
                ? 'New Progress'
                : '$_title ${widget.repetition != null ? widget.repetition!.progressList.indexWhere((element) => element == widget.progress) + 1 : 1}'),
        backgroundColor: Colors.white,
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
    return RawScrollbar(
      controller: scrollController,
      radius: const Radius.circular(4),
      thumbColor: Theme.of(context).colorScheme.tertiary,
      padding: const EdgeInsets.only(right: 4),
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
              return SpaceColumnComponent(
                  child: ListItemProgressComponent(
                progress: editProgress,
                attempt: widget.attempt,
                groupChallenge: widget.groupChallenge,
                progressTextEditingController: progressTextEditingController,
                isEditable: widget.isSaveInsteadOfEditButtonVisible &&
                    widget.isEditableByUser,
                isFailed: widget.repetition != null
                    ? widget.repetition!.repetitionStatus ==
                        RepetitionStatusEnum.failed
                    : false,
                unit: widget.attempt
                    .getAcceptanceCriteria(widget.groupChallenge)
                    .unit,
                setStateProgressList: () => setState(() {}),
              ));
            }

            if (index == 1 &&
                widget.isSaveInsteadOfEditButtonVisible &&
                widget.isEditableByUser) {
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

            if (index == 2 &&
                widget.isSaveInsteadOfEditButtonVisible &&
                widget.isEditableByUser) {
              return SpaceColumnComponent(
                child: ListItemIconTextComponent(
                    onTap: onTapUploadMedia,
                    icon: IconEnum.upload.icon,
                    title: 'Upload Media'),
              );
            }
            int newIndex =
                index - (widget.isSaveInsteadOfEditButtonVisible ? 3 : 1);
            return SpaceColumnComponent(
              child: ListItemMediaSmallComponent(
                onTap: () => push(context, index: newIndex),
                media: widget.initialMediaList.reversed.elementAt(newIndex),
                isEditableByUser: widget.isEditableByUser,
                onTapDeleteMedia: () {
                  setState(() {
                    mediaService.deleteMedia(
                        widget.initialMediaList.reversed.elementAt(newIndex));
                    widget.attempt.removeMedia(
                        widget.initialMediaList.reversed.elementAt(newIndex));
                    widget.initialMediaList.removeWhere((media) =>
                        media.id ==
                        widget.initialMediaList.reversed
                            .elementAt(newIndex)
                            .id);
                    editProgress.mediaIds.removeAt(newIndex);
                  });
                },
              ),
            );
          }),
    );
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
          onTap: onTapDeleteMedia,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  cancelAndSaveButton() {
    return widget.isSaveInsteadOfEditButtonVisible
        ? Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                children: [
                  cancelButton(),
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
        margin: const EdgeInsets.only(left: 10, right: 20),
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
        margin: const EdgeInsets.only(left: 20, right: 10),
      ),
    );
  }

  deleteAndEditButton() {
    return !widget.isSaveInsteadOfEditButtonVisible
        ? Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                children: [
                  deleteButton(),
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
        margin: const EdgeInsets.only(left: 10, right: 20),
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
        margin: const EdgeInsets.only(left: 20, right: 10),
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
        widget.attempt.getCurrentRepetition(widget.groupChallenge) != null &&
        widget.attempt
            .getCurrentRepetition(widget.groupChallenge)!
            .isInBacklog() &&
        editProgress.progress > 0) {
      widget.attempt.getCurrentRepetition(widget.groupChallenge)!.start();
      widget.repetition =
          widget.attempt.getCurrentRepetition(widget.groupChallenge);
    }

    widget.repetition ??= widget.attempt.addRepetition(widget.groupChallenge);

    if (widget.progress == null) {
      widget.repetition!.addProgress(progress: editProgress);
    } else {
      widget.progress!.updateProgress(editProgress);
    }

    List<MediaModel> filteredMediaList = widget.initialMediaList
        .where((media) =>
            !widget.attempt.media.map((media) => media.id).contains(media.id))
        .toList();

    widget.attempt.media.addAll(filteredMediaList);

    await groupChallengeProvider.updateAttempt(
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

  onTapUploadMedia() async {
    MediaModel? media = await mediaService.openImagePicker(context);
    if (media == null) {
      return;
    }
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
    groupChallengeProvider.updateAttempt(
        widget.groupChallenge, widget.participant, widget.attempt);
    Navigator.pop(context);
  }

  void onTapDeleteMedia(MediaModel media) {
    mediaService.deleteMedia(media);
    setState(() {
      widget.initialMediaList.removeWhere((element) => element.id == media.id);
      widget.attempt.removeMedia(media);
      editProgress.mediaIds.removeWhere((mediaId) => mediaId == media.id);
    });
  }
}
