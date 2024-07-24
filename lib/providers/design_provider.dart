import 'package:flutter/material.dart';

class DesignProvider with ChangeNotifier {
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
    _triggeredSetStateHomeList = false;
    notifyListeners();
  }
}
