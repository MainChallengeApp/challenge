import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/challenge/thumbnail_max_component.dart';
import 'package:challenge/ui/components/search/search_description_component.dart';
import 'package:challenge/ui/components/simple_components/snack_bar_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:challenge/ui/components/simple_components/title_component.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchChallengeCardComponent extends StatefulWidget {
  final ChallengeModel challenge;

  const SearchChallengeCardComponent({super.key, required this.challenge});

  @override
  State<SearchChallengeCardComponent> createState() =>
      _SearchChallengeCardComponentState();
}

class _SearchChallengeCardComponentState
    extends State<SearchChallengeCardComponent> {
  BuildContext? panelContext;

  @override
  Widget build(BuildContext context) {
    return CardComponent(
      children: [_thumbnail(), _title(), _description(), _space(), _adButton()],
    );
  }

  _space() {
    return Visibility(
        visible: widget.challenge.ad != null, child: const SpaceComponent());
  }

  _thumbnail() {
    return SpaceColumnComponent(
      height: 11,
      child: ThumbnailMaxComponent(
        thumbnail: widget.challenge.thumbnail,
        onTap: () => _onTapOpenMediaPage(),
      ),
    );
  }

  _onTapOpenMediaPage() {
    SnackBarComponent.showSnackBar('The Video Trailer will be added soon');
  }

  _title() {
    return SpaceColumnComponent(
      height: 11,
      child: TitleComponent(
        title: widget.challenge.title,
      ),
    );
  }

  _description() {
    return Expanded(
      child: SearchDescriptionComponent(text: widget.challenge.description),
    );
  }

  _adButton() {
    return Visibility(
      visible: widget.challenge.ad != null,
      child: TapContainerComponent(
        onTap: _onTapAd,
        child: Row(children: [
          Expanded(
            child: Text(widget.challenge.ad?.text ?? '',
                overflow: TextOverflow.ellipsis, maxLines: 1),
          ),
          Icon(
            IconEnum.link.icon,
            size: Theme.of(context).textTheme.titleLarge?.fontSize,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ]),
      ),
    );
  }

  void _onTapAd() {
    launchUrl(Uri.parse(widget.challenge.ad!.url),
        mode: LaunchMode.externalApplication);
  }
}
