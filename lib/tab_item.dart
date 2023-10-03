// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum TabItem {
  Search(Icons.search),
  Home(Icons.person),
  Settings(Icons.settings);

  const TabItem(this.icon);
  final IconData icon;
}
