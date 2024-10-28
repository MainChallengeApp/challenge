import 'package:flutter/material.dart';

class CardComponent extends StatelessWidget {
  static const double standardBorderRadius = 24;
  static const double standardBottomMargin = 16;
  static const double standardSideMargin = 20;
  static const double standardPadding = 16;

  final List<Widget> children;
  final ScrollPhysics scrollPhysics;
  final ScrollController? scrollController;

  const CardComponent(
      {super.key,
      this.children = const [],
      this.scrollPhysics = const NeverScrollableScrollPhysics(),
      this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomScrollView(
        physics: scrollPhysics,
        controller: scrollController,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              margin: const EdgeInsets.only(
                  bottom: standardBottomMargin,
                  left: standardSideMargin,
                  right: standardSideMargin),
              padding: const EdgeInsets.all(standardPadding),
              width: null,
              height: null, // just to make it static
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
                  borderRadius: const BorderRadius.all(
                      Radius.circular(standardBorderRadius))),
              child: Column(
                children: children,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
