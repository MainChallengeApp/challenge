// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_declarations, must_be_immutable

import 'package:flut/components/my_list/my_list.dart';
import 'package:flut/interfaces/my_page.dart';
import 'package:flut/providers/my_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHome extends MyPage {

  final VoidCallback updateMain;

  MyHome({super.key, required this.updateMain}) {
    path = ['Home'];
  }
  
  
  
  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> with AutomaticKeepAliveClientMixin{

  @override
  void initState() {
    super.initState();
    context.read<MyPathProvider>().addList('Home');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MyList(listTitle:'Home', updateMain: widget.updateMain, addToPath: widget.addToPath);
  }
  
  @override
  bool get wantKeepAlive => true;
}
