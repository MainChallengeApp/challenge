// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum TabItemEnum {
  Search(icon: Icons.search_rounded),
  Home(imagePath: 'assets/icons/challenge_icon.png'),
  Settings(icon: Icons.settings_rounded);

  const TabItemEnum({this.icon, this.imagePath});
  final IconData? icon;
  final String? imagePath;
}
