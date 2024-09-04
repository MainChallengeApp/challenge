import 'package:challenge/globals.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:flutter/material.dart';

class UserNameComponent extends StatelessWidget {
  final String userName;

  const UserNameComponent({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomContainerComponent(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            userName,
            style: const TextStyle(color: themeColor3),
          ),
        ),
      ),
    );
  }
}
