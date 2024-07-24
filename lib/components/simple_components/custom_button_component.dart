import 'package:challenge/components/simple_components/custom_container_component.dart';
import 'package:challenge/globals.dart';
import 'package:flutter/material.dart';

class CustomButtonComponent extends StatelessWidget {
  final VoidCallback onTap;
  final bool isPrimaryButton;
  final String text;
  final String? subText;
  final EdgeInsetsGeometry? padding;

  const CustomButtonComponent(
      {super.key,
      required this.onTap,
      this.isPrimaryButton = false,
      required this.text,
      this.subText,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomContainerComponent(
        backgroundColor: isPrimaryButton ? themeColor2 : Colors.white,
        padding: padding,
        child: Stack(
          children: [
            Center(
              child: Text(
                text,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isPrimaryButton ? Colors.white : Colors.black),
              ),
            ),
            subText != null
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      subText!,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 9,
                          color: isPrimaryButton ? Colors.white : Colors.black),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
