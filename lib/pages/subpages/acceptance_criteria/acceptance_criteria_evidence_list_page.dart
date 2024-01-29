import 'package:challenge/components/list_items/list_item_icon_small_component.dart';
import 'package:challenge/components/list_items/list_item_acceptance_criteria_bar_component.dart';
import 'package:challenge/components/navigation/app_bar_component.dart';
import 'package:challenge/enums/challenge_status_enum.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:provider/provider.dart';

import 'package:challenge/models/acceptance_criteria_model.dart';
import 'package:challenge/models/evidence_model.dart';
import 'package:challenge/providers/design_provider.dart';
import 'package:challenge/components/navigation/no_animation_page_route_component.dart';
import 'acceptance_criteria_media_list_page.dart';

class AcceptanceCriteriaEvidenceListPage extends StatefulWidget {
  const AcceptanceCriteriaEvidenceListPage(
      {super.key,
      required this.preTitle,
      required this.challenge,
      required this.acceptanceCriteria});
  final String preTitle;
  final ChallengeModel challenge;
  final AcceptanceCriteriaModel acceptanceCriteria;

  @override
  State<AcceptanceCriteriaEvidenceListPage> createState() =>
      _AcceptanceCriteriaEvidenceListPageState();
}

class _AcceptanceCriteriaEvidenceListPageState
    extends State<AcceptanceCriteriaEvidenceListPage> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    setIsBottomNavBarVisibleToFalse();
    Future.delayed(Duration.zero, () {
      List<String> preTitleArray = widget.preTitle.split('/');
      if (preTitleArray.length >= 3 && preTitleArray.contains('Evidences')) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarComponent(
          preTitle: widget.preTitle,
          titleText: 'Evidences',
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
        ListItemIconSmallComponent(
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
          child: ListItemAcceptanceCriteriaBarComponent(
            acceptanceCriteria: widget.acceptanceCriteria,
            isProgressBarLocked: true,
            initialProgress: evidence.progress,
            isEvidence: true,
            isFailed: widget.challenge.status == ChallengeStatusEnum.failed,
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
      NoAnimationPageRouteComponent(
        builder: (context) => AcceptanceCriteriaMediaListPage(
          preTitle:
              '${widget.preTitle}/${widget.acceptanceCriteria.title} ${widget.acceptanceCriteria.amount} ${widget.acceptanceCriteria.unit}',
          initialMediaList: widget.challenge.media
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
      NoAnimationPageRouteComponent(
        builder: (context) => AcceptanceCriteriaMediaListPage(
            preTitle: '${widget.preTitle}/Evidences',
            challenge: widget.challenge,
            initialMediaList: [],
            acceptanceCriteria: widget.acceptanceCriteria),
      ),
    ).then((_) => setState(() {
          // context.read<DesignProvider>().setIsBottomNavBarVisible(true);
        }));
  }
}
