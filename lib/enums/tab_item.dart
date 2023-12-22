// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum TabItem {
  Search(Icons.search_rounded),
  Home(Icons.person),
  Settings(Icons.settings_rounded);

  const TabItem(this.icon);
  final IconData icon;
}
