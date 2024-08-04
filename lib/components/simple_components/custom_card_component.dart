import 'package:challenge/components/list_items/list_item_container_component.dart';
import 'package:flutter/material.dart';

class CardComponent extends StatelessWidget {
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
                  margin:
                      const EdgeInsets.only(bottom: 16, left: 20, right: 20),
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  // height: 100,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: const Color.fromRGBO(226, 232, 240, 1)),
                      borderRadius: const BorderRadius.all(Radius.circular(
                          ListItemContainerComponent.standardBorderRadius))),
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
