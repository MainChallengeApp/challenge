// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flut/interfaces/my_page.dart';
import 'package:flutter/material.dart';


class MySettings extends MyPage {
  MySettings({super.key, required this.updateMain}){
    path = ['Settings'];
  }

  final VoidCallback updateMain;

  @override
  State<MySettings> createState() => _MySettingsState();
}

class _MySettingsState extends State<MySettings> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: [
          // MyListItemMin(icon: Icons.person_outlined, title: 'Profile', updateMain: widget.updateMain, addToPath: widget.addToPath,),
          // SizedBox(height: 16,),
          // MyListItemMin(icon: Icons.language, title: 'Language', updateMain: widget.updateMain, addToPath: widget.addToPath,),
          // SizedBox(height: 16,),
          // MyListItemMin(icon: Icons.numbers, title: 'Variables Settings', updateMain: widget.updateMain, addToPath: widget.addToPath,),
          // SizedBox(height: 16,),
          // MyListItemMin(icon: Icons.edit_outlined, title: 'Notes Settings', updateMain: widget.updateMain, addToPath: widget.addToPath,),
          // SizedBox(height: 16,),
          // MyListItemMin(icon: Icons.gps_not_fixed, title: 'GPS Settings', updateMain: widget.updateMain, addToPath: widget.addToPath,),
          // SizedBox(height: 16,),
          // MyListItemMin(icon: Icons.camera_alt_outlined, title: 'Camera Settings', updateMain: widget.updateMain, addToPath: widget.addToPath,),
          // SizedBox(height: 16,),
          // MyListItemMin(icon: Icons.feedback_outlined, title: 'Feedback', updateMain: widget.updateMain, addToPath: widget.addToPath,),
          // SizedBox(height: 16,),
          // MyListItemMin(icon: Icons.logout_outlined, title: 'Log Out', updateMain: widget.updateMain, addToPath: widget.addToPath,),
          SizedBox(height: 16,),
        ],
      ),
    );
  }
}
