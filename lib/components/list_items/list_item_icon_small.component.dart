import 'package:challenge/components/list_items/list_item_container.component.dart';
import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';

class ListItemIconSmallComponent extends StatelessWidget {
  const ListItemIconSmallComponent(
      {super.key,
      required this.onTap,
      required this.icon,
      required this.title});

  final dynamic Function() onTap;

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListItemContainerComponent(
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(241, 245, 249, 1),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              margin: const EdgeInsets.only(right: 12),
              child: Center(
                  child: Icon(
                icon,
                color: themeColor3,
              )),
            ),
            Text(title)
          ],
        ),
      ),
    );
  }
}
