import 'package:flutter/material.dart';

class DesignProvider with ChangeNotifier {
  bool _triggeredSetStateHomeList = false;
  bool triggeredSetStateHomeList() => _triggeredSetStateHomeList;
  triggerSetStateHomeList() {
    _triggeredSetStateHomeList = true;
    _triggeredSetStateHomeList = false;
    notifyListeners();
  }
}
