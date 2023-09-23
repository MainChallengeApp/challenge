// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, must_be_immutable, sized_box_for_whitespace

import 'package:flut/globals.dart';
import 'package:flut/interfaces/my_page.dart';
import 'package:flut/pages/home.dart';
import 'package:flut/pages/search.dart';
import 'package:flut/pages/settings.dart';
import 'package:flut/providers/my_list_provider.dart';
import 'package:flut/providers/my_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => MyListProvider()),
      ChangeNotifierProvider(create: (_) => MyPathProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Challenge',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController? controller;

  Map<String, MyPage> pages = {};

  @override
  void initState() {
    super.initState();

    pages = {
      'Search': MySearch(
        updateMain: updateMain,
      ),
      'Home': MyHome(
        updateMain: updateMain,
      ),
      'Settings': MySettings(
        updateMain: updateMain,
      )
    };

    controller = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> pagePath = context.watch<MyPathProvider>().path(selectedPage);
    String title =
        context.read<MyPathProvider>().getPathStringByArray(selectedPage);

    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            title: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (pagePath.length > 1) {
                        context.read<MyPathProvider>().removePath(selectedPage);
                        context
                            .read<MyListProvider>()
                            .changeListView(selectedPage);
                      }
                    });
                  },
                  child: Icon(Icons.arrow_back_ios,
                      color: Color.fromRGBO(
                          0, 0, 0, pagePath.length == 1 ? 0 : 1)),
                ),
                Text(title, textAlign: TextAlign.left),
              ],
            ),
            centerTitle: false,
          ),
          body: TabBarView(physics: NeverScrollableScrollPhysics() ,controller: controller, children: [
            MySearch(updateMain: updateMain),
            MyHome(updateMain: updateMain),
            MySettings(updateMain: updateMain)
          ]),
          bottomNavigationBar: Container(
            height: 93,
            child: Column(
              children: [
                Container(
                  width: 345,
                  height: 72,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      color: Color.fromRGBO(15, 23, 42, 1)),
                  child: TabBar(
                      onTap: (value) {
                        if (value == 0) {
                          selectedPage = 'Search';
                        } else if (value == 1) {
                          selectedPage = 'Home';
                        } else if (value == 2) {
                          selectedPage = 'Settings';
                        }
                        updateMain();
                      },
                      indicatorColor: Colors.transparent,
                      controller: controller,
                      tabs: [
                        Container(
                            width: 53,
                            height: 53,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(
                                    51, 65, 85, controller?.index == 0 ? 1 : 0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16))),
                            child: Tab(
                                icon: Icon(
                              Icons.search,
                              color: Colors.white,
                            ))),
                        Container(
                            width: 53,
                            height: 53,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(
                                    51, 65, 85, controller?.index == 1 ? 1 : 0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16))),
                            child: Tab(
                                icon: Icon(
                              Icons.person,
                              color: Colors.white,
                            ))),
                        Container(
                            width: 53,
                            height: 53,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(
                                    51, 65, 85, controller?.index == 2 ? 1 : 0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16))),
                            child: Tab(
                                icon: Icon(
                              Icons.settings,
                              color: Colors.white,
                            ))),
                      ]),
                ),
              ],
            ),
          ),

          // Center(
          //   child: Stack(
          //     children: <Widget>[
          //       Positioned(
          //           child: Align(
          //               alignment: Alignment.topCenter,
          //               child: Container(
          //                   height: 120 + 8 * 64 + 2 + 16,
          //                   child: pages[selectedPage] as Widget))),
          //       Positioned.fill(
          //           bottom: 10,
          //           child: Align(
          //               alignment: Alignment.bottomCenter,
          //               child: MyTabBar(updateMain: updateMain))),
          //     ],
          //   ),
          // ),
        ));
  }

  updateMain() {
    setState(() {});
  }
}
