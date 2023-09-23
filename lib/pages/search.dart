// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flut/components/my_list/my_list.dart';
import 'package:flut/interfaces/my_page.dart';
import 'package:flut/providers/my_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MySearch extends MyPage{
  MySearch({super.key, required this.updateMain}){
    path = ['Search'];  
  }
  final VoidCallback updateMain;

  @override
  State<MySearch> createState() => _MySearchState();
}

class _MySearchState extends State<MySearch> {

    @override
  void initState() {
    super.initState();
    context.read<MyPathProvider>().addList('Home');
  }

  @override
  Widget build(BuildContext context) {
    return MyList(listTitle: 'Search' ,updateMain: widget.updateMain, addToPath: widget.addToPath,);
  }
}


