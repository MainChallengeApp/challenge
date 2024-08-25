// ignore_for_file: must_be_immutable
import 'package:challenge/globals.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/loading_circle/loading_circle_component.dart';
import 'package:flutter/material.dart';

class ListItemButtonComponent extends StatelessWidget {
  const ListItemButtonComponent(
      {super.key,
      required this.onTap,
      this.isMainButton = true,
      required this.text,
      this.margin,
      this.padding,
      this.textColor,
      this.isLoading = false});

  final VoidCallback onTap;
  final bool isMainButton;
  final String text;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? textColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ListItemContainerComponent(
      backgroundColor: isMainButton ? themeColor2 : Colors.white,
      onTap: onTap,
      onTapColor: isMainButton ? Colors.white.withAlpha(20) : null,
      margin: margin,
      padding: padding,
      child: Center(
          child: isLoading
              ? LoadingCircleComponent(
                  color: isMainButton ? Colors.white : null,
                )
              : Text(
                  text,
                  style: TextStyle(
                      color: textColor ??
                          (isMainButton ? Colors.white : Colors.black),
                      fontSize: basicFontSize),
                )),
    );
  }
}
