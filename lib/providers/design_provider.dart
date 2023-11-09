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

//   String? listViewMode(String listTitle) => _listViewModes[listTitle];

//   addList(String listTitle) {
//     if(_listViewModes[listTitle] == null){
//       _listViewModes[listTitle] = 'min';
//     }
//   }

//   changePath(Function(String) f, String s){
//     changedPath = "a";
//     f(s);
//     notifyListeners();
//   }

//   String getPathStringByArray(List<String> path) {
//     changedPath = path[0];
//     for (var i = 1; i < path.length; i++) {
//       changedPath += "/${path[i]}";
//     }
//     return changedPath;
// }
}
