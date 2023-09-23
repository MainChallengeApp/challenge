import 'package:flut/globals.dart';
import 'package:flutter/material.dart';

class MyListProvider with ChangeNotifier{

  final Map<String, String> _listViewModes = {};
  String changedPath = "";

  changeListView(String page){
    if(_listViewModes[page] == 'max') {
      _listViewModes[page] = 'min';
    } else if (_listViewModes[page] ==  'min') {
      _listViewModes[page] = 'max';
    }
    notifyListeners();
  }

  String? listViewMode(String listTitle) => _listViewModes[listTitle];

  addList(String listTitle) {
    if(_listViewModes[listTitle] == null){
      _listViewModes[listTitle] = 'min';
    }
  }

  changePath(Function(String) f, String s){
    changedPath = "a";
    f(s);
    notifyListeners();
  }

  String getPathStringByArray(List<String> path) {
    changedPath = path[0];
    for (var i = 1; i < path.length; i++) {
      changedPath += "/${path[i]}";
    }
    return changedPath;
}
}