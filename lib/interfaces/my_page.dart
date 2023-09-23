// ignore_for_file: must_be_immutable, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

abstract class MyPage extends StatefulWidget {
  MyPage({super.key});
  List<String> path = [];


  @override
  State<MyPage> createState() => _MyPageState();

  List<String> getPath() => path;

  addToPath(String subpath){
    path.add(subpath);
  }

}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// class MyPage{

//   late final List<String> path;

//   List<String> getPath() => path;

// }