import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/media/image_media_model.dart';
import 'package:challenge/models/challenge/media/media_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/list_items/list_item_media_small_component.dart';
import 'package:challenge/ui/components/list_items/list_item_search_bar_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/pages/subpages/media/media_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MediaListPage extends StatefulWidget {
  const MediaListPage(
      {super.key,
      this.tapOnNewChallenge,
      required this.attempt,
      required this.groupChallenge,
      required this.participant});
  final Function? tapOnNewChallenge;
  final AttemptModel attempt;
  final GroupChallengeModel groupChallenge;
  final ParticipantModel participant;

  @override
  State<MediaListPage> createState() => _MediaListPageState();
}

class _MediaListPageState extends State<MediaListPage> {
  final _searchTextEditingController = TextEditingController();

  final _scrollController = ScrollController();

  final _groupChallengesProvider = getIt<GroupChallengesProvider>();

  final _usersProvider = getIt<UsersProvider>();

  final _mediaService = MediaService();

  late List<MediaModel> mediaList;

  @override
  Widget build(BuildContext context) {
    return ScaffoldComponent(
        appBar: const AppBarComponent(title: 'Media'),
        isBottomNavigationVisible: false,
        body: Container(
          color: Colors.white,
          child: _buildList(),
        ));
  }

  _buildList() {
    mediaList = widget.attempt.media
        .where((element) => element.title
            .toLowerCase()
            .contains(_searchTextEditingController.text.toLowerCase()))
        .toList();

    return Column(
      children: [
        SpaceColumnComponent(
          child: ListItemSearchBarComponent(
            changeList: _changeList,
            textEditingController: _searchTextEditingController,
            hintText: 'Search in your Media',
          ),
        ),
        Expanded(
          child: CupertinoScrollbar(
            controller: _scrollController,
            child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                itemCount: mediaList.length + 1, //+ 1 for new Media
                itemBuilder: (BuildContext content, int index) {
                  if (index == 0) {
                    return SpaceColumnComponent(
                      child: ListItemIconTextComponent(
                        icon: Icons.file_upload_rounded,
                        title: 'Upload Media',
                        onTap: _onTapUploadMedia,
                      ),
                    );
                  }
                  int newIndex = index - 1;
                  MediaModel media = mediaList.reversed.elementAt(newIndex);
                  return SpaceColumnComponent(
                    child: ListItemMediaSmallComponent(
                      onTap: () => _onTapMedia(context, index: newIndex),
                      media: media,
                      isEditableByUser:
                          widget.participant.user.id == _usersProvider.user.id,
                      onTapDeleteMedia: () => _onTapDeleteMedia(media),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }

  _changeList(String value) {
    setState(() {});
  }

  void _onTapMedia(BuildContext context, {required int index}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MediaDetailPage(
                mediaList: widget.attempt.media
                    .where((element) => element.title
                        .contains(_searchTextEditingController.text))
                    .toList(),
                initialMediaIndex: index,
                groupChallenge: widget.groupChallenge,
                participant: widget.participant,
                attempt: widget.attempt,
                onTapDelete: _onTapDeleteMedia,
              )),
    ).then((_) => setState(() {}));
  }

  _onTapUploadMedia() async {
    ImageMediaModel? imageMedia = await _mediaService.openImagePicker(context);
    if (imageMedia == null) {
      return;
    }

    setState(() {
      widget.attempt.media.add(imageMedia);
    });

    ImageMediaModel? mediaWithUrl = await _mediaService.uploadLocalImageMedia(
        imageMedia, widget.groupChallenge, widget.participant.user.id);

    if (mediaWithUrl == null) {
      return;
    }

    _groupChallengesProvider.updateAttempt(
        widget.groupChallenge, widget.participant, widget.attempt);
  }

  _onTapDeleteMedia(MediaModel media) {
    {
      _groupChallengesProvider.deleteMediaFromAttempt(
          widget.groupChallenge, widget.participant, widget.attempt, media);
      setState(() {
        mediaList.removeWhere((element) => element.id == media.id);
      });
    }
  }
}
