import 'package:challenge/components/list_items/list_item_icon_small.dart';
import 'package:challenge/components/list_items/list_item_media_small.dart';
import 'package:challenge/pages/subpages/media/media_detail.dart';
import 'package:challenge/components/media/upload_media.dart';
import 'package:challenge/components/navigation/custom_app_bar.dart';
import 'package:challenge/json_file_controller/challenge_controller.dart';
import 'package:flutter/material.dart';
import 'package:challenge/components/list_items/list_item_search_bar.dart';
import 'package:challenge/models/challenge.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:challenge/globals.dart';
import 'package:challenge/models/media.dart';
import 'package:challenge/providers/design_provider.dart';
import 'package:challenge/components/navigation/no_animation_page_route.dart';

class MediaList extends StatefulWidget {
  const MediaList(
      {super.key,
      required this.preTitle,
      this.tapOnNewChallenge,
      required this.challenge});
  final String preTitle;
  final Function? tapOnNewChallenge;
  final Challenge challenge;

  @override
  State<MediaList> createState() => _MediaListState();
}

class _MediaListState extends State<MediaList> {
  String searchBarText = "";

  ScrollController scrollController = ScrollController();

  ChallengeController challengeController = ChallengeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomeAppBar(preTitle: widget.preTitle, titleText: 'Media'),
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.white,
          child: _buildList(),
        ));
  }

  Widget _buildList() {
    List<Media> mediaList = widget.challenge.media
        .where((element) => element.title.contains(searchBarText))
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
              mediaList.length + 1 + 1, // + 1 for searchbar + 1 for new Media
          itemBuilder: (BuildContext content, int index) {
            if (index == 0) {
              return Column(
                children: [
                  ListItemSearchbar(
                    changeList: changeList,
                  ),
                  const SizedBox(
                    height: 17,
                  )
                ],
              );
            }

            if (index == 1) {
              return Column(
                children: [
                  ListItemIconSmall(
                    icon: Icons.file_upload_rounded,
                    title: 'Upload Media',
                    onTap: onTapUploadMedia,
                  ),
                  const SizedBox(
                    height: 17,
                  )
                ],
              );
            }
            // if (index == 1) {
            //   return ListItemIconSmall(
            //     onTap: () => 0, // not yet implemented
            //     icon: Icons.add_rounded,
            //     title: "Upload Media",
            //   );
            // }
            return Column(
              children: [
                ListItemMediaSmall(
                  onTap: () => ppush(context, index: index - 1 - 1),
                  media: mediaList[index - 1 - 1],
                ),
                const SizedBox(
                  height: 17,
                )
              ],
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

  void ppush(BuildContext context, {required int index}) {
    context.read<DesignProvider>().setIsBottomNavBarVisible(false);
    Navigator.push(
      context,
      NoAnimationPageRoute(
        builder: (context) => MediaDetail(
          media: widget.challenge.media
              .where((element) => element.title.contains(searchBarText))
              .toList(),
          preTitle: '${widget.preTitle}/Media',
          initialMediaIdex: index,
          challenge: widget.challenge,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  onTapUploadMedia() async {
    XFile? file = await UploadMedia.onTapUploadMedia();
    if (file != null) {
      setState(() {
        widget.challenge.media.add(Media(
            type: 'image',
            title: DateTime.now().toString().split('.')[0],
            source: file.path));
        challengeController.writeFile(context, allChallengesList);
      });
    }
  }
}
