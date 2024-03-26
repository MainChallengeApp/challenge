import 'package:challenge/models/repetition_model.dart';
import 'package:challenge/pages/components/list_items/list_item_icon_small_component.dart';
import 'package:challenge/pages/components/list_items/list_item_repetition_component.dart';
import 'package:challenge/pages/components/navigation/app_bar_component.dart';
import 'package:challenge/pages/components/simple_components/space_column_component.dart';
import 'package:challenge/pages/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:provider/provider.dart';

import 'package:challenge/models/acceptance_criteria_model.dart';
import 'package:challenge/models/progress_model.dart';
import 'package:challenge/providers/design_provider.dart';
import 'package:challenge/pages/components/navigation/no_animation_page_route_component.dart';
import 'progress_media_list_page.dart';

class RepetitionPage extends StatefulWidget {
  final String preTitle;
  final ChallengeModel challenge;

  const RepetitionPage(
      {super.key, required this.preTitle, required this.challenge});

  @override
  State<RepetitionPage> createState() => _RepetitionPageState();
}

class _RepetitionPageState extends State<RepetitionPage> {
  ScrollController scrollController = ScrollController();
  late final AcceptanceCriteriaModel acceptanceCriteria =
      widget.challenge.acceptanceCriteria;

  @override
  void initState() {
    super.initState();
    setIsBottomNavBarVisibleToFalse();
    Future.delayed(Duration.zero, () {
      List<String> preTitleArray = widget.preTitle.split('/');
      if (preTitleArray.length >= 3 && preTitleArray.contains('Repetitions')) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarComponent(
          preTitle: widget.preTitle,
          titleText: 'Repetitions',
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
          itemCount: acceptanceCriteria.repetitions.length,
          itemBuilder: (BuildContext content, int index) {
            RepetitionModel repetition = acceptanceCriteria.repetitions[index];
            return repetitionListItem(repetition);
          }),
    );
  }

  Column newProgress() {
    return Column(
      children: [
        ListItemIconSmallComponent(
            onTap: () => onTapNewProgress(),
            icon: Icons.add,
            title: 'New Progress'),
        const SpaceComponent()
      ],
    );
  }

  repetitionListItem(RepetitionModel repetition) {
    return SpaceColumnComponent(
      child: GestureDetector(
        onTap: () => onTapRepetition(repetition),
        child: ListItemRepetitionComponent(
          repetition: repetition,
          acceptanceCriteria: acceptanceCriteria,
        ),
      ),
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

  onTapProgress(ProgressModel progress) {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => ProgressMediaListPage(
          preTitle: '${widget.preTitle}/Progress',
          initialMediaList: widget.challenge.media
              .where((element) => progress.mediaIds.contains(element.id))
              .toList(),
          acceptanceCriteria: acceptanceCriteria,
          challenge: widget.challenge,
          progress: progress,
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

  void onTapNewProgress() async {
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
        builder: (context) => ProgressMediaListPage(
            preTitle: '${widget.preTitle}/Progress',
            challenge: widget.challenge,
            initialMediaList: const [],
            acceptanceCriteria: acceptanceCriteria),
      ),
    ).then((_) => setState(() {
          // context.read<DesignProvider>().setIsBottomNavBarVisible(true);
        }));
  }

  onTapRepetition(RepetitionModel repetition) {}
}
