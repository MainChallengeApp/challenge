import 'package:challenge/models/challenge_model.dart';
import 'package:flutter/material.dart';

import 'enums/tab_item_enum.dart';

const double appBarFontSize = 22;
const Color themeColor1 = Color.fromRGBO(15, 23, 42, 1);
const Color themeColor2 = Color.fromRGBO(51, 65, 85, 1);
const Color themeColor3 = Color.fromRGBO(100, 116, 139, 1);
const Color themeColor4 = Color.fromRGBO(241, 245, 249, 1);
const Color themeColor5 = Color.fromRGBO(226, 232, 240, 1);

List<ChallengeModel> challengeList = [];
List<ChallengeModel> allChallengesList = [];

final navigatorKeys = {
  TabItemEnum.Search: GlobalKey<NavigatorState>(),
  TabItemEnum.Home: GlobalKey<NavigatorState>(),
  TabItemEnum.Settings: GlobalKey<NavigatorState>(),
};
