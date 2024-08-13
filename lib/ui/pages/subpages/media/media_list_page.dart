import 'dart:io';

import 'package:challenge/enums/media_type_enum.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge/media_model.dart';
import 'package:challenge/models/challenge/user_challenge_model.dart';
import 'package:challenge/providers/user_challenges_provider.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/list_items/list_item_media_small_component.dart';
import 'package:challenge/ui/components/list_items/list_item_search_bar_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/pages/subpages/media/media_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MediaListPage extends StatefulWidget {
  const MediaListPage(
      {super.key,
      required this.preTitle,
      this.tapOnNewChallenge,
      required this.userChallenge});
  final String preTitle;
  final Function? tapOnNewChallenge;
  final UserChallengeModel userChallenge;

  @override
  State<MediaListPage> createState() => _MediaListPageState();
}

class _MediaListPageState extends State<MediaListPage> {
  String searchBarText = '';

  ScrollController scrollController = ScrollController();

  late final userChallengesProvider =
      Provider.of<UserChallengesProvider>(context, listen: false);

  MediaService mediaService = MediaService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarComponent(preTitle: widget.preTitle, titleText: 'Media'),
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.white,
          child: _buildList(),
        ));
  }

  _buildList() {
    List<MediaModel> mediaList = widget.userChallenge.media
        .where((element) =>
            element.title.toLowerCase().contains(searchBarText.toLowerCase()))
        .toList();

    return RawScrollbar(
      controller: scrollController,
      radius: const Radius.circular(4),
      thumbColor: themeColor3,
      padding: const EdgeInsets.only(right: 4),
      child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          itemCount:
              mediaList.length + 1 + 1, // + 1 for searchBar + 1 for new Media
          itemBuilder: (BuildContext content, int index) {
            if (index == 0) {
              return SpaceColumnComponent(
                child: ListItemSearchBarComponent(
                  changeList: changeList,
                  textEditingController:
                      TextEditingController(text: searchBarText),
                ),
              );
            }

            if (index == 1) {
              return SpaceColumnComponent(
                child: ListItemIconTextComponent(
                  icon: Icons.file_upload_rounded,
                  title: 'Upload Media',
                  onTap: onTapUploadMedia,
                ),
              );
            }
            // if (index == 1) {
            //   return ListItemIconSmall(
            //     onTap: () => 0, // not yet implemented
            //     icon: Icons.add_rounded,
            //     title: 'Upload Media',
            //   );
            // }
            return SpaceColumnComponent(
              child: ListItemMediaSmallComponent(
                onTap: () => push(context, index: index - 1 - 1),
                media: mediaList.reversed.elementAt(index - 1 - 1),
                onTapDeleteMedia: () {
                  MediaModel media =
                      mediaList.reversed.elementAt(index - 1 - 1);

                  mediaService.deleteMedia(media);
                  widget.userChallenge.removeMedia(media);
                  userChallengesProvider.update(widget.userChallenge);

                  setState(() {
                    mediaList.removeWhere((element) => element.id == media.id);
                  });

                  return;
                },
              ),
            );
          }),
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
                mediaList: widget.userChallenge.media
                    .where((element) => element.title.contains(searchBarText))
                    .toList(),
                preTitle: '${widget.preTitle}/Media',
                initialMediaIndex: index,
                userChallenge: widget.userChallenge,
                onTap: onTapDeleteMedia,
              )),
    ).then((_) => setState(() {}));
  }

  onTapUploadMedia() async {
    XFile? file = await mediaService.onTapUploadMedia();
    if (file != null) {
      setState(() {
        widget.userChallenge.media.add(MediaModel(
            type: MediaTypeEnum.image,
            title: DateTime.now().toString().split('.')[0],
            source: file.path));
      });
      userChallengesProvider.update(widget.userChallenge);
    }
  }

  onTapDeleteMedia(MediaModel media) {
    {
      File file = File(media.source);
      file.exists().then((value) {
        if (value) {
          file.delete();
        }
      });

      widget.userChallenge.removeMedia(media);
      userChallengesProvider.update(widget.userChallenge);

      setState(() {});
    }
  }
}
