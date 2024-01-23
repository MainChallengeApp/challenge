// ignore_for_file: must_be_immutable
import 'package:challenge/components/list_items/list_item_icon_small_component.dart';
import 'package:challenge/components/list_items/list_item_acceptance_criteria_bar_component.dart';
import 'package:challenge/components/list_items/list_item_media_small_component.dart';
import 'package:challenge/components/navigation/app_bar_component.dart';
import 'package:challenge/json_file_controller/challenge_controller.dart';
import 'package:challenge/utils/design_util.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:challenge/models/acceptance_criteria_model.dart';
import 'package:challenge/models/activity_model.dart';
import 'package:challenge/models/evidence_model.dart';
import 'package:challenge/models/media_model.dart';
import 'package:challenge/providers/design_provider.dart';
import 'package:challenge/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/pages/subpages/media/media_detail_page.dart';
import 'package:challenge/services/upload_media_service.dart';

class AcceptanceCriteriaMediaListPage extends StatefulWidget {
  AcceptanceCriteriaMediaListPage(
      {super.key,
      required this.preTitle,
      required this.challenge,
      required this.initialMediaList,
      required this.acceptanceCriteria,
      this.evidence,
      this.isSaveInsteadOfEditButtonVisible = true}) {
    editAcceptanceCriteria = AcceptanceCriteriaModel(
        id: acceptanceCriteria.id,
        activity: ActivityModel(
            title: acceptanceCriteria.activity.title,
            amount: acceptanceCriteria.activity.amount,
            unit: acceptanceCriteria.activity.unit),
        frequence: acceptanceCriteria.frequence,
        tracking: acceptanceCriteria.tracking,
        progress: acceptanceCriteria.progress,
        evidences: acceptanceCriteria.evidences
            .map((e) =>
                EvidenceModel(progress: e.progress, mediaIds: e.mediaIds))
            .toList());
  }
  final String preTitle;
  final ChallengeModel challenge;
  final List<MediaModel> initialMediaList;
  final AcceptanceCriteriaModel acceptanceCriteria;
  late AcceptanceCriteriaModel editAcceptanceCriteria;
  final EvidenceModel? evidence;
  bool isSaveInsteadOfEditButtonVisible;

  @override
  State<AcceptanceCriteriaMediaListPage> createState() =>
      _AcceptanceCriteriaMediaListPageState();
}

class _AcceptanceCriteriaMediaListPageState
    extends State<AcceptanceCriteriaMediaListPage> {
  ChallengeController challengeController = ChallengeController();
  ScrollController scrollController = ScrollController();

  TextEditingController amountTextEditingController = TextEditingController();

  String searchBarText = "";

  late BuildContext context2;

  List<MediaModel> mediaList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mediaList = widget.initialMediaList;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          appBar: AppBarComponent(
              preTitle: widget.preTitle,
              titleText: widget.evidence == null
                  ? '${widget.acceptanceCriteria.evidences.length + 1}'
                  : '${widget.acceptanceCriteria.evidences.length - widget.acceptanceCriteria.evidences.indexOf(widget.evidence!)}'),
          backgroundColor: Colors.white,
          body: Stack(
            children: [_buildList(), progressButton()],
          )),
    );
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
          itemCount: widget.isSaveInsteadOfEditButtonVisible
              ? mediaList.length +
                  1 +
                  1 // +1 for progress bar +1 for upload Media when Save Button is visible
              : mediaList.length + 1,
          itemBuilder: (BuildContext content, int index) {
            if (index == 0) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: onTapProgressBar,
                    child: ListItemAcceptanceCriteriaBarComponent(
                      acceptanceCriteria: widget.acceptanceCriteria,
                      initialProgress: widget.evidence?.progress ??
                          widget.acceptanceCriteria.progress,
                      isProgressBarLocked:
                          !widget.isSaveInsteadOfEditButtonVisible,
                      editAcceptanceCriteria: widget.editAcceptanceCriteria,
                    ),
                  ),
                  const SizedBox(
                    height: 17,
                  )
                ],
              );
            }
            if (widget.isSaveInsteadOfEditButtonVisible) {
              if (index == 1) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: onTapProgressBar,
                      child: ListItemIconSmallComponent(
                          onTap: onTapUploadMedia,
                          icon: Icons.upload_rounded,
                          title: 'Upload Media'),
                    ),
                    const SizedBox(
                      height: 17,
                    )
                  ],
                );
              }
            } else {
              index += 1; // workaround to satisfiy index below
            }

            return Column(
              children: [
                ListItemMediaSmallComponent(
                  onTap: () => ppush(context, index: index - 1 - 1),
                  media: mediaList[index - 1 - 1],
                ),
                const SizedBox(
                  height: 17,
                )
              ],
            );
          }),
    );
  }

  changeList(String value) {
    setState(() {
      // challengesFutures = getChallenges(context);
      searchBarText = value;
    });
  }

  void ppush(BuildContext context, {required int index}) {
    context.read<DesignProvider>().setIsBottomNavBarVisible(false);
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => MediaDetailPage(
          media: mediaList,
          preTitle: '${widget.preTitle}/Media',
          initialMediaIdex: index,
          challenge: widget.challenge,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  progressButton() {
    return GestureDetector(
      onTap: onTapProgressBar,
      child: widget.isSaveInsteadOfEditButtonVisible
          ? Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 55,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: themeColor2,
                    border: Border.all(
                        width: 1,
                        color: const Color.fromRGBO(226, 232, 240, 1)),
                    borderRadius: const BorderRadius.all(Radius.circular(16))),
                child: Center(
                    child: Text(
                  widget.isSaveInsteadOfEditButtonVisible ? 'Progress' : 'Edit',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.white),
                )),
              ),
            )
          : Container(),
    );
  }

  saveButton() {
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

  void onTapSave() {
    if (widget.isSaveInsteadOfEditButtonVisible) {
      Navigator.pop(context2);
      // context.read<DesignProvider>().setIsBottomNavBarVisible(false);
      widget.acceptanceCriteria.progress =
          widget.editAcceptanceCriteria.progress;
      var evidence = EvidenceModel(
          progress: widget.acceptanceCriteria.progress,
          mediaIds: mediaList.map((e) => e.id!).toList());

      widget.acceptanceCriteria.evidences.insert(0, evidence);
      allChallengesList
          .firstWhere((element) => element.id == widget.challenge.id)
          .acceptanceCriterias
          .where((element) => element.id == widget.acceptanceCriteria.id)
          .toList()[0] = widget.acceptanceCriteria;

      challengeController.writeFile(context, allChallengesList);

      // List<String> titleList = widget.preTitle.split(
      //     '/'); // propably the worst workaround i ever did...sorry future developer but i am in a hurry to release this app on 01.01.2024 <3
      // if (titleList[2] == 'Evidence') {
      //   Navigator.pop(context);
      //   Navigator.pop(context);
      //   Navigator.pop(context);
      // } else {
      Navigator.pop(context);
      Navigator.pop(context);
      // }

      // Navigator.removeRoute(context, ModalRoute.of(context)!);
      // Navigator.removeRoute(context, ModalRoute.of(context)!);

      // Navigator.pop(context);
      // Navigator.pop(context);

      // setIsBottomNavBarVisibleToTrue();

      // context.read<DesignProvider>().setIsBottomNavBarVisible(false);
      // Navigator.push(
      //   context,
      //   NoAnimationPageRoute(
      //     builder: (context) => AcceptanceCriteriaEvidenceList(
      //       preTitle: splitTitle(widget.preTitle),
      //       acceptanceCriteria: widget.acceptanceCriteria,
      //       challenge: widget.challenge,
      //     ),
      //   ),
      // ).then((_) {
      //   navigatorKeys[TabItem.Home]!.currentState!.pop(context);
      //   navigatorKeys[TabItem.Home]!.currentState!.pop(context);
      // });
      // setIsBottomNavBarVisibleToTrue();
    } else {
      setState(() {
        widget.isSaveInsteadOfEditButtonVisible = true;
      });
    }

    // context.read<DesignProvider>().setIsBottomNavBarVisible(false);
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
                      saveButton()
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  Widget setProgressButtons() {
    return Row(
      children: [
        const SizedBox(
          width: 16,
        ),
        Expanded(
            flex: 1,
            child: GestureDetector(
                onTap: () => setState(() {
                      if (widget.editAcceptanceCriteria.progress - 1 >= 0) {
                        widget.editAcceptanceCriteria.progress -= 1;
                        amountTextEditingController.text =
                            DesignUtil.doubleAsInt(
                                    widget.editAcceptanceCriteria.progress)
                                .toString();
                      } else {
                        widget.editAcceptanceCriteria.progress = 0;
                        amountTextEditingController.text =
                            DesignUtil.doubleAsInt(
                                    widget.editAcceptanceCriteria.progress)
                                .toString();
                      }
                    }),
                child: standardContainer(
                    child: const Center(
                  child: Text('-1'),
                )))),
        const SizedBox(
          width: 16,
        ),
        Expanded(
            flex: 1,
            child: GestureDetector(
                onTap: () => setState(() {
                      widget.editAcceptanceCriteria.progress += 1;
                      amountTextEditingController.text = DesignUtil.doubleAsInt(
                              widget.editAcceptanceCriteria.progress)
                          .toString();
                    }),
                child: standardContainer(
                    child: const Center(
                  child: Text('+1'),
                )))),
        const SizedBox(
          width: 16,
        ),
        Expanded(
            flex: 2,
            child: GestureDetector(
                onTap: () => setState(() {
                      widget.editAcceptanceCriteria.progress =
                          widget.acceptanceCriteria.activity.amount;
                      amountTextEditingController.text = DesignUtil.doubleAsInt(
                              widget.editAcceptanceCriteria.progress)
                          .toString();
                    }),
                child: standardContainer(
                    child: const Center(
                  child: Text('100%'),
                )))),
        const SizedBox(
          width: 16,
        ),
      ],
    );
  }

  amountAndUnit() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: standardContainer(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    textAlign: TextAlign.end,
                    controller: amountTextEditingController
                      ..text = DesignUtil.doubleAsInt(
                              widget.editAcceptanceCriteria.progress)
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
                          widget.editAcceptanceCriteria.progress = number;
                        } else if (value == '') {
                          widget.editAcceptanceCriteria.progress = 0;
                        } else {
                          number = double.parse(value);
                          widget.editAcceptanceCriteria.progress = number;
                        }
                      });
                    },
                    decoration:
                        const InputDecoration.collapsed(hintText: 'Amount'),
                  ),
                ),
              )),
          const SizedBox(
            width: 16,
          ),
          Expanded(
              flex: 2,
              child: standardContainer(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    enabled: false,
                    controller: TextEditingController()
                      ..text = widget.acceptanceCriteria.activity.unit,
                    decoration:
                        const InputDecoration.collapsed(hintText: 'Unit'),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  standardContainer({required Widget child, double heightFactor = 1}) {
    return Container(
      // width: double.infinity,
      height: 55 * heightFactor,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      child: child,
    );
  }

  onTapUploadMedia() async {
    XFile? file = await UploadMediaService.onTapUploadMedia();
    if (file != null) {
      setState(() {
        MediaModel media = MediaModel(
            type: 'image',
            title: DateTime.now().toString().split('.')[0],
            source: file.path);

        widget.challenge.media.add(media);
        mediaList.add(media);
      });
    }
  }
}
