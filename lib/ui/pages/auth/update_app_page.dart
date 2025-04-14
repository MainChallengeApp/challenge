import 'package:challenge/services/env_vars_service.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_info_component.dart';
import 'package:challenge/ui/components/simple_components/snack_bar_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UpdateAppPage extends StatefulWidget {
  const UpdateAppPage({super.key});

  @override
  State<UpdateAppPage> createState() => _UpdateAppPageState();
}

class _UpdateAppPageState extends State<UpdateAppPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SpaceColumnComponent(
              child: ListItemInfoComponent(
                title: 'Update Required',
                text: 'Due to major changes you need to update the app.',
              ),
            ),
            SpaceColumnComponent(
                child: ListItemButtonComponent(
              onTap: () => _onTapUpdate(context),
              text: 'Update App',
              isMainButton: true,
            ))
          ],
        ),
      ),
    );
  }

  void _onTapUpdate(BuildContext context) async {
    // Open the app store with link
    var envVarsService = await EnvVarsService.create();
    String link = envVarsService.appStoreLink;

    // Open the app store with link
    if (await canLaunchUrlString(link)) {
      await launchUrlString(link, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        SnackBarComponent.showSnackBar(
          'Could not open the app store.',
          // ignore: use_build_context_synchronously
          context: context,
        );
      }
    }
  }
}
