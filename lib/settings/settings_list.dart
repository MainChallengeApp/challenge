import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/components/list_item_icon_small.dart';
import 'package:challenge/models/challenge.dart';

class SettingsList extends StatefulWidget {
  const SettingsList(
      {super.key, required this.title, this.onPush});
  final String title;
  final ValueChanged<Challenge>? onPush;


  @override
  State<SettingsList> createState() => _SettingsListState();


}

class _SettingsListState extends State<SettingsList> {
  late Future<List<Challenge>> challengesFutures;

  @override
  void initState() {
    super.initState();
    challengesFutures = getChallenges(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: const Icon(Icons.chevron_left, color: Colors.transparent,),
          foregroundColor: Colors.black,
          titleSpacing: 0,
          title: Align(
            alignment: Alignment.topLeft,
            child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
              child: Text(
                widget.title,
                style: const TextStyle(color: Colors.black, fontSize: appBarFontSize),
              ),
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: Container(
          color: Colors.white,
          child: _buildList(),
        ));
  }

  Widget _buildList() {
    return FutureBuilder(
        future: challengesFutures,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            final challenges = snapshot.data!;

            return ListView.separated(
        itemCount: challenges.length + 1, // +1 for extra separator at the end
        separatorBuilder: (context, index) => const SizedBox(height: 17,),
        itemBuilder: (BuildContext content, int index) {
          if (index == challenges.length) return Container(); // for separator at the end
          return ListItemIconSmall(onTap: (){}, icon: Icons.settings, title: 'settings');
        });
          } else {
            return const Text('Error with loading data...');
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
