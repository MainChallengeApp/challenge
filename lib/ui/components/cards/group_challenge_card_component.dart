import 'package:camera/camera.dart';
import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/user_challenge_model.dart';
import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/challenge/acceptance_criteria_component.dart';
import 'package:challenge/ui/components/challenge/description_component.dart';
import 'package:challenge/ui/components/challenge/documentation_button_component.dart';
import 'package:challenge/ui/components/challenge/start_and_end_date_component.dart';
import 'package:challenge/ui/components/challenge/thumbnail_max_component.dart';
import 'package:challenge/ui/components/challenge/title_with_percentage_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/slider_component.dart';
import 'package:challenge/ui/components/simple_components/snack_bar_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/dialogs/delete_challenge_dialog.dart';
import 'package:challenge/ui/pages/subpages/edit_challenge/edit_challenge_page.dart';
import 'package:challenge/ui/pages/subpages/media/media_camera_page.dart';
import 'package:challenge/ui/pages/subpages/media/media_list_page.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class GroupChallengeCardComponent extends StatefulWidget {
  final GroupChallengeModel groupChallenge;
  final String preTitle;

  const GroupChallengeCardComponent(
      {super.key, required this.groupChallenge, required this.preTitle});

  @override
  State<GroupChallengeCardComponent> createState() =>
      _GroupChallengeCardComponentState();
}

class _GroupChallengeCardComponentState
    extends State<GroupChallengeCardComponent> {
  // providers
  late final _usersProvider =
      Provider.of<UsersProvider>(context, listen: false);

  late final _groupChallengesProvider =
      Provider.of<GroupChallengesProvider>(context, listen: false);

  // state variables
  late final UserChallengeModel _userChallenge =
      widget.groupChallenge.toUserChallengeModel(_usersProvider.user.id);

  bool _isDescriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      closeOnScroll: true,
      key: ObjectKey(widget.groupChallenge),
      endActionPane: _endActionPane(),
      child: Builder(builder: (context) {
        return CardComponent(
          children: [
            _thumbnail(),
            _title(),
            _description(),
            _startAndEndDate(),
            _acceptanceCriteria(),
            _expandedSpace(),
            _documentationButtons(),
            _startEndTryAcceptAgainButton()
          ],
        );
      }),
    );
  }

  _endActionPane() {
    return ActionPane(
      extentRatio: (widget.groupChallenge.isEditable()) ? 0.5 : 0.25,
      motion: const ScrollMotion(),
      children: [
        _editSlider(),
        _separator(),
        _deleteSlider(),
        const SpaceComponent(
          width: BottomNavigationComponent.standardMargin,
        ),
      ],
    );
  }

  _editSlider() {
    return Visibility(
      visible: widget.groupChallenge.isEditable(),
      child: SliderComponent(
          icon: IconEnum.edit.icon, label: 'Edit', onTap: _onTapEditChallenge),
    );
  }

  _separator() {
    return SpaceComponent(
      width: BottomNavigationComponent.standardMargin,
      isVisible: widget.groupChallenge.isEditable(),
    );
  }

  _deleteSlider() {
    return SliderComponent(
        icon: IconEnum.delete.icon,
        label: 'Delete',
        foregroundColor: Theme.of(context).colorScheme.red.withAlpha(150),
        duration: Durations.short1,
        onTap: _onTapDeleteChallenge);
  }

  _thumbnail() {
    return SpaceColumnComponent(
      height: 11,
      child: ThumbnailMaxComponent(
          challenge: widget.groupChallenge,
          onTapOpenMediaPage: _onTapOpenMediaPage),
    );
  }

  _title() {
    return SpaceColumnComponent(
      height: 11,
      child: TitleWithPercentageComponent(challenge: widget.groupChallenge),
    );
  }

  _description() {
    DescriptionComponent descriptionComponent = DescriptionComponent(
      challenge: widget.groupChallenge,
      isDescriptionExpanded: _isDescriptionExpanded,
      onTap: () => setState(() {
        _isDescriptionExpanded = !_isDescriptionExpanded;
      }),
    );
    return _isDescriptionExpanded
        ? Expanded(
            child: Column(
            children: [
              Expanded(child: descriptionComponent),
              widget.groupChallenge.description.isNotEmpty
                  ? const SpaceComponent()
                  : Container()
            ],
          ))
        : Column(
            children: [
              descriptionComponent,
              widget.groupChallenge.description.isNotEmpty
                  ? const SpaceComponent()
                  : Container()
            ],
          );
  }

  _startAndEndDate() {
    return _isDescriptionExpanded
        ? Container()
        : SpaceColumnComponent(
            child: StartAndEndDateComponent(
              editChallenge: widget.groupChallenge,
              isLocked: true,
            ),
          );
  }

  _acceptanceCriteria() {
    return _isDescriptionExpanded
        ? Container()
        : AcceptanceCriteriaComponent(
            onTap: _onTapAcceptanceCriteria,
            onTapNewProgress: _onTapNewProgress,
            challenge: widget.groupChallenge,
          );
  }

  _expandedSpace() {
    return _isDescriptionExpanded ? Container() : Expanded(child: Container());
  }

  _documentationButtons() {
    return Visibility(
      visible: !_isDescriptionExpanded && _userChallenge.isInProgress(),
      child: SpaceColumnComponent(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DocumentationButtonComponent(
              iconData: Icons.numbers_rounded,
              onTap: () => SnackBarComponent.showSnackBar(
                  context, 'The Numbers feature will be added soon.'),
              isGrayedOut: true,
            ),
            DocumentationButtonComponent(
              iconData: Icons.notes_rounded,
              onTap: () => SnackBarComponent.showSnackBar(
                  context, 'The Notes feature will be added soon.'),
              isGrayedOut: true,
            ),
            DocumentationButtonComponent(
              iconData: Icons.gps_not_fixed_rounded,
              onTap: () => SnackBarComponent.showSnackBar(
                  context, 'The GPS feature will be added soon.'),
              isGrayedOut: true,
            ),
            DocumentationButtonComponent(
                iconData: Icons.camera_alt_outlined, onTap: _onTapCamera),
          ],
        ),
      ),
    );
  }

  _startEndTryAcceptAgainButton() {
    return Container();
  }

  void _onTapOpenMediaPage() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => MediaListPage(
          preTitle: '${widget.preTitle}/${_userChallenge.title}',
          userChallenge: _userChallenge,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  void _onTapEditChallenge() {
    if (widget.groupChallenge.isEditable()) {
      // currentChallengeIndex = widget.challenges.indexOf(challenge);
      Navigator.push(
        context,
        NoAnimationPageRouteComponent(
          builder: (context) => EditChallengePage(
            preTitle: '${widget.preTitle}/${widget.groupChallenge.title}',
            challenge: widget.groupChallenge,
          ),
        ),
      ).then((_) => {setState(() {})});
    }
  }

  // TODO: check deleting last challenge
  void _onTapDeleteChallenge() async {
    DeleteChallengeDialog.show(
        context: context,
        challengeTitle: widget.groupChallenge.title,
        onTapYes: () async {
          await _groupChallengesProvider.delete(widget.groupChallenge);
          // setState(() {
          //   if (currentChallengeIndex >= filteredChallenges.length) {
          //     currentChallengeIndex = filteredChallenges.length - 1;
          //   }
          // });
          // if (filteredChallenges.length == 1) {
          //   // ignore: use_build_context_synchronously
          //   Navigator.pop(context);
          // }
        });
  }

  void _onTapAcceptanceCriteria() {
    return;
  }

  void _onTapNewProgress() {
    return;
  }

  void _onTapCamera() async {
    // Ensure that plugin services are initialized so that `availableCameras()`
    // can be called before `runApp()`
    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // ignore: use_build_context_synchronously
    Navigator.push(
      // ignore: use_build_context_synchronously
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => MediaCameraPage(
          cameras: cameras,
          preTitle: '${widget.preTitle}/${_userChallenge.title}',
          mediaList: _userChallenge.media,
          userChallenge: _userChallenge,
        ),
      ),
    );
  }
}
