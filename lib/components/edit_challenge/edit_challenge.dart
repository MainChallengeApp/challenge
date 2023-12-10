// ignore_for_file: must_be_immutable

import 'package:challenge/components/edit_challenge/add_acceptance_criteria.dart';
import 'package:challenge/components/edit_challenge/date_picker.dart';
import 'package:challenge/json_file_controller/challenge_controller.dart';
import 'package:challenge/pages/home/home_challenge.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge.dart';

import '../../models/acceptance_criteria.dart';
import '../../models/activity.dart';
import '../navigation/no_animation_page_route.dart';

class EditChallenge extends StatefulWidget {
  final Function? homeListSetState;

  bool isNewChallenge;

  bool isTryAgain;

  EditChallenge(
      {super.key,
      required this.title,
      required this.challenge,
      this.selectTab,
      this.homeListSetState,
      this.isSearchEdit = false,
      this.isNewChallenge = false,
      this.isTryAgain = false}) {
    title = title;
    challenge = challenge;
    editChallenge = Challenge(
        status: challenge.status,
        title: challenge.title,
        description: challenge.description,
        thumbnailPath: challenge.thumbnailPath,
        startDate: challenge.startDate,
        endDate: challenge.endDate,
        acceptanceCriteria:
            copyAcceptanceCriteria(challenge.acceptanceCriteria),
        media: []);
  }
  String title;
  Challenge challenge;
  late Challenge editChallenge;
  final Function? selectTab;
  final bool isSearchEdit;

  @override
  State<EditChallenge> createState() => _EditChallengeState();

  copyAcceptanceCriteria(List<AcceptanceCriteria> acceptanceCriteria) {
    List<AcceptanceCriteria> acceptanceCriteriaList = [];
    acceptanceCriteria.forEach((e) {
      acceptanceCriteriaList.add(AcceptanceCriteria(
          id: e.id,
          activity: Activity(
              title: e.activity.title,
              amount: e.activity.amount,
              unit: e.activity.unit),
          frequence: e.frequence,
          tracking: e.tracking,
          progress: e.progress,
          evidences: e.evidences));
    });
    return acceptanceCriteriaList;
  }
}

class _EditChallengeState extends State<EditChallenge> {
  bool isDescriptionExpanded = false;
  int selectedAcceptanceCriteria = 0;

  ChallengeController challengeController = ChallengeController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          titleSpacing: 0,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(right: 24),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  '${widget.title}/${widget.challenge.title != '' ? '${widget.challenge.title}/Edit' : 'New Challenge'}',
                  style: const TextStyle(
                      color: Colors.black, fontSize: appBarFontSize),
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16, left: 20, right: 20),
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              height: 120 + 8 * 64 + 2,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
                  borderRadius: const BorderRadius.all(Radius.circular(24))),
              child: Column(
                children: [
                  thumbnailUploadAndTitle(),
                  // storageLocation(),
                  description(),
                  startAndEndDate(),
                  addAcceptanceCriteriaButton(),
                  acceptanceCriteria(),
                  buttons()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  buttons() {
    return Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Expanded(
            //   child: Container(
            //     height: 55,
            //     width: 100,
            //     decoration: BoxDecoration(
            //         color: Colors.white,
            //         border: Border.all(
            //             width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
            //         borderRadius: const BorderRadius.all(Radius.circular(16))),
            //     child: const Center(
            //         child: Text(
            //       'Delete',
            //       style:
            //           TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
            //     )),
            //   ),
            // ),
            // const SizedBox(
            //   width: 16,
            // ),
            Expanded(
              child: GestureDetector(
                onTap: onTapSave,
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                      color: themeColor2,
                      border: Border.all(
                          width: 1,
                          color: const Color.fromRGBO(226, 232, 240, 1)),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(16))),
                  child: const Center(
                      child: Text(
                    'Save',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.white),
                  )),
                ),
              ),
            ),
          ],
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
                    color: Color.fromRGBO(241, 245, 249, 1),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Text(
                  '${widget.editChallenge.acceptanceCriteria[index].activity.title} ${widget.editChallenge.acceptanceCriteria[index].activity.amount} ${widget.editChallenge.acceptanceCriteria[index].activity.unit}',
                  style: const TextStyle(fontSize: 12, color: themeColor3),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(241, 245, 249, 1),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Text(
                  widget.editChallenge.acceptanceCriteria[index].frequence,
                  style: const TextStyle(fontSize: 12, color: themeColor3),
                ),
              ),
              Expanded(child: Container()),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(241, 245, 249, 1),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Icon(getIconData(index), color: themeColor3, size: 14),
              ),
            ],
          )),
    );
  }

  addAcceptanceCriteriaButton() {
    return GestureDetector(
      onTap: onTapAddAcceptanceCriteriaButton,
      child: standardContainer(
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.only(right: 10),
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(241, 245, 249, 1),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: const Center(
                  child: Icon(
                Icons.add,
                color: themeColor3,
              )),
            ),
            const SizedBox(
              width: 200,
              height: 40,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Add Acceptance Criteria')),
            ),
            const Expanded(
              child: SizedBox(),
            ),
            const Icon(
              Icons.chevron_right_outlined,
              color: themeColor3,
            )
          ],
        ),
      ),
    );
  }

  startAndEndDate() {
    // widget.editChallenge.startDate ??= DateTime.now();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: standardContainer(
                child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Start"),
            DatePickerExample(
                restorationId: 'main',
                initialDate: widget.editChallenge.startDate ?? DateTime.now(),
                editChallenge: widget.editChallenge,
                isActualEmpty: widget.editChallenge.startDate == null,
                isStartDate: true) // very bad workaround
          ],
        ))),
        const SizedBox(width: 16),
        Expanded(
            child: standardContainer(
                child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("End"),
            DatePickerExample(
              restorationId: 'main',
              initialDate: widget.editChallenge.endDate ?? DateTime.now(),
              editChallenge: widget.editChallenge,
              isStartDate: false,
              isActualEmpty: widget.editChallenge.endDate == null,
            ) // very bad workaround
          ],
        ))),
      ],
    );
  }

  description() {
    return standardContainer(
        heightFactor: 1.8,
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
              color: Color.fromRGBO(241, 245, 249, 1),
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

  Container thumbnailUploadAndTitle() {
    return standardContainer(
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
                image: widget.challenge.thumbnailPath != ''
                    ? DecorationImage(
                        image: AssetImage(widget.editChallenge.thumbnailPath),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: const Color.fromRGBO(241, 245, 249, 1),
                borderRadius: const BorderRadius.all(Radius.circular(12))),
            child: widget.editChallenge.thumbnailPath != ''
                ? null
                : const Icon(
                    Icons.upload,
                    color: themeColor3,
                  ),
          ),
          SizedBox(
            width: 230,
            height: 30,
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextField(
                  onChanged: (value) => widget.editChallenge.title = value,
                  decoration:
                      const InputDecoration.collapsed(hintText: 'Title'),
                  controller: TextEditingController()
                    ..text = widget.editChallenge.title
                    ..selection = TextSelection.collapsed(
                        offset: widget.editChallenge.title.length)),
            ),
          )
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

  acceptanceCriteria() {
    return Expanded(
      child: Container(
        height: 130,
        child: ListView.separated(
          itemCount: widget.editChallenge.acceptanceCriteria.length,
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
    if (widget.editChallenge.acceptanceCriteria[index].tracking == 'camera') {
      return Icons.camera_alt_outlined;
    } else if (widget.editChallenge.acceptanceCriteria[index].tracking ==
        'gps') {
      return Icons.gps_not_fixed;
    } else if (widget.editChallenge.acceptanceCriteria[index].tracking ==
        'notes') {
      return Icons.notes;
    } else if (widget.editChallenge.acceptanceCriteria[index].tracking ==
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
            widget.editChallenge.acceptanceCriteria.length,
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

  void onTapAddAcceptanceCriteriaButton() {
    Navigator.push(
      context,
      NoAnimationPageRoute(
        builder: (context) => AddAcceptanceCriteria(
          preTitle:
              '${widget.title}/${widget.challenge.title != '' ? '${widget.challenge.title}/Edit' : 'New Challenge'}',
          challenge: widget.editChallenge,
          acceptanceCriteria: AcceptanceCriteria(
              id: widget.challenge.acceptanceCriteria.length,
              activity: Activity(title: '', amount: 0, unit: ''),
              frequence: '',
              tracking: '',
              progress: 0,
              evidences: []),
          acceptanceCriteriaIndex: null,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  void onTapSave() async {
    // check inputs e.g. endDate > startDate

    widget.challenge.title = widget.editChallenge.title;
    widget.challenge.description = widget.editChallenge.description;
    widget.challenge.startDate = widget.editChallenge.startDate;
    widget.challenge.endDate = widget.editChallenge.endDate;
    widget.challenge.acceptanceCriteria =
        widget.editChallenge.acceptanceCriteria;

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
      NoAnimationPageRoute(
        builder: (context) => HomeChallenge(
            preTitle: widget.title,
            challenge: widget.challenge,
            initialChalleneIndex: challengeList.indexOf(widget.challenge)),
      ),
    ).then((_) {
      // widget.homeListSetState!.call();
    });
  }

  void onTapSingleAcceptanceCriteria(int index) {
    Navigator.push(
      context,
      NoAnimationPageRoute(
        builder: (context) => AddAcceptanceCriteria(
          preTitle:
              '${widget.title}/${widget.challenge.title != '' ? '${widget.challenge.title}/Edit' : 'New Challenge'}',
          challenge: widget.editChallenge,
          acceptanceCriteria: widget.editChallenge.acceptanceCriteria[index],
          acceptanceCriteriaIndex: index,
        ),
      ),
    ).then((_) => setState(() {}));
  }
}
