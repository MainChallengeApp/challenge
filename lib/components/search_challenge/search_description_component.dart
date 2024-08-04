import 'package:challenge/components/simple_components/custom_container_component.dart';
import 'package:challenge/globals.dart';
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
        child: Linkify(
          onOpen: (link) {
            _launchURL(link.url);
          },
          options: const LinkifyOptions(removeWww: true, humanize: true),
          text: text,
          textAlign: TextAlign.justify,
          style: const TextStyle(fontSize: basicFontSize, color: themeColor3),
          linkStyle: TextStyle(
              decorationColor: Colors.blue[500], color: Colors.blue[500]),
        ));
  }

  _launchURL(String link) async {
    final Uri url = Uri.parse(link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
