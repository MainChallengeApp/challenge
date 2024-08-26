// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum TabItemEnum {
  search(icon: Icons.search_rounded, name: 'Search'),
  home(imagePath: 'assets/icons/challenge_icon.png', name: 'Home'),
  profile(icon: Icons.person_rounded, name: 'Profile');

  const TabItemEnum({this.icon, this.imagePath, required this.name});
  final IconData? icon;
  final String? imagePath;
  final String name;
}
