import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/challenge/thumbnail_max_component.dart';
import 'package:challenge/ui/components/search/search_description_component.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/snack_bar_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/components/simple_components/title_component.dart';
import 'package:challenge/ui/pages/subpages/edit_challenge/edit_challenge_page.dart';
import 'package:flutter/material.dart';

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
  final _tabProvider = getIt<TabProvider>();

  @override
  Widget build(BuildContext context) {
    return CardComponent(
      children: [
        _thumbnail(),
        _title(),
        _description(),
        _space(),
        _selectButton()
      ],
    );
  }

  SpaceComponent _space() => const SpaceComponent();

  _thumbnail() {
    return SpaceColumnComponent(
      height: 11,
      child: ThumbnailMaxComponent(
        challenge: widget.challenge,
        onTapOpenMediaPage: () => _onTapOpenMediaPage(),
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

  _selectButton() {
    return CustomButtonComponent(
      onTap: () => _onTapSelect(),
      isPrimaryButton: true,
      text: 'Select',
    );
  }

  void _onTapSelect() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditChallengePage(
          challenge: widget.challenge,
          isSearchEdit: true,
          isNewChallenge: true,
        ),
      ),
    ).then((_) {
      _tabProvider.setBottomNavigationVisibility(true);
      if (mounted) {
        setState(() {});
      }
    });
  }
}
