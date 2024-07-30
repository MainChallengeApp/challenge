import 'package:challenge/components/list_items/list_item_button_component.dart';
import 'package:challenge/components/list_items/list_item_icon_small_component.dart';
import 'package:challenge/components/list_items/list_item_media_small_component.dart';
import 'package:challenge/components/list_items/list_item_progress_component.dart';
import 'package:challenge/components/list_items/list_item_progress_controller_component.dart';
import 'package:challenge/components/navigation/app_bar_component.dart';
import 'package:challenge/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/components/simple_components/custom_container_component.dart';
import 'package:challenge/components/simple_components/space_column_component.dart';
import 'package:challenge/enums/media_type_enum.dart';
import 'package:challenge/enums/repetition_status_enum.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/json_file_controller/challenge_controller.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:challenge/models/media_model.dart';
import 'package:challenge/models/progress_model.dart';
import 'package:challenge/models/repetition_model.dart';
import 'package:challenge/pages/subpages/media/media_detail_page.dart';
import 'package:challenge/services/challenge_service.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/utils/design_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class ProgressMediaListPage extends StatefulWidget {
  ProgressMediaListPage(
      {super.key,
      required this.preTitle,
      required this.challenge,
      this.repetition,
      this.initialMediaList,
      this.progress,
      this.isSaveInsteadOfEditButtonVisible = true});

  final String preTitle;
  final ChallengeModel challenge;
  RepetitionModel? repetition;
  List<MediaModel>? initialMediaList;
  ProgressModel? progress;
  bool isSaveInsteadOfEditButtonVisible;

  @override
  State<ProgressMediaListPage> createState() => _ProgressMediaListPageState();
}

class _ProgressMediaListPageState extends State<ProgressMediaListPage> {
  ChallengeController challengeController = ChallengeController();
  ScrollController scrollController = ScrollController();

  TextEditingController amountTextEditingController = TextEditingController();

  late List<MediaModel> mediaList =
      MediaModel.copyMediaList(widget.initialMediaList ?? []);

  late ProgressModel editProgress = ProgressModel.copyOrCreateProgress(
      widget.progress,
      widget.challenge.getCurrentRepetitionNumber() == 0
          ? 1
          : widget.challenge.getCurrentRepetitionNumber(),
      mediaList.map((e) => e.id!).toList(),
      widget.repetition != null
          ? (widget.repetition!.getLastProgress() != null
              ? widget.repetition!.getLastProgress()!.progress
              : 0)
          : 0);

  BuildContext? context2;

  ChallengeService challengeService = ChallengeService();

  MediaService mediaService = MediaService();

  @override
  Widget build(BuildContext context) {
    editProgress.setProgress(
        widget.challenge.acceptanceCriteria, editProgress.progress);
    return Scaffold(
        appBar: AppBarComponent(
            preTitle: widget.preTitle,
            titleText: widget.progress == null
                ? 'New Progress'
                : '${widget.repetition != null ? widget.repetition!.progressList.indexWhere((element) => element == widget.progress) + 1 : 1}'),
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Stack(
            children: [
              _buildList(),
              widget.isSaveInsteadOfEditButtonVisible
                  ? cancelAndSaveButton()
                  : deleteAndEditButton()
            ],
          ),
        ));
  }

  Widget _buildList() {
    return RawScrollbar(
      controller: scrollController,
      radius: const Radius.circular(4),
      thumbColor: themeColor3,
      padding: const EdgeInsets.only(right: 4),
      child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          itemCount: mediaList.length +
              1 +
              (widget.isSaveInsteadOfEditButtonVisible
                  ? 2
                  : 0) // +1 for progress controller list item
          , // +1 for progress bar +1 for upload Media
          itemBuilder: (BuildContext content, int index) {
            if (index == 0) {
              return SpaceColumnComponent(
                  child: ListItemProgressComponent(
                onTap: !widget.isSaveInsteadOfEditButtonVisible
                    ? null
                    : onTapProgressBar,
                progress: editProgress,
                challenge: widget.challenge,
                isEditable: widget.isSaveInsteadOfEditButtonVisible,
                isFailed: widget.repetition != null
                    ? widget.repetition!.repetitionStatus ==
                        RepetitionStatusEnum.failed
                    : false,
                unit: widget.challenge.acceptanceCriteria.unit,
              ));
            }

            if (index == 1 && widget.isSaveInsteadOfEditButtonVisible) {
              return SpaceColumnComponent(
                child: ListItemProgressControllerComponent(
                  challenge: widget.challenge,
                  editProgress: editProgress,
                  progressListSetState: () => setState(() {}),
                ),
              );
            }

            if (index == 2 && widget.isSaveInsteadOfEditButtonVisible) {
              return SpaceColumnComponent(
                child: ListItemIconSmallComponent(
                    onTap: onTapUploadMedia,
                    icon: Icons.upload_rounded,
                    title: 'Upload Media'),
              );
            }
            int newIndex =
                index - (widget.isSaveInsteadOfEditButtonVisible ? 3 : 1);
            return SpaceColumnComponent(
              child: ListItemMediaSmallComponent(
                onTap: () => push(context, index: newIndex),
                media: mediaList.reversed.elementAt(newIndex),
                onTapDeleteMedia: () {
                  setState(() {
                    mediaService.deleteMedia(
                        mediaList.reversed.elementAt(newIndex),
                        widget.challenge);
                    mediaList.removeWhere((media) =>
                        media.id == mediaList.reversed.elementAt(newIndex).id);
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
          mediaList: mediaList,
          preTitle: '${widget.preTitle}/Media',
          initialMediaIndex: index,
          challenge: widget.challenge,
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
        onTap: () => setState(() {
          widget.isSaveInsteadOfEditButtonVisible = true;
        }),
        isMainButton: true,
        margin: const EdgeInsets.only(left: 10, right: 20),
      ),
    );
  }

  Expanded deleteButton() {
    return Expanded(
      child: ListItemButtonComponent(
        text: 'Delete',
        textColor: red.withAlpha(200),
        onTap: onTapDelete,
        isMainButton: false,
        margin: const EdgeInsets.only(left: 20, right: 10),
      ),
    );
  }

  dialogSaveButton() {
    return GestureDetector(
      onTap: onTapSave,
      child: widget.isSaveInsteadOfEditButtonVisible
          ? Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 55,
                margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                decoration: BoxDecoration(
                    color: themeColor2,
                    border: Border.all(
                        width: 1,
                        color: const Color.fromRGBO(226, 232, 240, 1)),
                    borderRadius: const BorderRadius.all(Radius.circular(16))),
                child: Center(
                    child: Text(
                  widget.isSaveInsteadOfEditButtonVisible ? 'Save' : 'Edit',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.white),
                )),
              ),
            )
          : Container(),
    );
  }

  void onTapSave() async {
    if (widget.isSaveInsteadOfEditButtonVisible) {
      if (context2 != null) {
        Navigator.pop(context2!);
      }

      if (widget.challenge.isInBacklog() && editProgress.progress > 0) {
        challengeService.startChallenge(widget.challenge);
        widget.repetition = widget.challenge.getLastRepetition();
      } else if (widget.challenge.isInProgress() &&
          widget.challenge.getCurrentRepetition() != null &&
          widget.challenge.getCurrentRepetition()!.isInBacklog() &&
          editProgress.progress > 0) {
        widget.challenge.getCurrentRepetition()!.start();
        widget.repetition = widget.challenge.getCurrentRepetition();
      }

      widget.repetition ??= widget.challenge.addRepetition();

      // context.read<DesignProvider>().setIsBottomNavBarVisible(false);
      if (widget.progress == null) {
        widget.repetition!.addProgress(progress: editProgress);
      } else {
        widget.progress!.updateProgress(editProgress);
      }

      allChallengesList = allChallengesList
          .map((oldChallenge) => oldChallenge.id == widget.challenge.id
              ? widget.challenge
              : oldChallenge)
          .toList();

      challengeList = challengeList
          .map((oldChallenge) => oldChallenge.id == widget.challenge.id
              ? widget.challenge
              : oldChallenge)
          .toList();

      challengeController.writeFile(allChallengesList);

      Navigator.pop(context);
      Navigator.pop(context);
      // only show Repetition Page, when its in the navigation stack
      // Navigator.push(
      //     context,
      //     NoAnimationPageRouteComponent(
      //       builder: (context) => RepetitionPage(
      //           preTitle: 'Home/${widget.challenge.title}',
      //           challenge: widget.challenge),
      //     )).then((_) {
      //   challengeList =
      //       ChallengeModel.sortChallengeList(challenges: challengeList);

      //   // int index = challengeList.indexWhere((c) => c.id == widget.challenge.id);

      //   // pageController.jumpToPage(index); some how need to jump to the right page and setState
      // });
    } else {
      setState(() {
        widget.isSaveInsteadOfEditButtonVisible = true;
      });
    }
  }

  String splitTitle(String title) {
    // Find the index of the last '/' in the string
    int lastIndex = title.lastIndexOf('/');

    if (lastIndex != -1 && lastIndex > 0) {
      // Extract the portion of the string up to the last '/'
      String result = title.substring(0, lastIndex);
      return result;
    } else {
      return title;
    }
  }

  void onTapProgressBar() {
    if (widget.isSaveInsteadOfEditButtonVisible) {
      showDialog(
        context: context,
        builder: (context) {
          context2 = context;
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Dialog(
              insetPadding: const EdgeInsets.only(
                  top: 150, bottom: 120, left: 50, right: 50),
              alignment: Alignment.center,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24))),
              child: SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(24))),
                  child: Column(
                    children: [
                      amountAndUnit(),
                      setProgressButtons(),
                      dialogSaveButton()
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ).whenComplete(() => context2 = null);
    }
  }

  Widget setProgressButtons() {
    return SpaceColumnComponent(
      child: Row(
        children: [
          const SizedBox(
            width: 16,
          ),
          Expanded(
              flex: 1,
              child: GestureDetector(
                  onTap: () => setState(() {
                        if (editProgress.progress - 1 >= 0) {
                          editProgress.progress -= 1;
                          amountTextEditingController.text =
                              DesignUtil.doubleAsIntString(
                                      editProgress.progress)
                                  .toString();
                        } else {
                          editProgress.progress = 0;
                          amountTextEditingController.text =
                              DesignUtil.doubleAsIntString(
                                      editProgress.progress)
                                  .toString();
                        }
                      }),
                  child: const CustomContainerComponent(
                      child: Center(
                    child: Text('-1'),
                  )))),
          const SizedBox(
            width: 16,
          ),
          Expanded(
              flex: 1,
              child: GestureDetector(
                  onTap: () => setState(() {
                        editProgress.progress += 1;
                        amountTextEditingController.text =
                            DesignUtil.doubleAsIntString(editProgress.progress)
                                .toString();
                      }),
                  child: const CustomContainerComponent(
                      child: Center(
                    child: Text('+1'),
                  )))),
          const SizedBox(
            width: 16,
          ),
          Expanded(
              flex: 2,
              child: GestureDetector(
                  onTap: () => setState(() {
                        editProgress.progress =
                            widget.challenge.acceptanceCriteria.amount;
                        amountTextEditingController.text =
                            DesignUtil.doubleAsIntString(editProgress.progress)
                                .toString();
                      }),
                  child: const CustomContainerComponent(
                      child: Center(
                    child: Text('100%'),
                  )))),
          const SizedBox(
            width: 16,
          ),
        ],
      ),
    );
  }

  amountAndUnit() {
    return SpaceColumnComponent(
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: CustomContainerComponent(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextField(
                      textAlign: TextAlign.end,
                      controller: amountTextEditingController
                        ..text =
                            DesignUtil.doubleAsIntString(editProgress.progress)
                                .toString(),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                        TextInputFormatter.withFunction(
                          (oldValue, newValue) => newValue.copyWith(
                            text: newValue.text.replaceAll(',', '.'),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          double number = 0;
                          if (value.endsWith('.')) {
                            number = double.parse(value.split('.')[0]);
                            editProgress.progress = number;
                          } else if (value == '') {
                            editProgress.progress = 0;
                          } else {
                            number = double.parse(value);
                            editProgress.progress = number;
                          }
                        });
                      },
                      decoration:
                          const InputDecoration.collapsed(hintText: '0'),
                    ),
                  ),
                )),
            const SizedBox(
              width: 16,
              child: Center(
                child: Text(
                  '/',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            Expanded(
                flex: 2,
                child: CustomContainerComponent(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      enabled: false,
                      style: const TextStyle(color: Colors.grey),
                      controller: TextEditingController()
                        ..text =
                            '${DesignUtil.doubleAsIntString(widget.challenge.acceptanceCriteria.amount)} ${widget.challenge.acceptanceCriteria.unit}',
                      decoration:
                          const InputDecoration.collapsed(hintText: 'Unit'),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  // CustomContainerComponent({required Widget child, double heightFactor = 1}) {
  //   return Container(
  //     // width: double.infinity,
  //     height: 55 * heightFactor,
  //     padding: const EdgeInsets.all(10),
  //     margin: const EdgeInsets.only(bottom: 16),
  //     decoration: BoxDecoration(
  //         color: Colors.white,
  //         border: Border.all(
  //             width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
  //         borderRadius: const BorderRadius.all(Radius.circular(16))),
  //     child: child,
  //   );
  // }

  onTapUploadMedia() async {
    XFile? file = await mediaService.onTapUploadMedia();
    if (file != null) {
      setState(() {
        MediaModel media = MediaModel(
            type: MediaTypeEnum.image,
            title: DateTime.now().toString().split('.')[0],
            source: file.path);

        widget.challenge.media.add(media);
        editProgress.mediaIds.add(media.id!);
        mediaList.add(media);
      });
    }
  }

  void onTapCancel() {
    if (widget.progress == null) {
      Navigator.pop(context);
      return;
    } else {
      setState(() {
        widget.isSaveInsteadOfEditButtonVisible = false;
      });
    }
  }

  int countCharOccurrences(String text, String charToCount) {
    int count = 0;
    for (int i = 0; i < text.length; i++) {
      if (text[i] == charToCount) {
        count++;
      }
    }
    return count;
  }

  void onTapDelete() {
    if (widget.repetition == null || widget.progress == null) {
      return;
    }

    setState(() {
      challengeService.deleteProgress(widget.challenge, widget.repetition!,
          widget.repetition!.progressList.indexOf(widget.progress!));
    });
    Navigator.pop(context);
  }

  void onTapDeleteMedia(MediaModel media) {
    mediaService.deleteMedia(media, widget.challenge);

    setState(() {
      mediaList.removeWhere((element) => element.id == media.id);
      editProgress.mediaIds.removeWhere((mediaId) => mediaId == media.id);
    });
  }
}
