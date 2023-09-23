import 'package:flutter/material.dart';

class MyPathProvider with ChangeNotifier {
  final Map<String, List<String>> _pagePaths = {};

    addList(String page) {
    if(_pagePaths[page] == null){
      _pagePaths[page] = [page];
    }
  }

  addPath(String page, String s) {
    _pagePaths[page]!.add(s);
    notifyListeners();
  }

  removePath(String page) {
    _pagePaths[page]!.removeLast();
    notifyListeners();
  }

  String getPathStringByArray(String page) {
    if (_pagePaths[page] != null) {
      String changedPath = _pagePaths[page]!.first;
      for (var i = 1; i < _pagePaths[page]!.length; i++) {
        changedPath += "/${_pagePaths[page]![i]}";
      }
      return changedPath;
    }
    addList(page);
    return page;
  }

  List<String> path(String page){
    if(_pagePaths[page] != null){
      return _pagePaths[page]!;
    } else {
      addList(page);
      return _pagePaths[page]!;
    }
  }
}
