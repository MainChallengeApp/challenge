import 'package:flutter/material.dart';
import 'package:nested_navigation_demo_flutter/globals.dart';

class ListItemSearchbar extends StatelessWidget {
  const ListItemSearchbar(
      {super.key});


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 345,
        height: 64,
        decoration: BoxDecoration(
            border: Border.all(
                width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
            borderRadius: const BorderRadius.all(Radius.circular(16))),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(241, 245, 249, 1),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              margin: const EdgeInsets.all(12),
              child: Center(child: Icon(Icons.search, color: themeColor3,)),
            ),
            Container(
              width: 270,
              height: 40,
              child: Align(
                alignment: Alignment.centerLeft,
                child: const TextField(
                  decoration: InputDecoration.collapsed(
                  hintText: 'Search'
                ),
                          ),
              ),
            )
            // Text(title)
          ],
        ),
      ),
    );
  }
}
