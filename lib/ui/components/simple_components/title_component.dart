import 'package:flutter/material.dart';

class TitleComponent extends StatelessWidget {
  final String title;

  const TitleComponent({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0 + 1),
          child: Text(title,
              style: const TextStyle(fontSize: 20),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left),
        ),
      ),
    );
  }
}
