// import 'package:challenge/globals.dart';
// import 'package:challenge/ui/components/loading_circle/refresh_indicator_component.dart';
// import 'package:flutter/material.dart';

// class PaginatedScrollList extends StatefulWidget {
//   final List list;
//   final Function()? onScrollEnd;
//   final Function? onRefresh;

//   const PaginatedScrollList(
//       {super.key,
//       required this.list,
//       this.onScrollEnd, this.onRefresh});

//   @override
//   State<PaginatedScrollList> createState() => _PaginatedScrollListState();
// }

// class _PaginatedScrollListState extends State<PaginatedScrollList> {
//   final scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     scrollController.addListener(() {
//       if (scrollController.position.pixels ==
//           scrollController.position.maxScrollExtent) {
//         widget.onScrollEnd?.call();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {

//     return RefreshIndicatorComponent(
//       scrollController: scrollController,
//       onRefresh: widget.onRefresh?.call(),
//       child: RawScrollbar(
//         controller: scrollController,
//         radius: const Radius.circular(4),
//         thumbColor: Theme.of(context).colorScheme.tertiary,
//         padding: const EdgeInsets.only(right: 4),
//         child: ListView.builder(
//             physics: const AlwaysScrollableScrollPhysics(),
//             controller: scrollController,
//             itemCount: widget.list.length +
//                 1, // + 1 for loading circle or  new Challenge
//             itemBuilder: (BuildContext content, int index) {
//               numberOfBuilds++;
//               if (index == searchChallenges.length) {
//                 return listeningSearchChallengesProvider
//                         .isEndOfSearchedListReached
//                     ? SpaceColumnComponent(
//                         child: ListItemIconTextComponent(
//                         onTap: onTapNewChallenge,
//                         icon: IconEnum.add.icon,
//                         title: textEditingController.text == ''
//                             ? 'New Challenge'
//                             : textEditingController.text,
//                       ))
//                     : const Center(
//                         child: SpaceColumnComponent(
//                             child: LoadingCircleComponent()),
//                       );
//               }

//               ChallengeModel challenge = searchChallenges[index];
//               return SpaceColumnComponent(
//                 child: ListItemChallengeSmallComponent(
//                   onTap: () => onTapChallenge(
//                       challenge: challenge,
//                       index: index), // widget.onPush?.call(challenge),
//                   challenge: challenge,
//                   isSearch: true,
//                 ),
//               );
//             }),
//       ),
//     );
//   }
// }
