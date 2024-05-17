import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:challenge/pages/components/simple_components/space_component.dart';
import 'package:challenge/utils/design_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StartAndEndDateComponent extends StatefulWidget {
  final ChallengeModel editChallenge;
  final bool isLocked;
  final Function? reloadSearchChallengePage;

  const StartAndEndDateComponent(
      {super.key,
      required this.editChallenge,
      this.isLocked = false,
      this.reloadSearchChallengePage});

  @override
  State<StartAndEndDateComponent> createState() =>
      _StartAndEndDateComponentState();
}

class _StartAndEndDateComponentState extends State<StartAndEndDateComponent> {
  @override
  Widget build(BuildContext context) {
    // return CustomContainerComponent(
    //     padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             Align(
    //               alignment: Alignment.topLeft,
    //               child: Text(
    //                 'Start',
    //                 style: TextStyle(fontSize: 12, color: themeColor3),
    //               ),
    //             ),
    //             Align(
    //               alignment: Alignment.topCenter,
    //               child: Text(
    //                 'Now',
    //                 style: TextStyle(fontSize: 12, color: themeColor3),
    //               ),
    //             ),
    //             Align(
    //               alignment: Alignment.topRight,
    //               child: Text(
    //                 'End',
    //                 style: TextStyle(fontSize: 12, color: themeColor3),
    //               ),
    //             )
    //           ],
    //         ),
    //         Stack(
    //           children: [
    //             Center(
    //               child: timeline(),
    //             ),
    //             // Positioned(
    //             //     // left: 0,
    //             //     child: Container(
    //             //   width: double.infinity,
    //             //   height: double.infinity,
    //             //   child: Align(
    //             //     alignment: Alignment.centerLeft,
    //             //     child: start(),
    //             //   ),
    //             // )),
    //             // Positioned(
    //             //     // left: 0,
    //             //     child: Container(
    //             //   width: double.infinity,
    //             //   height: double.infinity,
    //             //   child: Align(
    //             //     alignment: Alignment.centerRight,
    //             //     child: end(),
    //             //   ),
    //             // )),
    //             // Positioned(
    //             //     left: 50,
    //             //     child: Container(
    //             //       width: double.infinity,
    //             //       height: double.infinity,
    //             //       child: Align(
    //             //         alignment: Alignment.centerLeft,
    //             //         child: now(),
    //             //       ),
    //             //     )),
    //           ],
    //         ),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             Align(
    //               alignment: Alignment.topLeft,
    //               child: Text(
    //                 DesignUtil.getDateAndTimeFormated(
    //                         widget.editChallenge.startDate,
    //                         isYearVisible: false)
    //                     .split(' ')[0],
    //                 style: const TextStyle(fontSize: 12, color: themeColor3),
    //               ),
    //             ),
    //             Align(
    //               alignment: Alignment.topCenter,
    //               child: Text(
    //                 DesignUtil.getDateAndTimeFormated(DateTime.now(),
    //                         isYearVisible: false)
    //                     .split(' ')[0],
    //                 style: TextStyle(fontSize: 12, color: themeColor3),
    //               ),
    //             ),
    //             Align(
    //               alignment: Alignment.topRight,
    //               child: Text(
    //                 DesignUtil.getDateAndTimeFormated(
    //                         widget.editChallenge.endDate,
    //                         isYearVisible: false)
    //                     .split(' ')[0],
    //                 style: const TextStyle(fontSize: 12, color: themeColor3),
    //               ),
    //             )
    //           ],
    //         ),
    //       ],
    //     ));

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
                const Text(
                  'Start',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, fontSize: basicFontSize),
                ),
                Text(
                  (widget.editChallenge.startDate != null
                      ? _dateFormat(widget.editChallenge.startDate!)
                      : '-'),
                  style: const TextStyle(
                      color: themeColor3, fontSize: basicFontSize),
                )
              ],
            )),
          ),
        ),
        const SpaceComponent(),
        Expanded(
          child: GestureDetector(
            onTap: () => onTapStartOrEndDate('end'),
            child: standardContainer(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'End',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, fontSize: basicFontSize),
                ),
                Text(
                  (widget.editChallenge.endDate != null
                      ? _dateFormat(widget.editChallenge.endDate!)
                      : '-'),
                  style: const TextStyle(
                      color: themeColor3, fontSize: basicFontSize),
                )
              ],
            )),
          ),
        ),
      ],
    );
  }

  standardContainer({required Widget child, double heightFactor = 1}) {
    return Container(
      // width: double.infinity,
      height: 55 * heightFactor,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      child: child,
    );
  }

  void onTapStartOrEndDate(String startOrEnd) async {
    if (widget.isLocked) return;

    DateTime? initialDateTime = startOrEnd == 'start'
        ? widget.editChallenge.startDate
        : widget.editChallenge.endDate != null
            ? DesignUtil.dateWithoutTime(widget.editChallenge.endDate!)
                .add(const Duration(hours: 23, minutes: 59, seconds: 59))
            : widget.editChallenge.startDate != null
                ? DesignUtil.dateWithoutTime(widget.editChallenge.startDate!)
                    .add(const Duration(hours: 23, minutes: 59, seconds: 59))
                : null;
    setState(() {
      if (startOrEnd == 'start') {
        widget.editChallenge.startDate = null;
      } else if (startOrEnd == 'end') {
        widget.editChallenge.endDate = null;
        widget.editChallenge.setFrequencyAmount();
        widget.reloadSearchChallengePage?.call();
      }
    });

    bool isDateTimeChanged = false;

    await showCupertinoModalPopup(
      context: context,
      builder: (c) {
        var size = MediaQuery.of(context).size;
        return GestureDetector(
          onTap: () {
            if (startOrEnd == 'start') {
              setState(() {
                if (!isDateTimeChanged) {
                  widget.editChallenge.startDate = initialDateTime ??
                      DesignUtil.dateWithoutTime(DateTime.now());
                  if (widget.editChallenge.endDate == null) {
                    widget.editChallenge.setEndDate();
                  }
                  widget.editChallenge.setFrequencyAmount();
                  widget.reloadSearchChallengePage?.call();
                }
              });
            } else if (startOrEnd == 'end') {
              setState(() {
                if (!isDateTimeChanged) {
                  widget.editChallenge.endDate = initialDateTime ??
                      DesignUtil.dateWithoutTime(DateTime.now()).add(
                          const Duration(hours: 23, minutes: 59, seconds: 59));
                  widget.editChallenge.setFrequencyAmount();
                  widget.reloadSearchChallengePage?.call();
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
              maximumDate: startOrEnd == 'start' &&
                      widget.editChallenge.frequency.amount == null &&
                      widget.editChallenge.startDate != null
                  ? widget.editChallenge.endDate
                  : null,
              minimumDate: startOrEnd == 'end'
                  ? initialDateTime != null
                      ? widget.editChallenge.startDate
                      : null
                  : DesignUtil.dateWithoutTime(DateTime.now()),
              initialDateTime: initialDateTime,
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (value) {
                value = DesignUtil.dateWithoutTime(value).add(
                    startOrEnd == 'end'
                        ? const Duration(hours: 23, minutes: 59, seconds: 59)
                        : Duration.zero);
                isDateTimeChanged = true;
                setState(() {
                  if (startOrEnd == 'start') {
                    widget.editChallenge.startDate = value;
                    widget.editChallenge.setEndDate();
                  } else if (startOrEnd == 'end') {
                    widget.editChallenge.endDate = value;
                    widget.editChallenge.setFrequencyAmount();
                    widget.reloadSearchChallengePage?.call();
                  }
                });
              },
            ),
          ),
        );
      },
    );
  }

  Container timeline() {
    return Container(width: double.infinity, height: 1.5, color: themeColor5);
  }

  String _dateFormat(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  // start() {
  //   return Container(
  //     color: Colors.red,
  //     padding: EdgeInsets.only(left: 16.0), // Adjust left padding as needed
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Expanded(child: Container()), // Placeholder above
  //         const Text(
  //           'Start',
  //           style: TextStyle(fontSize: 12, color: themeColor3),
  //         ),
  //         const SizedBox(height: 4),
  //         Row(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             Expanded(
  //               child: Container(
  //                 height: 10,
  //                 decoration: BoxDecoration(
  //                   color: themeColor3,
  //                   borderRadius: BorderRadius.circular(1),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 4),
  //         const Text(
  //           'Start',
  //           style: TextStyle(fontSize: 12, color: themeColor3),
  //         ),
  //         Expanded(child: Container()), // Placeholder below
  //       ],
  //     ),
  //   );
  // }

  start() {
    return Wrap(
      direction: Axis.vertical,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Expanded(child: Container()), // Platzhalter oben
        const Text(
          'Start',
          style: TextStyle(fontSize: 12, color: themeColor3),
        ),
        const SizedBox(
          height: 4,
        ),
        Container(
          width: 3,
          height: 10,
          decoration: BoxDecoration(
            color: themeColor3,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          DesignUtil.getDateAndTimeFormated(widget.editChallenge.startDate,
                  isYearVisible: false)
              .split(' ')[0],
          style: const TextStyle(fontSize: 12, color: themeColor3),
        ),
        Expanded(child: Container()), // Platzhalter unten
      ],
    );
  }

  end() {
    return Wrap(
      direction: Axis.vertical,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Expanded(child: Container()), // Platzhalter oben
        const Text(
          'End',
          style: TextStyle(fontSize: 12, color: themeColor3),
        ),
        const SizedBox(
          height: 4,
        ),
        Container(
          width: 3,
          height: 10,
          decoration: BoxDecoration(
            color: themeColor3,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          DesignUtil.getDateAndTimeFormated(widget.editChallenge.endDate,
                  isYearVisible: false)
              .split(' ')[0],
          style: const TextStyle(fontSize: 12, color: themeColor3),
        ),
        Expanded(child: Container()), // Platzhalter unten
      ],
    );
  }

  now() {
    {
      return Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Expanded(child: Container()), // Platzhalter oben
          const Text(
            'Now',
            style: TextStyle(fontSize: 12, color: themeColor3),
          ),
          const SizedBox(
            height: 4,
          ),
          Container(
            width: 3,
            height: 10,
            decoration: BoxDecoration(
              color: themeColor3,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DesignUtil.getDateAndTimeFormated(DateTime.now(),
                    isYearVisible: false)
                .split(' ')[0],
            style: const TextStyle(fontSize: 12, color: themeColor3),
          ),
          Expanded(child: Container()), // Platzhalter unten
        ],
      );
    }
  }
}
