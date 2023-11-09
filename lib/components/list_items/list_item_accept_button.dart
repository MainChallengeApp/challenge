// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ListItemAcceptButton extends StatelessWidget {
  ListItemAcceptButton({super.key, required this.onTapAccept});

  Function onTapAccept;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapAccept(),
      child: Center(
        child: Container(
          width: double.infinity,
          height: 64,
          margin: const EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
              borderRadius: const BorderRadius.all(Radius.circular(24))),
          child: const Center(child: Text('Accept')),
        ),
      ),
    );
  }
}
