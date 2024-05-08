import 'package:challenge/pages/components/challenge/amount_and_unit_component.dart';
import 'package:challenge/pages/components/challenge/frequency_component.dart';
import 'package:challenge/pages/components/challenge/start_and_end_date_component.dart';
import 'package:challenge/pages/components/edit_challenge/description_big_component.dart';
import 'package:challenge/pages/components/edit_challenge/expanded_text_field_component.dart';
import 'package:challenge/pages/components/edit_challenge/upload_thumbnail_component.dart';
import 'package:challenge/pages/components/simple_components/custom_button_component.dart';
import 'package:challenge/pages/components/simple_components/custom_card_component.dart';
import 'package:challenge/pages/components/simple_components/space_column_component.dart';
import 'package:challenge/pages/components/simple_components/space_component.dart';
import 'package:challenge/pages/components/navigation/app_bar_component.dart';
import 'package:challenge/json_file_controller/challenge_controller.dart';
import 'package:challenge/pages/home/home_challenge_page.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:challenge/pages/components/navigation/no_animation_page_route_component.dart';

class EditChallengePage extends StatefulWidget {
  final String preTitle;
  final ChallengeModel challenge;
  late final ChallengeModel editChallenge;
  final bool isNewChallenge;
  final bool isTryAgain;
  final bool isSearchEdit;

  EditChallengePage(
      {super.key,
      required this.preTitle,
      required this.challenge,
      this.isSearchEdit = false,
      this.isNewChallenge = false,
      this.isTryAgain = false}) {
    editChallenge = ChallengeModel.copyChallenge(
        challenge: challenge, isTryAgain: isTryAgain);
  }

  @override
  State<EditChallengePage> createState() => _EditChallengePageState();
}

class _EditChallengePageState extends State<EditChallengePage> {
  ChallengeController challengeController = ChallengeController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBarComponent(
            preTitle: widget.preTitle,
            titleText: widget.isNewChallenge ? 'New Challenge' : 'Edit'),
        backgroundColor: Colors.white,
        body: CardComponent(
          scrollPhysics: const AlwaysScrollableScrollPhysics(),
          children: [
            thumbnailUploadAndTitle(),
            description(),
            startAndEndDate(),
            frequency(),
            amountAndUnit(),
            Expanded(child: Container()),
            cancelAndSaveButton()
          ],
        ),
      ),
    );
  }

  cancelAndSaveButton() {
    return Row(
      children: [
        Expanded(
          child: CustomButtonComponent(
            onTap: onTapCancel,
            text: 'Cancel',
          ),
        ),
        const SpaceComponent(),
        Expanded(
          child: CustomButtonComponent(
            onTap: onTapSave,
            text: 'Save',
            isPrimaryButton: true,
          ),
        ),
      ],
    );
  }

  startAndEndDate() {
    return Column(
      children: [
        StartAndEndDateComponent(editChallenge: widget.editChallenge),
        const SpaceComponent()
      ],
    );
  }

  description() {
    return Column(
      children: [
        DescriptionBigComponent(editChallenge: widget.editChallenge),
        const SpaceComponent()
      ],
    );
  }

  thumbnailUploadAndTitle() {
    return Column(
      children: [
        Row(
          children: [
            UploadThumbnailComponent(editChallenge: widget.editChallenge),
            const SpaceComponent(),
            ExpandedTextFieldComponent(editChallenge: widget.editChallenge)
          ],
        ),
        const SpaceComponent()
      ],
    );
  }

  void onTapCancel() {
    Navigator.pop(context);
  }

  void onTapSave() async {
    widget.challenge.thumbnailPath = widget.editChallenge.thumbnailPath;
    widget.challenge.title = widget.editChallenge.title;
    widget.challenge.description = widget.editChallenge.description;
    widget.challenge.acceptanceCriteria =
        widget.editChallenge.acceptanceCriteria;
    widget.challenge.frequency = widget.editChallenge.frequency;
    widget.challenge.startDate = widget.editChallenge.startDate;
    widget.challenge.endDate = widget.editChallenge.endDate;
    widget.challenge.categories = widget.editChallenge.categories;

    if (widget.isSearchEdit) {
      Navigator.pop(context);
      return;
    }

    if (allChallengesList.map((e) => e.id).contains(widget.challenge.id)) {
      // wip
      // challengeList.firstWhere((element) => element == widget.challenge).status =
      //         ChallengStatus.factory('Success');
      //     allChallengesList
      //         .where((element) => element == widget.challenge)
      //         .first
      //         .status = ChallengStatus.factory('Success');
      //     challengeController.writeFile(context, allChallengesList);

      allChallengesList = allChallengesList.map((e) {
        if (e.id == widget.challenge.id) {
          return widget.challenge;
        }
        return e;
      }).toList(); //[widget.challenge.id!] = widget.challenge;
    } else {
      allChallengesList.insert(0, widget.challenge);
    }
    if (challengeList.map((e) => e.id).contains(widget.challenge.id)) {
      challengeList = challengeList.map((e) {
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
    challengeController.writeFile(allChallengesList);

    Navigator.pop(context);
    if (!widget.isSearchEdit && !widget.isNewChallenge && !widget.isTryAgain) {
      Navigator.pop(context);
    }

    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => HomeChallengePage(
            preTitle: 'Home', // very bad workaround
            initialChalleneIndex: challengeList.indexOf(widget.challenge)),
      ),
    );
  }

  amountAndUnit() {
    return SpaceColumnComponent(
      child: AmountAndUnitComponent(
          acceptanceCriteria: widget.editChallenge.acceptanceCriteria),
    );
  }

  frequency() {
    return SpaceColumnComponent(
      child: FrequencyComponent(challenge: widget.editChallenge),
    );
  }
}
