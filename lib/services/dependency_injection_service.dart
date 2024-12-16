import 'package:challenge/collections/group_challenges_collection.dart';
import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/providers/notifications_provider.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

final getIt = GetIt.instance;

void setupDependencies(BuildContext context) {
  getIt.registerSingleton<GroupChallengesCollection>(
      GroupChallengesCollection());

  getIt.registerSingleton<TabProvider>(
      Provider.of<TabProvider>(context, listen: false));

  getIt.registerSingleton<NotificationsProvider>(
      Provider.of<NotificationsProvider>(context, listen: false));

  getIt.registerSingleton<UsersProvider>(
      Provider.of<UsersProvider>(context, listen: false));

  getIt.registerSingleton<GroupChallengesProvider>(
      Provider.of<GroupChallengesProvider>(context, listen: false));
}
