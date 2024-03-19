import 'package:challenge/globals.dart';
import 'package:challenge/pages/components/simple_components/container_in_container_component.dart';
import 'package:flutter/material.dart';

class ContainerInContainerTextComponent extends StatelessWidget {
  final String text;

  const ContainerInContainerTextComponent({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return ContainerInContainerComponent(
        child: Text(text,
            style: const TextStyle(fontSize: 10, color: themeColor3),
            overflow: TextOverflow.ellipsis));
  }
}
