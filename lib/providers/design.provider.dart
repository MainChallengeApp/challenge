import 'package:flutter/material.dart';

class DesignProvider with ChangeNotifier {
  bool _isBottomNavBarVisible = true;
  bool isBottomNavBarVisible() => _isBottomNavBarVisible;
  setIsBottomNavBarVisible(bool value) {
    _isBottomNavBarVisible = value;
    notifyListeners();
  }

  bool _isRegistered = false;
  bool isRegistered() => _isRegistered;
  setIsRegistered(bool value) {
    _isRegistered = value;
    notifyListeners();
  }

  bool _triggeredSetStateHomeList = false;
  bool triggeredSetStateHomeList() => _triggeredSetStateHomeList;
  triggerSetStateHomeList() {
    _triggeredSetStateHomeList = true;
    notifyListeners();
    _triggeredSetStateHomeList = false;
  }
}
