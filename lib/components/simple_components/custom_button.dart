import 'package:challenge/components/simple_components/custom_container.dart';
import 'package:challenge/globals.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isPrimaryButton;
  final String text;

  const CustomButton(
      {super.key,
      required this.onTap,
      this.isPrimaryButton = false,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomContainer(
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
