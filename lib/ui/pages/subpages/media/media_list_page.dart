import 'dart:io';

import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/media_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/providers/group_challenges_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/list_items/list_item_media_small_component.dart';
import 'package:challenge/ui/components/list_items/list_item_search_bar_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/pages/subpages/media/media_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  String searchBarText = '';

  ScrollController scrollController = ScrollController();

  late final groupChallengesProvider =
      Provider.of<GroupChallengesProvider>(context, listen: false);

  late final _usersProvider =
      Provider.of<UsersProvider>(context, listen: false);

  MediaService mediaService = MediaService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarComponent(title: 'Media'),
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.white,
          child: _buildList(),
        ));
  }

  _buildList() {
    List<MediaModel> mediaList = widget.attempt.media
        .where((element) =>
            element.title.toLowerCase().contains(searchBarText.toLowerCase()))
        .toList();

    return Column(
      children: [
        SpaceColumnComponent(
          child: ListItemSearchBarComponent(
            changeList: changeList,
            textEditingController: TextEditingController(text: searchBarText),
            hintText: 'Search in your Media...',
          ),
        ),
        Expanded(
          child: RawScrollbar(
            controller: scrollController,
            radius: const Radius.circular(4),
            thumbColor: Theme.of(context).colorScheme.tertiary,
            padding: const EdgeInsets.only(right: 4),
            child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: scrollController,
                itemCount: mediaList.length + 1, //+ 1 for new Media
                itemBuilder: (BuildContext content, int index) {
                  if (index == 0) {
                    return SpaceColumnComponent(
                      child: ListItemIconTextComponent(
                        icon: Icons.file_upload_rounded,
                        title: 'Upload Media',
                        onTap: onTapUploadMedia,
                      ),
                    );
                  }
                  return SpaceColumnComponent(
                    child: ListItemMediaSmallComponent(
                      onTap: () => push(context, index: index - 1),
                      media: mediaList.reversed.elementAt(index - 1),
                      isEditableByUser:
                          widget.participant.user.id == _usersProvider.user.id,
                      onTapDeleteMedia: () {
                        MediaModel media =
                            mediaList.reversed.elementAt(index - 1);

                        mediaService.deleteMedia(media);
                        widget.attempt.removeMedia(media);
                        groupChallengesProvider.updateAttempt(
                            widget.groupChallenge,
                            widget.participant,
                            widget.attempt);

                        setState(() {
                          mediaList
                              .removeWhere((element) => element.id == media.id);
                        });

                        return;
                      },
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }

  changeList(String value) {
    setState(() {
      // challengesFutures = getChallenges(context);
      searchBarText = value;
    });
  }

  void push(BuildContext context, {required int index}) {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
          builder: (context) => MediaDetailPage(
                mediaList: widget.attempt.media
                    .where((element) => element.title.contains(searchBarText))
                    .toList(),
                initialMediaIndex: index,
                attempt: widget.attempt,
                onTap: onTapDeleteMedia,
              )),
    ).then((_) => setState(() {}));
  }

  onTapUploadMedia() async {
    MediaModel? media = await mediaService.openImagePicker(context);
    if (media == null) {
      return;
    }

    setState(() {
      widget.attempt.media.add(media);
    });

    MediaModel? mediaWithUrl = await mediaService.uploadLocalMedia(
        media, widget.groupChallenge, widget.participant.user.id);

    if (mediaWithUrl == null) {
      return;
    }

    groupChallengesProvider.updateAttempt(
        widget.groupChallenge, widget.participant, widget.attempt);
  }

  onTapDeleteMedia(MediaModel media) {
    {
      File file = File(media.source);
      file.exists().then((value) {
        if (value) {
          file.delete();
        }
      });

      widget.attempt.removeMedia(media);
      groupChallengesProvider.updateAttempt(
          widget.groupChallenge, widget.participant, widget.attempt);

      setState(() {});
    }
  }
}
