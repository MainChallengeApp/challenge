// ignore_for_file: must_be_immutable

import 'package:challenge/components/challenge/description_component.dart';
import 'package:challenge/components/challenge/frequency_component.dart';
import 'package:challenge/components/challenge/thumbnail_max_component.dart';
import 'package:challenge/components/challenge/title_component.dart';
import 'package:challenge/components/simple_components/custom_card_component.dart';
import 'package:challenge/components/simple_components/space_component.dart';
import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/models/frequency_model.dart';
import 'package:challenge/pages/subpages/edit_challenge/add_acceptance_criteria_page.dart';
import 'package:challenge/components/simple_components/snack_bar_component.dart';
import 'package:challenge/components/navigation/app_bar_component.dart';
import 'package:challenge/json_file_controller/challenge_controller.dart';
import 'package:challenge/utils/design_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:challenge/pages/subpages/edit_challenge/edit_challenge_page.dart';
import 'package:challenge/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/enums/tab_item_enum.dart';
import 'package:challenge/models/acceptance_criteria_model.dart';
import 'package:challenge/pages/home/home_challenge_page.dart';

class SearchChallengePage extends StatefulWidget {
  SearchChallengePage(
      {super.key,
      required this.title,
      required this.challenge,
      required this.selectTab,
      required this.challenges,
      required this.initialChalleneIndex});
  final String title;
  ChallengeModel challenge;
  final Function selectTab;
  final List<ChallengeModel> challenges;
  int initialChalleneIndex;

  @override
  State<SearchChallengePage> createState() => _SearchChallengePageState();
}

class _SearchChallengePageState extends State<SearchChallengePage> {
  bool isDescriptionExpanded = false;
  late PageController pageController =
      PageController(initialPage: widget.initialChalleneIndex);
  late BuildContext context2;

  late String currentTitle = widget.challenge.title;

  TextEditingController amountTextEditingController =
      TextEditingController(text: '');

  TextEditingController unitTextEditingController =
      TextEditingController(text: '');

  TextEditingController frequencyAmountTextEditingController =
      TextEditingController(text: '');

  bool isKeyboardUp = false;

  @override
  void initState() {
    super.initState();
    amountTextEditingController.text =
        DesignUtil.doubleAsInt(widget.challenge.acceptanceCriterias[0].amount)
            .toString();

    unitTextEditingController.text =
        widget.challenge.acceptanceCriterias[0].unit;

    frequencyAmountTextEditingController.text =
        widget.challenge.acceptanceCriterias[0].frequency.amount.toString();
  }

  @override
  Widget build(BuildContext context) {
    widget.challenge = widget.challenges[widget.initialChalleneIndex];
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        setIsKeyboardUp(false);
      },
      child: Scaffold(
        appBar: AppBarComponent(preTitle: widget.title),
        backgroundColor: Colors.white,
        body: Center(
          child: PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              scrollDirection: Axis.vertical,
              children: widget.challenges.map(
                (challenge) {
                  return Slidable(
                    closeOnScroll: true,
                    // The end action pane is the one at the right or the bottom side.
                    endActionPane: ActionPane(
                      extentRatio: 0.25,
                      motion: const ScrollMotion(),
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: GestureDetector(
                            onTap: () => onTapEditChallenge(),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 1,
                                      color: const Color.fromRGBO(
                                          226, 232, 240, 1)),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(24))),
                              child: const Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.edit),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text("Edit")
                                ],
                              )),
                            ),
                          ),
                        )),
                        const SizedBox(
                          width: 20,
                        ),
                        // Expanded(
                        //   child: GestureDetector(
                        //     onTap: tapOnFavorite,
                        //     child: Container(
                        //       decoration: BoxDecoration(
                        //           color: Colors.white,
                        //           border: Border.all(
                        //               width: 1,
                        //               color: const Color.fromRGBO(
                        //                   226, 232, 240, 1)),
                        //           borderRadius: const BorderRadius.all(
                        //               Radius.circular(24))),
                        //       child: const Center(
                        //           child: Column(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           Icon(
                        //             Icons.star_border_outlined,
                        //             color: Colors.yellow,
                        //           ),
                        //           SizedBox(
                        //             height: 5,
                        //           ),
                        //           Text(
                        //             "Favorite",
                        //             style: TextStyle(color: Colors.yellow),
                        //           )
                        //         ],
                        //       )),
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(
                        //   width: 20,
                        // ),
                      ],
                    ),
                    child: Builder(builder: (context) {
                      context2 = context;
                      return CardComponent(
                        scrollPhysics: isKeyboardUp
                            ? const AlwaysScrollableScrollPhysics()
                            : widget.challenges.length == 1
                                ? const AlwaysScrollableScrollPhysics()
                                : const NeverScrollableScrollPhysics(),
                        children: [
                          thumbnail(challenge, context),
                          title(challenge.title),
                          description(challenge),
                          startAndEndDate(challenge),
                          amountAndUnit(challenge),
                          frequency(challenge),
                          isDescriptionExpanded
                              ? Container()
                              : Expanded(child: Container()),
                          acceptButton()
                        ],
                      );
                    }),
                  );
                },
              ).toList()),
        ),
      ),
    );
  }

  acceptButton() {
    return isDescriptionExpanded
        ? Container()
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Expanded(
              //   child: GestureDetector(
              //     onTap: onTapEditChallenge,
              //     child: Container(
              //       height: 55,
              //       width: double.infinity,
              //       decoration: BoxDecoration(
              //           border: Border.all(
              //               width: 1,
              //               color:
              //                   const Color.fromRGBO(
              //                       226,
              //                       232,
              //                       240,
              //                       1)),
              //           borderRadius:
              //               const BorderRadius.all(
              //                   Radius.circular(16))),
              //       child: const Center(
              //           child: Text(
              //         'Edit',
              //         style: TextStyle(
              //             fontWeight: FontWeight.w500,
              //             color: Colors.black),
              //       )),
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   width: 16,
              // ),
              Expanded(
                child: GestureDetector(
                  onTap: onTapAccept,
                  child: Container(
                    height: 55,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: themeColor2,
                        border: Border.all(
                            width: 1,
                            color: const Color.fromRGBO(226, 232, 240, 1)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16))),
                    child: const Center(
                        child: Text(
                      'Accept',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    )),
                  ),
                ),
              ),
            ],
          );
  }

  thumbnail(ChallengeModel challenge, BuildContext context) {
    return Column(
      children: [
        ThumbnailMaxComponent(
          challengeModel: challenge,
          isMediaListVisible: false,
          onTapOpenMediaPage: () => onTapOpenMediaPage(context),
        ),
        const SpaceComponent()
      ],
    );
  }

  description(ChallengeModel challenge) {
    DescriptionComponent descriptionComponent = DescriptionComponent(
      challenge: challenge,
      isDescriptionExpanded: isDescriptionExpanded,
    );
    return isDescriptionExpanded
        ? Expanded(
            child: GestureDetector(
                onTap: () => setState(() {
                      isDescriptionExpanded = !isDescriptionExpanded;
                    }),
                child: descriptionComponent))
        : Column(
            children: [
              GestureDetector(
                  onTap: () => setState(() {
                        isDescriptionExpanded = !isDescriptionExpanded;
                      }),
                  child: descriptionComponent),
              challenge.description.isNotEmpty
                  ? const SpaceComponent()
                  : Container()
            ],
          );
  }

  onTapOpenMediaPage(BuildContext context) {
    SnackBarComponent.showSnackBar(
        context, 'The Video Trailer will be added soon');
  }

  Widget startAndEndDate(ChallengeModel e) {
    return isDescriptionExpanded
        ? Container()
        : Row(
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
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        (e.startDate != null ? _dateFormat(e.startDate!) : '-'),
                        style: const TextStyle(color: themeColor3),
                      )
                    ],
                  )),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () => onTapStartOrEndDate('end'),
                  child: standardContainer(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'End',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        (e.endDate != null ? _dateFormat(e.endDate!) : '-'),
                        style: const TextStyle(color: themeColor3),
                      )
                    ],
                  )),
                ),
              ),
            ],
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
  acceptanceCriteria(List<AcceptanceCriteriaModel> acceptanceCriterias) {
    return SizedBox(
        // margin: EdgeInsets.only(top: 10),
        height: 55,
        // padding: const EdgeInsets.all(10),
        child: PageView.builder(
          itemCount: acceptanceCriterias.length,
          controller: PageController(viewportFraction: 1),
          onPageChanged: (int index) =>
              setState(() => selectedAcceptanceCriteria = index),
          itemBuilder: (_, i) {
            return Transform.scale(
              scale: i == selectedAcceptanceCriteria ? 1 : 0.9,
              child: singleAcceptanceCriteria(acceptanceCriterias[i]),
            );
          },
        ));
  }

  singleAcceptanceCriteria(AcceptanceCriteriaModel acceptanceCriteria) {
    return GestureDetector(
      onTap: () => onTapAcceptanceCriteria(acceptanceCriteria),
      child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white.withAlpha(170),
              border: Border.all(
                  width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 160, // Set your desired maximum width
                ),
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: themeColor4,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Text(
                    '${acceptanceCriteria.title} ${acceptanceCriteria.amount} ${acceptanceCriteria.unit}',
                    style: const TextStyle(fontSize: 12, color: themeColor3),
                    overflow: TextOverflow.ellipsis),
              ),
              Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: themeColor4,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Text(acceptanceCriteria.frequency.toString(),
                    style: const TextStyle(fontSize: 12, color: themeColor3),
                    overflow: TextOverflow.ellipsis),
              ),
              Expanded(child: Container()),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: themeColor4,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Icon(getIconData(acceptanceCriteria),
                    color: themeColor3, size: 14),
              ),
            ],
          )),
    );
  }

  IconData getIconData(AcceptanceCriteriaModel acceptanceCriteria) {
    if (acceptanceCriteria.tracking == 'camera') {
      return Icons.camera_alt_outlined;
    } else if (acceptanceCriteria.tracking == 'gps') {
      return Icons.gps_not_fixed;
    } else if (acceptanceCriteria.tracking == 'notes') {
      return Icons.notes;
    } else if (acceptanceCriteria.tracking == 'numbers') {
      return Icons.numbers;
    } else {
      return Icons.not_accessible;
    }
  }

  dots(List<AcceptanceCriteriaModel> acceptanceCriteria) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
            acceptanceCriteria.length,
            (index) => Padding(
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 10, bottom: 23),
                  child: Icon(
                    Icons.fiber_manual_record,
                    size: 6,
                    color: index == selectedAcceptanceCriteria
                        ? themeColor3
                        : themeColor3.withAlpha(100),
                  ),
                )));
  }

  void onTapAccept() async {
    ChallengeModel challengeCopy =
        ChallengeModel.copyChallenge(widget.challenge);

    // modifyChallengeWorkAroundForShowingThumbnailInMediaHehehe(challengeCopy);

    ChallengeController challengeController = ChallengeController();
    allChallengesList.insert(0, challengeCopy);
    challengeList.insert(0, challengeCopy);
    await challengeController.writeFile(context, allChallengesList);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);

    widget.selectTab(TabItemEnum.Home);

    // ignore: use_build_context_synchronously
    var homeNavigator = navigatorKeys[TabItemEnum.Home]!.currentState!;

    homeNavigator.popUntil((route) => route.isFirst);
    // // ignore: use_build_context_synchronously
    // while (await homeNavigator.maybePop(context)) {
    //   // ignore: use_build_context_synchronously
    //   homeNavigator.pop(context);
    // }
    homeNavigator.push(
      NoAnimationPageRouteComponent(
        builder: (context) => HomeChallengePage(
          preTitle: 'Home',
          challenge: challengeCopy,
          initialChalleneIndex: 0,
        ), // Todo: change initalChallengeIndex when id is known from backend
      ),
    );
  }

  void onPageChanged(int value) {
    setState(() {
      widget.challenge = widget.challenges[value];
      currentTitle = widget.challenge.title;
      widget.initialChalleneIndex = value;
      pageController = PageController(initialPage: value);
      selectedAcceptanceCriteria = 0;
      isDescriptionExpanded = false;
      amountTextEditingController.text =
          DesignUtil.doubleAsInt(widget.challenge.acceptanceCriterias[0].amount)
              .toString();
      unitTextEditingController.text =
          widget.challenge.acceptanceCriterias[0].unit;
    });
  }

  void onTapEditChallenge() {
    Slidable.of(context2)?.close(duration: Duration.zero);
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => EditChallengePage(
          preTitle: '${widget.title}/${widget.challenge.title}',
          challenge: widget.challenge,
          isSearchEdit: true,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  standardContainer({required Widget child, double heightFactor = 1}) {
    return Container(
      // width: double.infinity,
      height: 55 * heightFactor,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      child: child,
    );
  }

  void onTapStartOrEndDate(String startOrEnd) async {
    DateTime? initialDateTime =
        startOrEnd == 'start' || widget.challenge.endDate == null
            ? widget.challenge.startDate
            : widget.challenge.endDate;
    setState(() {
      if (startOrEnd == 'start') {
        widget.challenge.startDate = null;
      } else if (startOrEnd == 'end') {
        widget.challenge.endDate = null;
        widget.challenge.setChallengeFrequencyAmount();
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
                  widget.challenge.startDate = initialDateTime ??
                      DesignUtil.dateWithoutTime(DateTime.now());
                }
                widget.challenge.setChallengeEndDate();
              });
            } else if (startOrEnd == 'end') {
              setState(() {
                if (!isDateTimeChanged) {
                  widget.challenge.endDate = initialDateTime ??
                      DesignUtil.dateWithoutTime(DateTime.now());
                }
                widget.challenge.setChallengeFrequencyAmount();
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
                      widget.challenge.acceptanceCriterias.first.frequency
                              .amount ==
                          null &&
                      widget.challenge.startDate != null
                  ? widget.challenge.endDate
                  : null,
              minimumDate: startOrEnd == 'end'
                  ? initialDateTime != null
                      ? widget.challenge.startDate
                      : null
                  : DesignUtil.dateWithoutTime(DateTime.now()),
              initialDateTime: initialDateTime,
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (value) {
                value = DesignUtil.dateWithoutTime(value);
                isDateTimeChanged = true;
                setState(() {
                  if (startOrEnd == 'start') {
                    widget.challenge.startDate = value;
                    widget.challenge.setChallengeEndDate();
                  } else if (startOrEnd == 'end') {
                    widget.challenge.endDate = value;
                    widget.challenge.setChallengeFrequencyAmount();
                  }
                });
              },
            ),
          ),
        );
      },
    );
  }

  void onTapAcceptanceCriteria(AcceptanceCriteriaModel acceptanceCriteria) {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => AddAcceptanceCriteriaPage(
            preTitle: '${widget.title}/${widget.challenge.title}',
            challenge: widget.challenge,
            acceptanceCriteria: acceptanceCriteria,
            acceptanceCriteriaIndex: widget.challenge.acceptanceCriterias
                .indexOf(acceptanceCriteria),
            areButtonsVisible: false),
      ),
    ).then((_) => setState(() {
          selectedAcceptanceCriteria = 0;
        }));
  }

  addAcceptanceCriteriaButton() {
    return GestureDetector(
      onTap: onTapAddAcceptanceCriteriaButton,
      child: standardContainer(
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.only(right: 10),
              decoration: const BoxDecoration(
                  color: themeColor4,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: const Center(
                  child: Icon(
                Icons.add_rounded,
                color: themeColor3,
              )),
            ),
            const SizedBox(
              width: 200,
              height: 40,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Add Acceptance Criteria')),
            ),
            const Expanded(
              child: SizedBox(),
            ),
            const Icon(
              Icons.chevron_right_outlined,
              color: themeColor3,
            )
          ],
        ),
      ),
    );
  }

  void onTapAddAcceptanceCriteriaButton() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => AddAcceptanceCriteriaPage(
          preTitle: '${widget.title}/${widget.challenge.title}/',
          challenge: widget.challenge,
          acceptanceCriteria: AcceptanceCriteriaModel(
              id: widget.challenge.acceptanceCriterias.length,
              title: '',
              amount: 0,
              unit: '',
              frequency:
                  FrequencyModel(amount: 1, type: FrequencyTypeEnum.time),
              tracking: '',
              currentProgress: 0,
              progress: []),
          acceptanceCriteriaIndex: null,
        ),
      ),
    ).then((_) => setState(() {
          selectedAcceptanceCriteria = 0;
        }));
  }

  amountAndUnit(ChallengeModel challenge) {
    if (challenge.acceptanceCriterias.isEmpty) return Container();
    AcceptanceCriteriaModel acceptanceCriteria =
        challenge.acceptanceCriterias[0];
    return isDescriptionExpanded
        ? Container()
        : Row(
            children: [
              Expanded(
                  child: standardContainer(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    style: const TextStyle(fontSize: basicFontSize),
                    textAlign: TextAlign.end,
                    controller:
                        amountTextEditingController, // somehow TextEditingController()..text = doesnt work anymore!?
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                      TextInputFormatter.withFunction(
                        (oldValue, newValue) => newValue.copyWith(
                          text: newValue.text.replaceAll(',', '.'),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        double number = 0;
                        if (value.endsWith('.')) {
                          number = double.parse(value.split('.')[0]);
                          acceptanceCriteria.amount = number;
                        } else if (value == '') {
                          acceptanceCriteria.amount = 0;
                        } else {
                          number = double.parse(value);
                          acceptanceCriteria.amount = number;
                        }
                      });
                    },
                    onTap: () => setIsKeyboardUp(true),
                    decoration: const InputDecoration.collapsed(hintText: '0'),
                  ),
                ),
              )),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                  flex: 2,
                  child: standardContainer(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        style: const TextStyle(fontSize: basicFontSize),
                        controller: unitTextEditingController,
                        onChanged: (value) {
                          acceptanceCriteria.unit = value;
                        },
                        onTap: () => setIsKeyboardUp(true),
                        onSubmitted: (_) => setIsKeyboardUp(false),
                        onEditingComplete: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          setIsKeyboardUp(false);
                        },
                        decoration:
                            const InputDecoration.collapsed(hintText: 'Unit'),
                      ),
                    ),
                  )),
            ],
          );
  }

  frequency(ChallengeModel challenge) {
    return isDescriptionExpanded
        ? Container()
        : Column(
            children: [
              FrequencyComponent(
                  challenge: challenge,
                  setIsKeyboardUp: setIsKeyboardUp,
                  reloadSeachChallengePage: setState2),
              const SpaceComponent()
            ],
          );
  }

  title(String challengeTitle) {
    return Column(
      children: [
        TitleComponent(challengeTitle: challengeTitle),
        const SpaceComponent()
      ],
    );
  }

  setIsKeyboardUp(bool isKeyboardReallyUp) {
    setState(() {
      isKeyboardUp = isKeyboardReallyUp;
    });
  }

  setState2() {
    setState(() {});
  }
}
