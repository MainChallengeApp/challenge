import 'package:challenge/components/edit_challenge.dart';
import 'package:challenge/components/media_list.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeChallenge extends StatefulWidget {
  const HomeChallenge(
      {super.key, required this.preTitle, required this.challenge});
  final String preTitle;
  final Challenge challenge;

  @override
  State<HomeChallenge> createState() => _HomeChallengeState();
}

class _HomeChallengeState extends State<HomeChallenge> {
  bool isDescriptionExpanded = false;
  
  late BuildContext context2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        titleSpacing: 0,
        title: Align(
          alignment: Alignment.centerLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              '${widget.preTitle}/${widget.challenge.title}',
              style:
                  const TextStyle(color: Colors.black, fontSize: appBarFontSize),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Slidable(
            key: const ValueKey(0),
            closeOnScroll: true,
            // The end action pane is the one at the right or the bottom side.
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: editChallenge,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              width: 1,
                              color: const Color.fromRGBO(226, 232, 240, 1)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24))),
                      child: const Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Edit")
                        ],
                      )),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: deleteChallenge,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              width: 1,
                              color: const Color.fromRGBO(226, 232, 240, 1)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24))),
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.red.withAlpha(150),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Delete",
                            style: TextStyle(color: Colors.red.withAlpha(150)),
                          )
                        ],
                      )),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
            child: Builder(
              builder: (context) {
                context2 = context;
                return Center(
                  child: Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    height: 120 + 8 * 64 + 2,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
                        borderRadius: const BorderRadius.all(Radius.circular(24))),
                    // margin: EdgeInsets.only(bottom:16),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: onTapOpenMediaPage,
                          child: Container(
                            // TODO: on tap open media page
                            width: double.infinity,
                            height: 180,
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(241, 245, 249, 1),
                                image: DecorationImage(
                                  image: AssetImage(widget.challenge.thumbnailPath),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12))),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                            isDescriptionExpanded = !isDescriptionExpanded;
                          }),
                          child: Container(
                              width: double.infinity,
                              height: isDescriptionExpanded ? 399 : 80,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      color: const Color.fromRGBO(226, 232, 240, 1)),
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(16))),
                              child: Text(
                                widget.challenge.description,
                                overflow: TextOverflow.ellipsis,
                                maxLines: isDescriptionExpanded ? 9999 : 4,
                                textDirection: TextDirection.ltr,
                                textAlign: TextAlign.justify,
                                style:
                                    const TextStyle(fontSize: 12, color: themeColor3),
                              )),
                        ),
                        isDescriptionExpanded
                            ? Container()
                            : const SizedBox(
                                height: 16,
                              ),
                        isDescriptionExpanded
                            ? Container()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: standardContainer(
                                          child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Start',
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        (widget.challenge.startDate != null ? _dateFormat(widget.challenge.startDate!) : '-'),
                                        style: const TextStyle(color: themeColor3),
                                      )
                                    ],
                                  ))),
                                  const SizedBox(width: 16),
                                  Expanded(
                                      child: standardContainer(
                                          child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'End',
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        (widget.challenge.endDate != null ? _dateFormat(widget.challenge.endDate!) : '-'),
                                        style: const TextStyle(color: themeColor3),
                                      )
                                    ],
                                  ))),
                                ],
                              ),
                        // isDescriptionExpanded
                        //     ? Container()
                        //     : const SizedBox(
                        //         height: 16,
                        //       ),
                        isDescriptionExpanded ? Container() : acceptanceCriteria(),
                        isDescriptionExpanded ? Container() : dots(),
                        // isDescriptionExpanded
                        //     ? Container()
                        //     : const SizedBox(
                        //         height: 12,
                        //       ),
                        isDescriptionExpanded
                            ? Container()
                            : Expanded(child: Container()),
                        isDescriptionExpanded
                            ? Container()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  documentationButton(Icons.numbers),
                                  documentationButton(Icons.notes),
                                  documentationButton(Icons.gps_not_fixed),
                                  documentationButton(Icons.camera_alt_outlined),
                                ],
                              ),
                        isDescriptionExpanded
                            ? Container()
                            : const SizedBox(
                                height: 16,
                              ),
                        isDescriptionExpanded
                            ? Container()
                            : Container(
                                height: 55,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color:
                                            const Color.fromRGBO(226, 232, 240, 1)),
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(16))),
                                child: const Center(
                                    child: Text(
                                  'End',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                )),
                              )
                      ],
                    ),
                  ),
                );
              }
            ),
          ),
        ),
      ),
    );
  }

  String _dateFormat(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  documentationButton(IconData iconData) {
    return Container(
      width: 55,
      height: 55,
      margin: const EdgeInsets.only(left: 8, right: 8),
      decoration: BoxDecoration(
          border: Border.all(
              width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      child: Center(child: Icon(iconData)),
    );
  }

  int selectedAcceptanceCriteria = 0;
  acceptanceCriteria() {
    // return Container(
    //   height: 100,
    //   child: ListView.separated(
    //     separatorBuilder: (context, index) => const SizedBox(
    //       height: 16,
    //     ),
    //     itemCount: widget.challenge.acceptanceCriteria.length,
    //     itemBuilder: (context, index) => singleAcceptanceCriteria(index),
    //   ),
    // );

    return Container(
        // margin: EdgeInsets.only(top: 10),
        height: 55,
        // padding: const EdgeInsets.all(10),
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

  singleAcceptanceCriteria(int index) {
    return Stack(
      children: [
        FractionallySizedBox(
          widthFactor:
              widget.challenge.acceptanceCriteria[index].progress / 100,
          heightFactor: 1,
          child: Container(
            // width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: widget.challenge.status == ChallengStatus.failed
                    ? Colors.red
                    : Colors.green,
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

  void editChallenge() {
      Slidable.of(context2)?.close();
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation1, animation2) => EditChallenge(
            title: widget.preTitle, challenge: widget.challenge),
      ),
    ).then((_) => setState(() {}));
  }

  void deleteChallenge() {
    Slidable.of(context2)?.close();
    Navigator.pop(context);
    // Todo: delete Challenge
  }

  void onTapOpenMediaPage() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation1, animation2) => MediaList(title: widget.preTitle),
      ),
    ).then((_) => setState(() {}));
  }
}
