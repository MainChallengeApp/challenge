import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

// TODO: merge with DescriptionComponent
class BioComponent extends StatefulWidget {
  final String? bio;
  final bool isBioExpanded;
  final void Function()? onTap;

  const BioComponent(
      {super.key, required this.bio, this.isBioExpanded = false, this.onTap});

  @override
  State<BioComponent> createState() => _BioComponentState();
}

class _BioComponentState extends State<BioComponent> {
  @override
  Widget build(BuildContext context) {
    return widget.isBioExpanded
        ? TapContainerComponent(
            height: double.infinity,
            onTap: widget.onTap,
            padding: const EdgeInsets.only(
                left: CustomContainerComponent.standardPadding,
                right: CustomContainerComponent.standardPadding,
                top: CustomContainerComponent.standardPadding - 2,
                bottom: CustomContainerComponent.standardPadding - 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    child: Linkify(
                      onOpen: (link) {
                        _launchURL(link.url);
                      },
                      options:
                          const LinkifyOptions(removeWww: true, humanize: true),
                      text: widget.bio!,
                      textAlign: TextAlign.justify,
                      style: Theme.of(context).textTheme.bodyMedium,
                      linkStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                              decorationColor:
                                  Theme.of(context).colorScheme.linkColor,
                              color: Theme.of(context).colorScheme.linkColor),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text('show less',
                      style: Theme.of(context).textTheme.bodyMedium),
                )
              ],
            ),
          )
        : TapContainerComponent(
            onTap: widget.onTap,
            padding: const EdgeInsets.only(
                left: CustomContainerComponent.standardPadding,
                right: CustomContainerComponent.standardPadding,
                top: CustomContainerComponent.standardPadding - 2,
                bottom: CustomContainerComponent.standardPadding - 2),
            child: widget.bio == null || widget.bio!.isEmpty
                ? TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: 'Bio',
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(0),
                      isDense: true,
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                  )
                : Linkify(
                    onOpen: (link) {
                      _launchURL(link.url);
                    },
                    options:
                        const LinkifyOptions(removeWww: true, humanize: true),
                    text: widget.bio!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.bodyMedium,
                    linkStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        decorationColor:
                            Theme.of(context).colorScheme.linkColor,
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
