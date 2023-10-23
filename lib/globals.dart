import 'package:challenge/models/challenge.dart';
import 'package:flutter/material.dart';

import 'models/tab_item.dart';

const double appBarFontSize = 22;
const Color themeColor1 = Color.fromRGBO(15, 23, 42, 1);
const Color themeColor2 = Color.fromRGBO(51, 65, 85, 1);
const Color themeColor3 = Color.fromRGBO(100, 116, 139, 1);
const Color themeColor4 = Color.fromRGBO(241, 245, 249, 1);

List<Challenge> challengeList = [];
List<Challenge> allChallengesList = [];

final navigatorKeys = {
    TabItem.Search: GlobalKey<NavigatorState>(),
    TabItem.Home: GlobalKey<NavigatorState>(),
    TabItem.Settings: GlobalKey<NavigatorState>(),
  };