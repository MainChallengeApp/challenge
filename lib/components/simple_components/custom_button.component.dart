import 'package:challenge/components/simple_components/custom_container.component.dart';
import 'package:challenge/globals.dart';
import 'package:flutter/material.dart';

class CustomButtonComponent extends StatelessWidget {
  final VoidCallback onTap;
  final bool isPrimaryButton;
  final String text;

  const CustomButtonComponent(
      {super.key,
      required this.onTap,
      this.isPrimaryButton = false,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomContainerComponent(
        backgroundColor: isPrimaryButton ? themeColor2 : Colors.white,
        child: Center(
            child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isPrimaryButton ? Colors.white : Colors.black),
        )),
      ),
    );
  }
}
