import 'package:flutter/material.dart';
import 'package:nested_navigation_demo_flutter/globals.dart';
import 'package:nested_navigation_demo_flutter/models/challenge.dart';

class SearchChallenge extends StatefulWidget {
  const SearchChallenge(
      {super.key, required this.title, required this.challenge});
  final String title;
  final Challenge challenge;

  @override
  State<SearchChallenge> createState() => _SearchChallengeState();
}

class _SearchChallengeState extends State<SearchChallenge> {
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
          // margin: EdgeInsets.only(bottom:16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(241, 245, 249, 1),
                    image: DecorationImage(
                      image: AssetImage(widget.challenge.thumbnailPath),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(12))),
              ),
              const SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () => setState(() {isDescriptionExpanded = !isDescriptionExpanded;}),
                child: Container(
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
                      maxLines: isDescriptionExpanded ? 999 :4,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(fontSize: 12, color: themeColor3),
                    )),
              ),
              isDescriptionExpanded ? Container() : 
              const SizedBox(
                height: 11,
              ),
              isDescriptionExpanded ? Container() :
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                      'Acceptance Criteria',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
              ),
              isDescriptionExpanded ? Container() :
              const SizedBox(
                height: 11,
              ),
              isDescriptionExpanded ? Container() :
              acceptanceCriteria(),
              isDescriptionExpanded ? Container() :
              Expanded(child: Container()),
              isDescriptionExpanded ? Container() :
              Container(
                height: 53,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: themeColor2,
                    border: Border.all(
                        width: 1,
                        color: const Color.fromRGBO(226, 232, 240, 1)),
                    borderRadius: const BorderRadius.all(Radius.circular(16))),
                child: const Center(
                    child: Text(
                  'Accept',
                  style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
                )),
              )
            ],
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
      width: 48,
      height: 48,
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
    return SizedBox(
        height: 71,
        child: PageView.builder(
          itemCount: widget.challenge.acceptanceCriteria.length,
          controller: PageController(viewportFraction: 1),
          onPageChanged: (int index) => setState(() => selectedAcceptanceCriteria = index),
          itemBuilder: (_, i) {
            return Transform.scale(
              scale: i == selectedAcceptanceCriteria ? 1 : 0.9,
              child: singleAcceptanceCriteria(i),
            );
          },
        ));
  }

  singleAcceptanceCriteria(int index) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(
                width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
            borderRadius: const BorderRadius.all(Radius.circular(16))),
        child: Column(children: [
          Row(
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
              Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(241, 245, 249, 1),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Icon(getIconData(index), color: themeColor3, size: 14),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            height: 5,
            decoration: const BoxDecoration(
                color: themeColor4,
                borderRadius: BorderRadius.all(Radius.circular(16))),
            child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: widget.challenge.acceptanceCriteria[index].progress/100,
                  heightFactor: 1,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                  ),
                )),
          ),
        ]));
  }
  
  IconData getIconData(int index) {
    if (widget.challenge.acceptanceCriteria[index].tracking == 'camera') {
      return Icons.camera_alt_outlined;
    } else if (widget.challenge.acceptanceCriteria[index].tracking == 'gps') {
      return Icons.gps_not_fixed;
    }else if (widget.challenge.acceptanceCriteria[index].tracking == 'notes') {
      return Icons.notes;
    }else if (widget.challenge.acceptanceCriteria[index].tracking == 'numbers') {
      return Icons.numbers;
    } else {
      return Icons.not_accessible;
    }
  }
  
  dots() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(widget.challenge.acceptanceCriteria.length, (index) => Padding(
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 10, bottom: 23),
                  child: Icon(
                    Icons.fiber_manual_record,
                    size: 6,
                    color: index == selectedAcceptanceCriteria ? themeColor3 : themeColor3.withAlpha(100),
                  ),
                ))
    
    //  [
                // Padding(
                //   padding: const EdgeInsets.only(
                //       left: 5, right: 5, top: 10, bottom: 23),
                //   child: Icon(
                //     Icons.fiber_manual_record,
                //     size: 6,
                //     color: themeColor3.withAlpha(100),
                //   ),
                // ),
    //             const Padding(
    //               padding:
    //                   EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 23),
    //               child: Icon(
    //                 Icons.fiber_manual_record,
    //                 size: 6,
    //                 color: themeColor3,
    //               ),
    //             ),
    //             Padding(
    //               padding: const EdgeInsets.only(
    //                   left: 5, right: 5, top: 10, bottom: 23),
    //               child: Icon(
    //                 Icons.fiber_manual_record,
    //                 size: 6,
    //                 color: themeColor3.withAlpha(100),
    //               ),
    //             )
              
    //           ]
              
              );
  }
}
