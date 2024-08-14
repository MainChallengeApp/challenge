import 'package:flutter/material.dart';

class CardComponent extends StatelessWidget {
  static const double standardBorderRadius = 24;
  static const double standardBottomMargin = 16;
  static const double standardSideMargin = 20;
  static const double standardPadding = 16;

  final List<Widget> children;
  final ScrollPhysics scrollPhysics;

  const CardComponent(
      {super.key,
      this.children = const [],
      this.scrollPhysics = const NeverScrollableScrollPhysics()});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomScrollView(
        physics: scrollPhysics,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: <Widget>[
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.only(
                      bottom: standardBottomMargin,
                      left: standardSideMargin,
                      right: standardSideMargin),
                  padding: const EdgeInsets.all(standardPadding),
                  width: double.infinity,
                  // height: 100,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: const Color.fromRGBO(226, 232, 240, 1)),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(standardBorderRadius))),
                  child: Column(
                    children: children,
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
