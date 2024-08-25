import 'package:challenge/globals.dart';
import 'package:challenge/ui/components/loading_circle/loading_circle_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:flutter/material.dart';

class CustomButtonComponent extends StatelessWidget {
  final VoidCallback onTap;
  final bool isPrimaryButton;
  final String text;
  final String? subText;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool isLoading;

  const CustomButtonComponent(
      {super.key,
      required this.onTap,
      this.isPrimaryButton = false,
      required this.text,
      this.subText,
      this.padding,
      this.margin,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return TapContainerComponent(
      onTap: onTap,
      backgroundColor: isPrimaryButton ? themeColor2 : Colors.white,
      onTapColor: isPrimaryButton ? Colors.white.withAlpha(20) : null,
      padding: padding,
      margin: margin,
      child: Stack(
        children: [
          Center(
            child: isLoading
                ? LoadingCircleComponent(
                    color: isPrimaryButton ? Colors.white : null,
                  )
                : Text(
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
    );
  }
}
