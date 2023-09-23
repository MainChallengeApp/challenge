// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'dart:convert';

import 'package:flut/components/my_list/my_list_max.dart';
import 'package:flut/components/my_list/my_list_min.dart';
import 'package:flut/globals.dart';
import 'package:flut/models/challenge.dart';
import 'package:flut/providers/my_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyList extends StatefulWidget {
  MyList(
      {super.key,
      required this.listTitle,
      required this.updateMain,
      required this.addToPath});

  final VoidCallback updateMain;
  final Function(String) addToPath;
  final String listTitle;

  @override
  State<MyList> createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  late Future<List<Challenge>> challengesFutures;

  @override
  void initState() {
    context.read<MyListProvider>().addList(widget.listTitle);
    challengesFutures = getChallenges(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: challengesFutures,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            final challenges = snapshot.data!;

            return context
                        .watch<MyListProvider>()
                        .listViewMode(widget.listTitle) ==
                    'max'
                ? MyListMax(
                  challenges: challenges,
                )
                : MyListMin(
                    listTitle: widget.listTitle,
                    challenges: challenges,
                  );
          } else {
            return Text('Error with loading data...');
          }
        });
  }

  static Future<List<Challenge>> getChallenges(BuildContext context) async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString('assets/home_challenges.json');

    final body = json.decode(data);
    return body.map<Challenge>(Challenge.fromJson).toList();
  }
}
