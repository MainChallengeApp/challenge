import 'package:challenge/enums/tab_item_enum.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/json_file_controller/challenge_controller.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/user_challenge_model.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/providers/user_challenges_provider.dart';
import 'package:challenge/ui/components/challenge/amount_and_unit_component.dart';
import 'package:challenge/ui/components/challenge/frequency_component.dart';
import 'package:challenge/ui/components/challenge/start_and_end_date_component.dart';
import 'package:challenge/ui/components/edit_challenge/edit_description_component.dart';
import 'package:challenge/ui/components/edit_challenge/expanded_text_field_component.dart';
import 'package:challenge/ui/components/edit_challenge/upload_thumbnail_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/custom_card_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/pages/home/home_challenge_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditChallengePage extends StatefulWidget {
  final String preTitle;
  final ChallengeModel challenge;
  late final ChallengeModel editChallenge;
  final bool isNewChallenge;
  final bool isTryAgain;
  final bool isSearchEdit;
  final bool isSearchNewChallenge;

  EditChallengePage(
      {super.key,
      required this.preTitle,
      required this.challenge,
      this.isSearchEdit = false,
      this.isNewChallenge = false,
      this.isTryAgain = false,
      this.isSearchNewChallenge = false}) {
    editChallenge = challenge.copyChallenge(isTryAgain: isTryAgain);
  }

  @override
  State<EditChallengePage> createState() => _EditChallengePageState();
}

class _EditChallengePageState extends State<EditChallengePage> {
  ChallengeController challengeController = ChallengeController();

  bool isDescriptionExpanded = false;

  late final userChallengesProvider =
      Provider.of<UserChallengesProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          resizeToAvoidBottomInset: isDescriptionExpanded ? true : false,
          appBar: AppBarComponent(
              preTitle: widget.preTitle,
              titleText: widget.isNewChallenge ? 'New Challenge' : 'Edit'),
          backgroundColor: Colors.white,
          body: CardComponent(
            scrollPhysics: const AlwaysScrollableScrollPhysics(),
            children: [
              thumbnailUploadAndTitle(),
              description(),
              amountAndUnit(),
              frequency(),
              startAndEndDate(),
              Visibility(
                  visible: !isDescriptionExpanded,
                  child: Expanded(child: Container())),
              cancelAndSaveOrAcceptButton()
            ],
          ),
          bottomNavigationBar: const BottomNavigationComponent()),
    );
  }

  cancelAndSaveOrAcceptButton() {
    return Visibility(
      visible: !isDescriptionExpanded,
      child: Row(
        children: [
          Expanded(
            child: CustomButtonComponent(
              onTap: onTapCancel,
              text: 'Cancel',
            ),
          ),
          const SpaceComponent(),
          widget.isSearchEdit ||
                  widget.isSearchNewChallenge ||
                  widget.isNewChallenge
              ? Expanded(
                  child: CustomButtonComponent(
                    onTap: onTapAccept,
                    text: 'Accept',
                    isPrimaryButton: true,
                  ),
                )
              : Expanded(
                  child: CustomButtonComponent(
                    onTap: onTapSave,
                    text: 'Save',
                    isPrimaryButton: true,
                  ),
                ),
        ],
      ),
    );
  }

  startAndEndDate() {
    return Visibility(
      visible: !isDescriptionExpanded,
      child: SpaceColumnComponent(
        heightMultiplier: 2,
        child: StartAndEndDateComponent(
          editChallenge: widget.editChallenge,
          reloadSearchChallengePage: () => setState(
            () {},
          ),
        ),
      ),
    );
  }

  description() {
    EditDescriptionComponent descriptionComponent = EditDescriptionComponent(
      challenge: widget.editChallenge,
      isDescriptionExpanded: isDescriptionExpanded,
      onTap: () => setState(() {
        isDescriptionExpanded = !isDescriptionExpanded;
      }),
    );
    return isDescriptionExpanded
        ? Expanded(child: descriptionComponent)
        : Column(
            children: [
              descriptionComponent,
              const SpaceComponent(
                heightMultiplier: 2,
              )
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

  void onTapAccept() async {
    ChallengeModel challengeCopy = widget.editChallenge.copyChallenge();
    challengeCopy.createdAt = DateTime.now();
    userChallengesProvider.insertToLocalList(challengeCopy);

    // ignore: use_build_context_synchronously
    context.read<TabProvider>().selectTab(TabItemEnum.Home);

    var homeNavigator = navigatorKeys[TabItemEnum.Home]!.currentState!;

    homeNavigator.popUntil((route) => route.isFirst);

    homeNavigator.push(
      NoAnimationPageRouteComponent(
        builder: (context) => const HomeChallengePage(
          preTitle: 'Home',
          initialUserChallengeId: '',
        ),
      ),
    );

    await userChallengesProvider.create(challengeCopy);
  }

  void onTapSave() async {
    // TODO: maybe just copyChallenge()
    widget.challenge.thumbnailPath = widget.editChallenge.thumbnailPath;
    widget.challenge.title = widget.editChallenge.title;
    widget.challenge.description = widget.editChallenge.description;
    widget.challenge.acceptanceCriteria =
        widget.editChallenge.acceptanceCriteria;
    widget.challenge.frequency = widget.editChallenge.frequency;
    widget.challenge.startDate = widget.editChallenge.startDate;
    widget.challenge.endDate = widget.editChallenge.endDate;
    widget.challenge.categories = widget.editChallenge.categories;

    widget.challenge.setGoals(widget.editChallenge.acceptanceCriteria.amount);

    userChallengesProvider
        .updateLocalList(widget.challenge as UserChallengeModel);
    Navigator.pop(context);
    await userChallengesProvider.update(widget.challenge as UserChallengeModel);
  }

  amountAndUnit() {
    return Visibility(
      visible: !isDescriptionExpanded,
      child: SpaceColumnComponent(
        child: AmountAndUnitComponent(
            acceptanceCriteria: widget.editChallenge.acceptanceCriteria),
      ),
    );
  }

  frequency() {
    return Visibility(
      visible: !isDescriptionExpanded,
      child: SpaceColumnComponent(
        child: FrequencyComponent(
          challenge: widget.editChallenge,
          reloadSearchChallengePage: () => setState(
            () {},
          ),
        ),
      ),
    );
  }

  member() {
    return Visibility(
      visible: !isDescriptionExpanded,
      child: const SpaceColumnComponent(
        child: CustomContainerComponent(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Add Member'),
              Icon(Icons.arrow_forward_ios_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
