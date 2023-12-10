import 'package:flutter/material.dart';

class DesignProvider with ChangeNotifier {
  bool _isBottomNavBarVisible = true;
  bool isBottomNavBarVisible() => _isBottomNavBarVisible;

  bool _isRegistered = false;
  bool isRegistered() => _isRegistered;

  setIsBottomNavBarVisible(bool value) {
    _isBottomNavBarVisible = value;
    notifyListeners();
  }

  setIsRegistered(bool value) {
    _isRegistered = value;
    notifyListeners();
  }
}
