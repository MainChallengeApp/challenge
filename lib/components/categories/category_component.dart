// ignore_for_file: must_be_immutable

import 'package:challenge/globals.dart';
import 'package:challenge/components/simple_components/custom_container_component.dart';
import 'package:flutter/material.dart';

class CategoryComponent extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final String? imagePath;
  final IconData? icon;
  void Function()? onTap;

  CategoryComponent(
      {super.key,
      required this.text,
      this.backgroundColor = Colors.white,
      this.imagePath,
      required this.onTap,
      this.icon});

  @override
  Widget build(BuildContext context) {
    if (imagePath != null && icon != null) {
      throw Exception("Only one of imagePath or icon can be used");
    } else if (imagePath == null && icon == null) {
      throw Exception("One of imagePath or icon must be used");
    }

    return GestureDetector(
      onTap: onTap,
      child: CustomContainerComponent(
          height: 96,
          padding: const EdgeInsets.all(12),
          borderRadius: 24,
          child: Stack(children: [
            Align(
                alignment: Alignment.topLeft,
                child: Container(
                  decoration: const BoxDecoration(
                      color: themeColor4,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  width: 70,
                  height: 70,
                  child: icon != null
                      ? Center(
                          child: Icon(
                            icon,
                            color: themeColor3,
                            size: 30,
                          ),
                        )
                      : ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          child: Transform.scale(
                            scale: 0.8,
                            child: Image.asset(
                              imagePath!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                )),
            Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12))),
                  child: Text(
                    text,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                        color: themeColor1,
                        fontSize: 11,
                        fontWeight: FontWeight.w700),
                  ),
                )),
          ])),
    );
  }
}
