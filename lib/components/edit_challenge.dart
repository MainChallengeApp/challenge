import 'package:challenge/components/add_acceptance_criteria.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge.dart';

class EditChallenge extends StatefulWidget {
  const EditChallenge(
      {super.key, required this.title, required this.challenge});
  final String title;
  final Challenge challenge;

  @override
  State<EditChallenge> createState() => _EditChallengeState();
}

class _EditChallengeState extends State<EditChallenge> {
  bool isDescriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '${widget.title}/${widget.challenge.title != '' ? '${widget.challenge.title}/Edit' : 'New Challenge'}',
            style:
                const TextStyle(color: Colors.black, fontSize: appBarFontSize),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
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
              acceptanceCriteriaButton(),
              acceptanceCriteria(),
              // SizedBox(
              //   height: 100,
              //   child: ListView.separated(
              //     separatorBuilder: (context, index) => const SizedBox(
              //       height: 16,
              //     ),
              //     itemCount: widget.challenge.acceptanceCriteria.length,
              //     itemBuilder: (context, index) =>
              //         singleAcceptanceCriteria(index),
              //   ),
              // ),
              // const Expanded(child: SizedBox()),
              buttons()
            ],
          ),
        ),
      ),
    );
  }

  buttons() {
    return Column(
      children: [
        SizedBox(height: 16,),
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
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                    color: themeColor2,
                    border: Border.all(
                        width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
                    borderRadius: const BorderRadius.all(Radius.circular(16))),
                child: const Center(
                    child: Text(
                  'Save',
                  style:
                      TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
                )),
              ),
            ),
          ],
        ),
      ],
    );
  }

  singleAcceptanceCriteria(int index) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(
                width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
            borderRadius: const BorderRadius.all(Radius.circular(16))),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(241, 245, 249, 1),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Text(
                '${widget.challenge.acceptanceCriteria[index].activity.title} ${widget.challenge.acceptanceCriteria[index].activity.amount} ${widget.challenge.acceptanceCriteria[index].activity.unit}',
                style: const TextStyle(fontSize: 12, color: themeColor3),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(241, 245, 249, 1),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Text(
                widget.challenge.acceptanceCriteria[index].frequence,
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
        ));
  }

  acceptanceCriteriaButton() {
    return GestureDetector(
      onTap: onTapAcceptanceCriteriaButton,
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

  Row startAndEndDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: standardContainer(
                child: const Align(
                    alignment: Alignment.centerLeft, child: Text("Start")))),
        const SizedBox(width: 16),
        Expanded(
            child: standardContainer(
                child: const Align(
                    alignment: Alignment.centerLeft, child: Text("End")))),
      ],
    );
  }

  Container description() {
    return standardContainer(
        heightFactor: 2,
        child: TapRegion(
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          child: TextField(
              controller: TextEditingController()
                ..text = widget.challenge.description,
              decoration:
                  const InputDecoration.collapsed(hintText: 'Description')),
        ));
  }

  Container storageLocation() {
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
                        image: AssetImage(widget.challenge.thumbnailPath),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: const Color.fromRGBO(241, 245, 249, 1),
                borderRadius: const BorderRadius.all(Radius.circular(12))),
            child: widget.challenge.thumbnailPath != ''
                    ? null : const Icon(Icons.upload, color: themeColor3,) ,
          ),
          SizedBox(
            width: 200,
            height: 40,
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextField(
                decoration: const InputDecoration.collapsed(hintText: 'Title'),
                controller: TextEditingController()
                  ..text = widget.challenge.title,
              ),
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

  int selectedAcceptanceCriteria = 0;

  acceptanceCriteria() {
    return Expanded(
      child: Container(
        height: 130,
        child: ListView.separated(
          itemCount: widget.challenge.acceptanceCriteria.length,
          separatorBuilder: (context, index) => SizedBox(
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
    if (widget.challenge.acceptanceCriteria[index].tracking == 'camera') {
      return Icons.camera_alt_outlined;
    } else if (widget.challenge.acceptanceCriteria[index].tracking == 'gps') {
      return Icons.gps_not_fixed;
    } else if (widget.challenge.acceptanceCriteria[index].tracking == 'notes') {
      return Icons.notes;
    } else if (widget.challenge.acceptanceCriteria[index].tracking ==
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
            widget.challenge.acceptanceCriteria.length,
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

  void onTapAcceptanceCriteriaButton() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation1, animation2) => AddAcceptanceCriteria(
          title: 'Acceptance Criteria',
          challenge: widget.challenge,
        ),
      ),
    ).then((_) => setState(() {}));
  }
}
