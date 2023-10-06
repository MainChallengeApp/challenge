import 'package:flutter/material.dart';
import 'package:nested_navigation_demo_flutter/globals.dart';

class ListItemIconSmall extends StatelessWidget {
  const ListItemIconSmall(
      {super.key, required this.onTap, required this.icon, required this.title});

  final dynamic Function() onTap;

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
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
                child: Center(child: Icon(icon, color: themeColor3,)),
              ),
              Text(title)
            ],
          ),
        ),
      ),
    );
  }
}
