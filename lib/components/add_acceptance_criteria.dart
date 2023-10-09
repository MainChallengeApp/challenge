import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge.dart';

class AddAcceptanceCriteria extends StatefulWidget {
  const AddAcceptanceCriteria(
      {super.key, required this.title, required this.challenge});
  final String title;
  final Challenge challenge;

  @override
  State<AddAcceptanceCriteria> createState() => _AddAcceptanceCriteriaState();
}

class _AddAcceptanceCriteriaState extends State<AddAcceptanceCriteria> {
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
            '${widget.title}/${widget.challenge.title}',
            style:
                const TextStyle(color: Colors.black, fontSize: appBarFontSize),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          width: 345,
          height: 120 + 8 * 64 + 2,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          child: Column(
            children: [
              // thumbnailUploadAndTitle(),
              // // storageLocation(),
              // description(),
              // startAndEndDate(),
              // acceptanceCriteriaButton(),
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
              const Expanded(child: SizedBox()),
              buttons()
            ],
          ),
        ),
      ),
    );
  }

  buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            height: 55,
            width: 100,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
                borderRadius: const BorderRadius.all(Radius.circular(16))),
            child: const Center(
                child: Text(
              'Delete',
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
            )),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
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
    );
  }

  singleAcceptanceCriteria(int index) {
    return Stack(
      children: [
        FractionallySizedBox(
          widthFactor:
              widget.challenge.acceptanceCriteria[index].progress / 100,
          heightFactor: 1,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: const BorderRadius.all(Radius.circular(16))),
          ),
        ),
        Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white.withAlpha(170),
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
            ))
      ],
    );
  }

  Container acceptanceCriteriaButton() {
    // TODO: Acceptance criteria list with first listitem is add acceptance criteria
    return standardContainer(
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
        heightFactor: 3,
        child: const TextField(
            maxLines: 100,
            decoration: InputDecoration.collapsed(hintText: 'Description')));
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
            decoration: const BoxDecoration(
                color: Color.fromRGBO(241, 245, 249, 1),
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: const Center(
                child: Icon(
              Icons.upload,
              color: themeColor3,
            )),
          ),
          const SizedBox(
            width: 200,
            height: 40,
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextField(
                decoration: InputDecoration.collapsed(hintText: 'Title'),
              ),
            ),
          )
        ],
      ),
    );
  }

  standardContainer(
      {required Widget child, double heightFactor = 1}) {
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
    return SizedBox(
        height: 71,
        child: PageView.builder(
          itemCount: widget.challenge.acceptanceCriteria.length,
          controller: PageController(viewportFraction: 1),
          onPageChanged: (int index) =>
              setState(() => selectedAcceptanceCriteria = index),
          itemBuilder: (_, i) {
            return Transform.scale(
              scale: i == selectedAcceptanceCriteria ? 1 : 0.9,
              child: singleAcceptanceCriteria(i),
            );
          },
        ));
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
}
