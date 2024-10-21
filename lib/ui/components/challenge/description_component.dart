import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class DescriptionComponent extends StatefulWidget {
  final ChallengeModel challenge;
  final bool isDescriptionExpanded;
  final void Function()? onTap;

  const DescriptionComponent(
      {super.key,
      required this.challenge,
      this.isDescriptionExpanded = false,
      this.onTap});

  @override
  State<DescriptionComponent> createState() => _DescriptionComponentState();
}

class _DescriptionComponentState extends State<DescriptionComponent> {
  @override
  Widget build(BuildContext context) {
    return widget.challenge.description.isNotEmpty
        ? widget.isDescriptionExpanded
            ? TapContainerComponent(
                height: double.infinity,
                onTap: widget.onTap,
                padding: const EdgeInsets.only(
                    left: CustomContainerComponent.standardPadding,
                    right: CustomContainerComponent.standardPadding,
                    top: CustomContainerComponent.standardPadding - 2,
                    bottom: CustomContainerComponent.standardPadding - 2),
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
                      style: Theme.of(context).textTheme.bodyMedium,
                      linkStyle:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.linkColor,
                                decorationColor:
                                    Theme.of(context).colorScheme.linkColor,
                              )),
                ),
              )
            : TapContainerComponent(
                onTap: widget.onTap,
                padding: const EdgeInsets.only(
                    left: CustomContainerComponent.standardPadding,
                    right: CustomContainerComponent.standardPadding,
                    top: CustomContainerComponent.standardPadding - 2,
                    bottom: CustomContainerComponent.standardPadding - 2),
                child: Linkify(
                  onOpen: (link) {
                    _launchURL(link.url);
                  },
                  options:
                      const LinkifyOptions(removeWww: true, humanize: true),
                  text: widget.challenge.description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.bodyMedium,
                  linkStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.linkColor,
                        decorationColor:
                            Theme.of(context).colorScheme.linkColor,
                      ),
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
