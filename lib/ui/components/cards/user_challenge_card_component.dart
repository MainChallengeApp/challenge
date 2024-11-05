// import 'package:camera/camera.dart';
// import 'package:challenge/enums/icon_enum.dart';
// import 'package:challenge/models/challenge/challenge_model.dart';
// import 'package:challenge/models/challenge/user_challenge_model.dart';
// import 'package:challenge/providers/user_challenges_provider.dart';
// import 'package:challenge/ui/components/cards/card_component.dart';
// import 'package:challenge/ui/components/challenge/acceptance_criteria_component.dart';
// import 'package:challenge/ui/components/challenge/action_button_component.dart';
// import 'package:challenge/ui/components/challenge/description_component.dart';
// import 'package:challenge/ui/components/challenge/documentation_button_component.dart';
// import 'package:challenge/ui/components/challenge/challenge_start_and_end_date_component.dart';
// import 'package:challenge/ui/components/challenge/thumbnail_max_component.dart';
// import 'package:challenge/ui/components/challenge/title_with_percentage_component.dart';
// import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
// import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
// import 'package:challenge/ui/components/simple_components/slider_component.dart';
// import 'package:challenge/ui/components/simple_components/snack_bar_component.dart';
// import 'package:challenge/ui/components/simple_components/space_column_component.dart';
// import 'package:challenge/ui/components/simple_components/space_component.dart';
// import 'package:challenge/ui/dialogs/delete_challenge_dialog.dart';
// import 'package:challenge/ui/dialogs/end_challenge_dialog.dart';
// import 'package:challenge/ui/pages/home/repetition/progress_media_list_page.dart';
// import 'package:challenge/ui/pages/home/repetition/repetition_page.dart';
// import 'package:challenge/ui/pages/subpages/edit_challenge/edit_challenge_page.dart';
// import 'package:challenge/ui/pages/subpages/media/media_camera_page.dart';
// import 'package:challenge/ui/pages/subpages/media/media_list_page.dart';
// import 'package:challenge/ui/themes/theme_constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:provider/provider.dart';

// class UserChallengeCardComponent extends StatefulWidget {
//   final UserChallengeModel userChallenge;
//   final String preTitle;

//   const UserChallengeCardComponent(
//       {super.key, required this.userChallenge, required this.preTitle});

//   @override
//   State<UserChallengeCardComponent> createState() =>
//       _UserChallengeCardComponentState();
// }

// class _UserChallengeCardComponentState
//     extends State<UserChallengeCardComponent> {
//   bool _isDescriptionExpanded = false;

//   // providers
//   late final _userChallengesProvider =
//       Provider.of<UserChallengesProvider>(context, listen: false);

//   @override
//   Widget build(BuildContext context) {
//     return Slidable(
//       closeOnScroll: true,
//       key: ObjectKey(widget.userChallenge),
//       endActionPane: _endActionPane(),
//       child: Builder(builder: (context) {
//         return CardComponent(
//           children: [
//             _thumbnail(),
//             _title(),
//             _description(),
//             _startAndEndDate(),
//             _acceptanceCriteria(),
//             _expandedSpace(),
//             _documentationButtons(),
//             _startEndTryAcceptAgainButton()
//           ],
//         );
//       }),
//     );
//   }

//   _endActionPane() {
//     return ActionPane(
//       extentRatio: (widget.userChallenge.isEditable()) ? 0.5 : 0.25,
//       motion: const ScrollMotion(),
//       children: [
//         _editSlider(),
//         _separator(),
//         _deleteSlider(),
//         const SpaceComponent(
//           width: BottomNavigationComponent.standardMargin,
//         ),
//       ],
//     );
//   }

//   _editSlider() {
//     return Visibility(
//       visible: widget.userChallenge.isEditable(),
//       child: SliderComponent(
//           icon: IconEnum.edit.icon, label: 'Edit', onTap: _onTapEditChallenge),
//     );
//   }

//   _separator() {
//     return SpaceComponent(
//       width: BottomNavigationComponent.standardMargin,
//       isVisible: widget.userChallenge.isEditable(),
//     );
//   }

//   _deleteSlider() {
//     return SliderComponent(
//         icon: IconEnum.delete.icon,
//         label: 'Delete',
//         foregroundColor: Theme.of(context).colorScheme.redWithAlpha,
//         duration: Durations.short1,
//         onTap: _onTapDeleteChallenge);
//   }

//   _thumbnail() {
//     return SpaceColumnComponent(
//       height: 11,
//       child: ThumbnailMaxComponent(
//           challenge: widget.userChallenge,
//           onTapOpenMediaPage: _onTapOpenMediaPage),
//     );
//   }

//   _title() {
//     return SpaceColumnComponent(
//       height: 11,
//       child: TitleWithPercentageComponent(challenge: widget.userChallenge),
//     );
//   }

//   _description() {
//     DescriptionComponent descriptionComponent = DescriptionComponent(
//       challenge: widget.userChallenge,
//       isDescriptionExpanded: _isDescriptionExpanded,
//       onTap: () => setState(() {
//         _isDescriptionExpanded = !_isDescriptionExpanded;
//       }),
//     );
//     return _isDescriptionExpanded
//         ? Expanded(
//             child: Column(
//             children: [
//               Expanded(child: descriptionComponent),
//               widget.userChallenge.description.isNotEmpty
//                   ? const SpaceComponent()
//                   : Container()
//             ],
//           ))
//         : Column(
//             children: [
//               descriptionComponent,
//               widget.userChallenge.description.isNotEmpty
//                   ? const SpaceComponent()
//                   : Container()
//             ],
//           );
//   }

//   _startAndEndDate() {
//     return _isDescriptionExpanded
//         ? Container()
//         : SpaceColumnComponent(
//             child: ChallengeStartAndEndDateComponent(
//               editChallenge: widget.userChallenge,
//               isLocked: true,
//             ),
//           );
//   }

//   _acceptanceCriteria() {
//     return _isDescriptionExpanded
//         ? Container()
//         : AcceptanceCriteriaComponent(
//             onTap: _onTapAcceptanceCriteria,
//             onTapNewProgress: _onTapNewProgress,
//             challenge: widget.userChallenge,
//           );
//   }

//   _expandedSpace() {
//     return _isDescriptionExpanded ? Container() : Expanded(child: Container());
//   }

//   _documentationButtons() {
//     return Visibility(
//       visible: !_isDescriptionExpanded && widget.userChallenge.isInProgress(),
//       child: SpaceColumnComponent(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             DocumentationButtonComponent(
//               iconData: Icons.numbers_rounded,
//               onTap: () => SnackBarComponent.showSnackBar(
//                   context, 'The Numbers feature will be added soon.'),
//               isGrayedOut: true,
//             ),
//             DocumentationButtonComponent(
//               iconData: Icons.notes_rounded,
//               onTap: () => SnackBarComponent.showSnackBar(
//                   context, 'The Notes feature will be added soon.'),
//               isGrayedOut: true,
//             ),
//             DocumentationButtonComponent(
//               iconData: Icons.gps_not_fixed_rounded,
//               onTap: () => SnackBarComponent.showSnackBar(
//                   context, 'The GPS feature will be added soon.'),
//               isGrayedOut: true,
//             ),
//             DocumentationButtonComponent(
//                 iconData: Icons.camera_alt_outlined, onTap: _onTapCamera),
//           ],
//         ),
//       ),
//     );
//   }

//   _startEndTryAcceptAgainButton() {
//     return ActionButtonComponent(
//       attempt: widget.userChallenge,
//       onTapStart: _onTapStart,
//       onTapEnd: _onTapEnd,
//       onTapAgain: _onTapAgain,
//       onTapNext: _onTapNext,
//     );
//   }

//   void _onTapEditChallenge() {
//     if (widget.userChallenge.isEditable()) {
//       Navigator.push(
//         context,
//         NoAnimationPageRouteComponent(
//           builder: (context) => EditChallengePage(
//             preTitle: '${widget.preTitle}/${widget.userChallenge.title}',
//             challenge: widget.userChallenge,
//           ),
//         ),
//       ).then((_) => {setState(() {})});
//     }
//   }

//   void _onTapDeleteChallenge() async {
//     DeleteChallengeDialog.show(
//         context: context,
//         challengeTitle: widget.userChallenge.title,
//         onTapYes: () async =>
//             _userChallengesProvider.delete(widget.userChallenge));
//   }

  // _onTapAcceptanceCriteria() {
  //   if (widget.userChallenge.frequency.amount != null &&
  //       widget.userChallenge.frequency.amount! <= 0) {
  //     return;
  //   }
  //   Navigator.push(
  //     context,
  //     NoAnimationPageRouteComponent(
  //       builder: (context) => RepetitionPage(
  //           preTitle: '${widget.preTitle}/${widget.userChallenge.title}',
  //           userChallenge: widget.userChallenge),
  //     ),
  //   );
  // }

  // void _onTapNewProgress() {
  //   if (widget.userChallenge.getCurrentRepetition() == null) {
  //     return;
  //   }

  //   Navigator.push(
  //     context,
  //     NoAnimationPageRouteComponent(
  //       builder: (context) => ProgressMediaListPage(
  //         preTitle: '${widget.preTitle}/${widget.userChallenge.title}',
  //         repetition: widget.userChallenge.getCurrentRepetition()!,
  //         attempt: widget.userChallenge,
  //         isSaveInsteadOfEditButtonVisible: true,
  //       ),
  //     ),
  //   ).then((_) => setState(() {}));
  // }

//   void _onTapOpenMediaPage() {
//     Navigator.push(
//       context,
//       NoAnimationPageRouteComponent(
//         builder: (context) => MediaListPage(
//           preTitle: '${widget.preTitle}/${widget.userChallenge.title}',
//           attempt: widget.userChallenge,
//         ),
//       ),
//     ).then((_) => setState(() {}));
//   }

//   void _onTapCamera() async {
//     // Ensure that plugin services are initialized so that `availableCameras()`
//     // can be called before `runApp()`
//     WidgetsFlutterBinding.ensureInitialized();

//     // Obtain a list of the available cameras on the device.
//     final cameras = await availableCameras();

//     // ignore: use_build_context_synchronously
//     Navigator.push(
//       // ignore: use_build_context_synchronously
//       context,
//       NoAnimationPageRouteComponent(
//         builder: (context) => MediaCameraPage(
//           cameras: cameras,
//           preTitle: '${widget.preTitle}/${widget.userChallenge.title}',
//           mediaList: widget.userChallenge.media,
//           attempt: widget.userChallenge,
//         ),
//       ),
//     );
//   }

//   void _onTapStart(UserChallengeModel userChallenge) {
//     _userChallengesProvider.start(userChallenge);
//   }

  // void _onTapEnd(UserChallengeModel userChallenge) {
  //   if (userChallenge.canEndRepetition()) {
  //     userChallenge.endRepetition();
  //     _userChallengesProvider.update(userChallenge);
  //     return;
  //   }

  //   EndChallengeDialog.show(
  //       context: context,
  //       challengeTitle: userChallenge.title,
  //       onTapYes: () {
  //         _userChallengesProvider.end(userChallenge);
  //       });
  // }

  // void _onTapAgain(ChallengeModel challenge) {
  //   Navigator.push(
  //     context,
  //     NoAnimationPageRouteComponent(
  //       builder: (context) {
  //         ChallengeModel challengeCopy =
  //             challenge.copyChallenge(isTryAgain: true);
  //         return EditChallengePage(
  //           preTitle: '${widget.preTitle}/${challengeCopy.title}',
  //           challenge: challengeCopy,
  //           isTryAgain: true,
  //         );
  //       },
  //     ),
  //   );
  // }

  // void _onTapNext(UserChallengeModel userChallenge) {
  //   userChallenge.endRepetition();
  //   _userChallengesProvider.update(userChallenge);
  // }
// }
