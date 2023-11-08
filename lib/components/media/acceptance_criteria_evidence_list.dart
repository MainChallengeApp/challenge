import 'package:challenge/components/media/list_item_acceptance_criteria_bar.dart';
import 'package:challenge/components/navigation/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge.dart';
import 'package:provider/provider.dart';

import '../../models/acceptance_criteria.dart';
import '../../models/evidence.dart';
import '../../providers/design_provider.dart';
import 'acceptance_criteria_media_list.dart';

class AcceptanceCriteriaEvidenceList extends StatefulWidget {
  const AcceptanceCriteriaEvidenceList(
      {super.key,
      required this.preTitle,
      required this.challenge,
      required this.acceptanceCriteria});
  final String preTitle;
  final Challenge challenge;
  final AcceptanceCriteria acceptanceCriteria;

  @override
  State<AcceptanceCriteriaEvidenceList> createState() =>
      _AcceptanceCriteriaEvidenceListState();
}

class _AcceptanceCriteriaEvidenceListState
    extends State<AcceptanceCriteriaEvidenceList> {
  String searchBarText = "";

  @override
  void initState() {
    super.initState();
    setIsBottomNavBarVisibleToFalse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomeAppBar.build(
          preTitle: widget.preTitle,
          title:
              '${widget.acceptanceCriteria.activity.title} ${widget.acceptanceCriteria.activity.amount} ${widget.acceptanceCriteria.activity.unit}',
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            _buildList(),
          ],
        ));
  }

  Widget _buildList() {
    return ListView.separated(
        itemCount: widget.acceptanceCriteria.evidences.length +
            1, // +1 for extra separator at the end +1 for new Challenge listitem + 1 for searchbar
        separatorBuilder: (context, index) => const SizedBox(
              height: 17,
            ),
        itemBuilder: (BuildContext content, int index) {
          if (index == widget.acceptanceCriteria.evidences.length) {
            return Container();
          }

          return GestureDetector(
            onTap: () =>
                onTapEvidence(widget.acceptanceCriteria.evidences[index]),
            child: ListItemAcceptanceCriteriaBar(
              acceptanceCriteria: widget.acceptanceCriteria,
              isProgressBarLocked: true,
              initialProgress:
                  widget.acceptanceCriteria.evidences[index].progress,
            ),
          );
        });
  }

  changeList(String value) {
    setState(() {
      // challengesFutures = getChallenges(context);
      searchBarText = value;
    });
  }

  void ppush(BuildContext context, {required int index}) {
    context.read<DesignProvider>().setIsBottomNavBarVisible(false);
    // Navigator.push(
    //   context,
    //   PageRouteBuilder(
    //     transitionDuration: Duration.zero,
    //     reverseTransitionDuration: Duration.zero,
    //     pageBuilder: (context, animation1, animation2) =>
    //         MediaDetail(media: widget.challenge.media.where((element) => element.title.contains(searchBarText)).toList(), preTitle: '${widget.preTitle}/Media', initialMediaIdex: index,),
    //   ),
    // ).then((_) => setState(() {}));
  }

  button() {
    return GestureDetector(
      onTap: () {},
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 55,
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: themeColor2,
              border: Border.all(
                  width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          child: const Center(
              child: Text(
            'Save',
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          )),
        ),
      ),
    );
  }

  onTapEvidence(Evidence evidence) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation1, animation2) =>
            AcceptanceCriteriaMediaList(
          preTitle:
              '${widget.preTitle}/${widget.acceptanceCriteria.activity.title} ${widget.acceptanceCriteria.activity.amount} ${widget.acceptanceCriteria.activity.unit}',
          mediaList: widget.challenge.media
              .where((element) => evidence.mediaIds.contains(element.id))
              .toList(),
          acceptanceCriteria: widget.acceptanceCriteria,
          challenge: widget.challenge,
          evidence: evidence,
          isSaveInsteadOfEditButtonVisible: false,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  void setIsBottomNavBarVisibleToFalse() {
    Future.delayed(Duration.zero, () {
      setState(() {
        context.read<DesignProvider>().setIsBottomNavBarVisible(false);
      });
    });
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
}
