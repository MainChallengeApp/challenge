import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchDescriptionComponent extends StatelessWidget {
  final String text;

  const SearchDescriptionComponent({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainerComponent(
        height: double.infinity,
        padding: const EdgeInsets.only(
            left: CustomContainerComponent.standardPadding,
            right: CustomContainerComponent.standardPadding,
            top: CustomContainerComponent.standardPadding - 2,
            bottom: CustomContainerComponent.standardPadding - 2),
        child: Linkify(
          onOpen: (link) {
            _launchURL(link.url);
          },
          options: const LinkifyOptions(removeWww: true, humanize: true),
          text: text,
          textAlign: TextAlign.justify,
          style: Theme.of(context).textTheme.bodyMedium,
          linkStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              decorationColor: Theme.of(context).colorScheme.linkColor,
              color: Theme.of(context).colorScheme.linkColor),
        ));
  }

  _launchURL(String link) async {
    final Uri url = Uri.parse(link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
