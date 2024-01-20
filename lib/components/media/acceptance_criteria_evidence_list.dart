import 'package:challenge/components/list_items/list_item_icon_small.dart';
import 'package:challenge/components/list_items/list_item_acceptance_criteria_bar.dart';
import 'package:challenge/components/navigation/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge.model.dart';
import 'package:provider/provider.dart';

import 'package:challenge/models/acceptance_criteria.model.dart';
import 'package:challenge/models/evidence.model.dart';
import 'package:challenge/providers/design_provider.dart';
import 'package:challenge/components/navigation/no_animation_page_route.dart';
import 'acceptance_criteria_media_list.dart';

class AcceptanceCriteriaEvidenceList extends StatefulWidget {
  const AcceptanceCriteriaEvidenceList(
      {super.key,
      required this.preTitle,
      required this.challenge,
      required this.acceptanceCriteria});
  final String preTitle;
  final ChallengeModel challenge;
  final AcceptanceCriteriaModel acceptanceCriteria;

  @override
  State<AcceptanceCriteriaEvidenceList> createState() =>
      _AcceptanceCriteriaEvidenceListState();
}

class _AcceptanceCriteriaEvidenceListState
    extends State<AcceptanceCriteriaEvidenceList> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    setIsBottomNavBarVisibleToFalse();
    Future.delayed(Duration.zero, () {
      List<String> preTitleArray = widget.preTitle.split('/');
      if (preTitleArray.length >= 3 && preTitleArray.contains('Evidence')) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomeAppBar(
          preTitle: widget.preTitle,
          titleText: 'Evidence',
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            _buildList(),
          ],
        ));
  }

  Widget _buildList() {
    return RawScrollbar(
      controller: scrollController,
      radius: const Radius.circular(4),
      thumbColor: themeColor3,
      padding: const EdgeInsets.only(right: 4),
      child: ListView.builder(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: widget.acceptanceCriteria.evidences.length +
              1, // +1 for new Evidence
          itemBuilder: (BuildContext content, int index) {
            if (index == 0) {
              return newEvidence();
            }

            EvidenceModel evidence = widget
                .acceptanceCriteria.evidences[index - 1]; // -1 for new Evidence
            return evidenceListItem(evidence);
          }),
    );
  }

  Column newEvidence() {
    return Column(
      children: [
        ListItemIconSmall(
            onTap: () => onTapNewEvidence(),
            icon: Icons.add,
            title: 'New Evidence'),
        const SizedBox(
          height: 17,
        )
      ],
    );
  }

  Column evidenceListItem(EvidenceModel evidence) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => onTapEvidence(evidence),
          child: ListItemAcceptanceCriteriaBar(
            acceptanceCriteria: widget.acceptanceCriteria,
            isProgressBarLocked: true,
            initialProgress: evidence.progress,
            isEvidence: true,
          ),
        ),
        const SizedBox(
          height: 17,
        )
      ],
    );
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

  onTapEvidence(EvidenceModel evidence) {
    Navigator.push(
      context,
      NoAnimationPageRoute(
        builder: (context) => AcceptanceCriteriaMediaList(
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

  void onTapNewEvidence() async {
    // // Ensure that plugin services are initialized so that `availableCameras()`
    // // can be called before `runApp()`
    // WidgetsFlutterBinding.ensureInitialized();

    // // Obtain a list of the available cameras on the device.
    // final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.

    // ignore: use_build_context_synchronously
    context.read<DesignProvider>().setIsBottomNavBarVisible(false);
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      NoAnimationPageRoute(
        builder: (context) => AcceptanceCriteriaMediaList(
            preTitle: '${widget.preTitle}/Evidences',
            challenge: widget.challenge,
            mediaList: [],
            acceptanceCriteria: widget.acceptanceCriteria),
      ),
    ).then((_) => setState(() {
          // context.read<DesignProvider>().setIsBottomNavBarVisible(true);
        }));
  }
}
