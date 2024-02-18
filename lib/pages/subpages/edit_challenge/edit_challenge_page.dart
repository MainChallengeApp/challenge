// ignore_for_file: must_be_immutable
import 'package:challenge/components/simple_components/custom_button_component.dart';
import 'package:challenge/components/simple_components/custom_card_component.dart';
import 'package:challenge/components/simple_components/custom_container_component.dart';
import 'package:challenge/components/simple_components/space_component.dart';
import 'package:challenge/pages/subpages/edit_challenge/add_acceptance_criteria_page.dart';
import 'package:challenge/services/upload_media_service.dart';
import 'package:challenge/components/navigation/app_bar_component.dart';
import 'package:challenge/json_file_controller/challenge_controller.dart';
import 'package:challenge/pages/home/home_challenge_page.dart';
import 'package:challenge/utils/design_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:challenge/models/acceptance_criteria_model.dart';
import 'package:challenge/components/navigation/no_animation_page_route_component.dart';

class EditChallengePage extends StatefulWidget {
  final String preTitle;
  final ChallengeModel challenge;
  late ChallengeModel editChallenge;
  final bool isNewChallenge;
  final bool isTryAgain;
  final bool isSearchEdit;

  EditChallengePage(
      {super.key,
      required this.preTitle,
      required this.challenge,
      this.isSearchEdit = false,
      this.isNewChallenge = false,
      this.isTryAgain = false}) {
    editChallenge =
        ChallengeModel.copyChallenge(challenge, isTryAgain: isTryAgain);
  }

  @override
  State<EditChallengePage> createState() => _EditChallengePageState();
}

class _EditChallengePageState extends State<EditChallengePage> {
  int selectedAcceptanceCriteria = 0;

  ChallengeController challengeController = ChallengeController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBarComponent(
            preTitle: widget.preTitle,
            titleText: widget.isNewChallenge ? 'New Challenge' : 'Edit'),
        backgroundColor: Colors.white,
        body: CardComponent(
          scrollPhysics: const AlwaysScrollableScrollPhysics(),
          children: [
            thumbnailUploadAndTitle(),
            description(),
            startAndEndDate(),
            amountAndUnit(),
            // frequence(),
            Expanded(child: Container()),
            cancelAndSaveButton()
          ],
        ),
      ),
    );
  }

  cancelAndSaveButton() {
    return Row(
      children: [
        Expanded(
          child: CustomButtonComponent(
            onTap: onTapCancel,
            text: 'Cancel',
          ),
        ),
        const SpaceComponent(),
        Expanded(
          child: CustomButtonComponent(
            onTap: onTapSave,
            text: 'Save',
            isPrimaryButton: true,
          ),
        ),
      ],
    );
  }

  singleAcceptanceCriteria(int index) {
    return GestureDetector(
      onTap: () => onTapSingleAcceptanceCriteria(index),
      child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          child: Row(
            children: [
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 150, // Set your desired maximum width
                ),
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: themeColor4,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Text(
                  '${widget.editChallenge.acceptanceCriterias[index].title} ${widget.editChallenge.acceptanceCriterias[index].amount} ${widget.editChallenge.acceptanceCriterias[index].unit}',
                  style: const TextStyle(fontSize: 12, color: themeColor3),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: themeColor4,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Text(
                  widget.editChallenge.acceptanceCriterias[index].frequence,
                  style: const TextStyle(fontSize: 12, color: themeColor3),
                ),
              ),
              Expanded(child: Container()),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: themeColor4,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Icon(getIconData(index), color: themeColor3, size: 14),
              ),
            ],
          )),
    );
  }

  // addAcceptanceCriteriaButton() {
  //   return GestureDetector(
  //     onTap: onTapAddAcceptanceCriteriaButton,
  //     child: standardContainer(
  //       child: Row(
  //         children: [
  //           Container(
  //             width: 30,
  //             height: 30,
  //             margin: const EdgeInsets.only(right: 10),
  //             decoration: const BoxDecoration(
  //                 color: themeColor4,
  //                 borderRadius: BorderRadius.all(Radius.circular(12))),
  //             child: const Center(
  //                 child: Icon(
  //               Icons.add_rounded,
  //               color: themeColor3,
  //             )),
  //           ),
  //           const SizedBox(
  //             width: 200,
  //             height: 40,
  //             child: Align(
  //                 alignment: Alignment.centerLeft,
  //                 child: Text('Add Acceptance Criteria')),
  //           ),
  //           const Expanded(
  //             child: SizedBox(),
  //           ),
  //           const Icon(
  //             Icons.chevron_right_outlined,
  //             color: themeColor3,
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  startAndEndDate() {
    // widget.editChallenge.startDate ??= DateTime.now();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onTapStartOrEndDate('start'),
            child: standardContainer(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Start"),
                Text(
                  (widget.editChallenge.startDate != null
                      ? _dateFormat(widget.editChallenge.startDate!)
                      : '-'),
                  style: const TextStyle(color: themeColor3),
                ) // very bad workaround
              ],
            )),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () => onTapStartOrEndDate('end'),
            child: standardContainer(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("End"),
                Text(
                  (widget.editChallenge.endDate != null
                      ? _dateFormat(widget.editChallenge.endDate!)
                      : '-'),
                  style: const TextStyle(color: themeColor3),
                )
              ],
            )),
          ),
        ),
      ],
    );
  }

  description() {
    return CustomContainerComponent(
        heightFactor: 1.8,
        margin: const EdgeInsets.only(bottom: 16),
        child: TapRegion(
          child: TextField(
              maxLines: 999,
              onChanged: (value) => widget.editChallenge.description = value,
              controller: TextEditingController()
                ..text = widget.editChallenge.description,
              decoration:
                  const InputDecoration.collapsed(hintText: 'Description')),
        ));
  }

  storageLocation() {
    return standardContainer(
        child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
              color: themeColor4,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: const Center(
              child: Icon(
            Icons.save,
            color: themeColor3,
          )),
        ),
        const SizedBox(
          width: 200,
          height: 40,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Storage Location"),
          ),
        )
      ],
    ));
  }

  thumbnailUploadAndTitle() {
    return Row(
      children: [
        GestureDetector(
            onTap: () async {
              XFile? file = await UploadMediaService.onTapUploadMedia();
              setState(() {
                if (file != null) {
                  widget.editChallenge.thumbnailPath = file.path;
                }
              });
            },
            child: squardedStandardContainer(
                child: Center(
                    child: Container(
              width: 55,
              height: 55,
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                  child: widget.editChallenge.thumbnailPath != ''
                      ? Image.asset(widget.editChallenge.thumbnailPath,
                          fit: BoxFit.cover)
                      : const Center(
                          child: Icon(Icons.file_upload_rounded,
                              color: themeColor3),
                        )),
            )))),
        SizedBox(
          width: 16,
        ),
        Expanded(
            child: CustomContainerComponent(
          margin: const EdgeInsets.only(bottom: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextField(
                onChanged: (value) => widget.editChallenge.title = value,
                decoration: const InputDecoration.collapsed(hintText: 'Title'),
                controller: TextEditingController()
                  ..text = widget.editChallenge.title
                  ..selection = TextSelection.collapsed(
                      offset: widget.editChallenge.title.length)),
          ),
        ))
      ],
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

  squardedStandardContainer({required Widget child}) {
    return Container(
      width: 55,
      height: 55,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      child: child,
    );
  }

  acceptanceCriteria() {
    return Expanded(
      child: Container(
        height: 130,
        child: ListView.separated(
          itemCount: widget.editChallenge.acceptanceCriterias.length,
          separatorBuilder: (context, index) => const SizedBox(
            height: 16,
          ),
          itemBuilder: (_, i) {
            return singleAcceptanceCriteria(i);
          },
        ),
      ),
    );
  }

  IconData getIconData(int index) {
    if (widget.editChallenge.acceptanceCriterias[index].tracking == 'camera') {
      return Icons.camera_alt_outlined;
    } else if (widget.editChallenge.acceptanceCriterias[index].tracking ==
        'gps') {
      return Icons.gps_not_fixed;
    } else if (widget.editChallenge.acceptanceCriterias[index].tracking ==
        'notes') {
      return Icons.notes;
    } else if (widget.editChallenge.acceptanceCriterias[index].tracking ==
        'numbers') {
      return Icons.numbers;
    } else {
      return Icons.not_accessible;
    }
  }

  dots() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
            widget.editChallenge.acceptanceCriterias.length,
            (index) => Padding(
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 10, bottom: 23),
                  child: Icon(
                    Icons.fiber_manual_record,
                    size: 6,
                    color: index == selectedAcceptanceCriteria
                        ? themeColor3
                        : themeColor3.withAlpha(100),
                  ),
                )));
  }

  // void onTapAddAcceptanceCriteriaButton() {
  //   Navigator.push(
  //     context,
  //     NoAnimationPageRoute(
  //       builder: (context) => AddAcceptanceCriteria(
  //         preTitle:
  //             '${widget.preTitle}/${widget.challenge.title != '' ? '${widget.challenge.title}/Edit' : 'New Challenge'}',
  //         challenge: widget.editChallenge,
  //         acceptanceCriteria: AcceptanceCriteria(
  //             id: widget.challenge.acceptanceCriteria.length,
  //             activity: Activity(title: '', amount: 0, unit: ''),
  //             frequence: '',
  //             tracking: '',
  //             progress: 0,
  //             evidences: []),
  //         acceptanceCriteriaIndex: null,
  //       ),
  //     ),
  //   ).then((_) => setState(() {}));
  // }

  void onTapCancel() {
    Navigator.pop(context);
  }

  void onTapSave() async {
    // check inputs e.g. endDate > startDate

    widget.challenge.title = widget.editChallenge.title;
    widget.challenge.thumbnailPath = widget.editChallenge.thumbnailPath;
    widget.challenge.description = widget.editChallenge.description;
    widget.challenge.startDate = widget.editChallenge.startDate;
    widget.challenge.endDate = widget.editChallenge.endDate;
    widget.challenge.acceptanceCriterias =
        widget.editChallenge.acceptanceCriterias;

    if (widget.isSearchEdit) {
      Navigator.pop(context);
      return;
    }

    if (allChallengesList.contains(widget.challenge)) {
      // wip
      // challengeList.firstWhere((element) => element == widget.challenge).status =
      //         ChallengStatus.factory('Success');
      //     allChallengesList
      //         .where((element) => element == widget.challenge)
      //         .first
      //         .status = ChallengStatus.factory('Success');
      //     challengeController.writeFile(context, allChallengesList);

      allChallengesList.map((e) {
        if (e.id == widget.challenge.id) {
          return widget.challenge;
        }
        return e;
      }).toList(); //[widget.challenge.id!] = widget.challenge;
    } else {
      allChallengesList.insert(0, widget.challenge);
    }
    if (challengeList.contains(widget.challenge)) {
      challengeList.map((e) {
        if (e.id == widget.challenge.id) {
          return widget.challenge;
        }
        return e;
      }).toList(); //[widget.challenge.id!] = widget.challenge;
    } else {
      challengeList.insert(0, widget.challenge);
    }
    // var r = challengeList;
    // challengeList.insert(0, widget.challenge);
    challengeController.writeFile(context, allChallengesList);

    Navigator.pop(context);
    if (!widget.isSearchEdit && !widget.isNewChallenge && !widget.isTryAgain) {
      Navigator.pop(context);
    }

    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => HomeChallengePage(
            preTitle: 'Home', // very bad workaround
            challenge: widget.challenge,
            initialChalleneIndex: challengeList.indexOf(widget.challenge)),
      ),
    );
  }

  void onTapSingleAcceptanceCriteria(int index) {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => AddAcceptanceCriteriaPage(
          preTitle:
              '${widget.preTitle}/${widget.challenge.title != '' ? '${widget.challenge.title}/Edit' : 'New Challenge'}',
          challenge: widget.editChallenge,
          acceptanceCriteria: widget.editChallenge.acceptanceCriterias[index],
          acceptanceCriteriaIndex: index,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  void onTapStartOrEndDate(String startOrEnd) async {
    DateTime? initialDateTime = startOrEnd == 'start'
        ? widget.editChallenge.startDate
        : widget.editChallenge.endDate;
    setState(() {
      if (startOrEnd == 'start') {
        widget.editChallenge.startDate = null;
      } else {
        widget.editChallenge.endDate = null;
      }
    });

    bool isDateTimeChanged = false;

    await showCupertinoModalPopup(
      context: context,
      builder: (_) {
        final size = MediaQuery.of(context).size;
        return GestureDetector(
          onTap: () {
            if (startOrEnd == 'start') {
              setState(() {
                if (!isDateTimeChanged) {
                  widget.editChallenge.startDate =
                      initialDateTime ?? DateTime.now();
                }
              });
            } else {
              setState(() {
                if (!isDateTimeChanged) {
                  widget.editChallenge.endDate =
                      initialDateTime ?? DateTime.now();
                }
              });
            }
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            height: size.height * 0.27,
            child: CupertinoDatePicker(
              initialDateTime: initialDateTime,
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (value) {
                isDateTimeChanged = true;
                setState(() {
                  if (startOrEnd == 'start') {
                    widget.editChallenge.startDate = value;
                  } else if (startOrEnd == 'end') {
                    widget.editChallenge.endDate = value;
                  }
                });
              },
            ),
          ),
        );
      },
    );
  }

  String _dateFormat(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  amountAndUnit() {
    AcceptanceCriteriaModel acceptanceCriteria =
        widget.editChallenge.acceptanceCriterias[0];
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: standardContainer(
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextField(
                  textAlign: TextAlign.end,
                  controller: TextEditingController()
                    ..text = acceptanceCriteria.amount == 0
                        ? ''
                        : DesignUtil.doubleAsInt(acceptanceCriteria.amount)
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
                    if (value.endsWith('.')) {
                      acceptanceCriteria.amount =
                          double.parse(value.split('.')[0]);
                    } else if (value == '') {
                      acceptanceCriteria.amount = 0;
                    } else {
                      acceptanceCriteria.amount = double.parse(value);
                    }
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
                  controller: TextEditingController()
                    ..text = acceptanceCriteria.unit,
                  onChanged: (value) {
                    acceptanceCriteria.unit = value;
                  },
                  decoration: const InputDecoration.collapsed(hintText: 'Unit'),
                ),
              ),
            )),
      ],
    );
  }

  List<String> frequenceList = <String>['once', 'daily', 'weekly', 'monthly'];
  frequence() {
    if (widget.editChallenge.acceptanceCriterias.isEmpty) return Container();
    AcceptanceCriteriaModel acceptanceCriteria =
        widget.editChallenge.acceptanceCriterias[0];
    return standardContainer(
        child: DropdownButton<String>(
      isExpanded: true,
      value: acceptanceCriteria.frequence == ''
          ? null
          : acceptanceCriteria.frequence,
      icon: const Icon(Icons.expand_more),
      style: const TextStyle(color: Colors.black),
      hint: const Text('Frequence'),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          acceptanceCriteria.frequence = value!;
        });
      },
      items: frequenceList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    ));
  }
}
