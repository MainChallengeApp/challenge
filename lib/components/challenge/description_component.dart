import 'package:challenge/components/simple_components/custom_container_component.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class DescriptionComponent extends StatefulWidget {
  const DescriptionComponent(
      {super.key, required this.challenge, this.isDescriptionExpanded = false});
  final ChallengeModel challenge;
  final bool isDescriptionExpanded;

  @override
  State<DescriptionComponent> createState() => _DescriptionComponentState();
}

class _DescriptionComponentState extends State<DescriptionComponent> {
  @override
  Widget build(BuildContext context) {
    // return CustomContainerComponent(
    //   child: SingleChildScrollView(
    //     scrollDirection: Axis.vertical,
    //     child: Linkify(
    //       onOpen: (link) {
    //         _launchURL(link.url);
    //       },
    //       options: const LinkifyOptions(removeWww: true, humanize: true),
    //       text: widget.challenge.description,
    //       textAlign: TextAlign.justify,
    //       style: const TextStyle(fontSize: 12, color: themeColor3),
    //       linkStyle: TextStyle(
    //           decorationColor: Colors.blue[500], color: Colors.blue[500]),
    //     ),
    //   ),
    // );

    return widget.challenge.description.isNotEmpty
        ? widget.isDescriptionExpanded
            ? CustomContainerComponent(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Linkify(
                    onOpen: (link) {
                      _launchURL(link.url);
                    },
                    options:
                        const LinkifyOptions(removeWww: true, humanize: true),
                    text: widget.challenge.description,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 12, color: themeColor3),
                    linkStyle: TextStyle(
                        decorationColor: Colors.blue[500],
                        color: Colors.blue[500]),
                  ),
                ),
              )
            : CustomContainerComponent(
                child: Linkify(
                onOpen: (link) {
                  _launchURL(link.url);
                },
                options: const LinkifyOptions(removeWww: true, humanize: true),
                text: widget.challenge.description,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 12, color: themeColor3),
                linkStyle: TextStyle(
                    decorationColor: Colors.blue[500], color: Colors.blue[500]),
              ))
        : Container();
  }

  _launchURL(String link) async {
    final Uri url = Uri.parse(link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
