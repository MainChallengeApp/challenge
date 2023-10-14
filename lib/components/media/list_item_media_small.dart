import 'package:flutter/material.dart';
import 'package:challenge/models/challenge.dart';

class ListItemMediaSmall extends StatelessWidget {
  const ListItemMediaSmall(
      {super.key, required this.onTap, required this.media});

  final dynamic Function() onTap;

  final Media media;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          width: double.infinity,
          height: 64,
          margin: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1, color: const Color.fromRGBO(226, 232, 240, 1)),
              borderRadius: const BorderRadius.all(Radius.circular(24))),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(241, 245, 249, 1),
                    image: DecorationImage(
                      image: AssetImage(media.source),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(12))),
                margin: const EdgeInsets.all(12),
              ),
              Text(media.title)
            ],
          ),
        ),
      ),
    );
  }
}
