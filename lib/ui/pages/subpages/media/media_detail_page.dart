import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/enums/media_type_enum.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/media/image_media_model.dart';
import 'package:challenge/models/challenge/media/media_model.dart';
import 'package:challenge/models/challenge/media/note_media_model.dart';
import 'package:challenge/models/challenge/media/stopwatch_media_model.dart';
import 'package:challenge/models/challenge/participant_model.dart';
import 'package:challenge/services/scroll_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/cards/media/image_media_card_component.dart';
import 'package:challenge/ui/components/cards/media/note_media_card_component.dart';
import 'package:challenge/ui/components/cards/media/stopwatch_media_card_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/pages/subpages/media/media_note_page.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';

class MediaDetailPage extends StatefulWidget {
  final List<MediaModel> mediaList;
  final int initialMediaIndex;
  final GroupChallengeModel groupChallenge;
  final ParticipantModel participant;
  final AttemptModel attempt;
  final void Function(MediaModel)? onTapDelete;
  final bool isEditableByUser;

  const MediaDetailPage(
      {super.key,
      required this.mediaList,
      required this.initialMediaIndex,
      required this.attempt,
      this.onTapDelete,
      this.isEditableByUser = true,
      required this.groupChallenge,
      required this.participant});

  @override
  State<MediaDetailPage> createState() => _MediaDetailPageState();
}

class _MediaDetailPageState extends State<MediaDetailPage>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController =
      PageController(initialPage: widget.initialMediaIndex);
  late int _currentMediaIndex = widget.initialMediaIndex;

  bool _isFullScreen = false;

  late AnimationController _animationController;
  late Animation<Offset> _actionButtonsAnimation;
  late Animation<Offset> _appBarAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _actionButtonsAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, 1.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _appBarAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, -1.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    ScrollService.fixOverScroll(_pageController, () => widget.mediaList.length);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldComponent(
      isBottomNavigationVisible: false,
      body: Column(
        children: [_appBar(), _media(), _actionButtons()],
      ),
    );
  }

  AnimatedBuilder _actionButtons() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Align(
          alignment: Alignment.bottomCenter,
          heightFactor: 1.0 - _animationController.value,
          child: SlideTransition(
            position: _actionButtonsAnimation,
            child: _actionButtonsButtons(),
          ),
        );
      },
    );
  }

  Expanded _media() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isFullScreen = !_isFullScreen;
            _isFullScreen
                ? _animationController.forward()
                : _animationController.reverse();
          });
        },
        child: Stack(
          children: [
            PageView(
              physics: const AlwaysScrollableScrollPhysics(),
              onPageChanged: _onSwipeMedia,
              scrollDirection: Axis.vertical,
              controller: _pageController,
              children: widget.mediaList.reversed.map((media) {
                switch (media.type) {
                  case MediaTypeEnum.image:
                    return ImageMediaCardComponent(
                        imageMedia: media as ImageMediaModel,
                        isFullScreen: _isFullScreen);
                  case MediaTypeEnum.note:
                    return NoteMediaCardComponent(
                      noteMedia: media as NoteMediaModel,
                      isFullScreen: _isFullScreen,
                    );
                  case MediaTypeEnum.stopwatch:
                    return StopwatchMediaCardComponent(
                      stopwatchMedia: media as StopwatchMediaModel,
                      isFullScreen: _isFullScreen,
                    );
                  default:
                    return Container();
                }
              }).toList(),
            ),
            _actionButtonSpace(),
          ],
        ),
      ),
    );
  }

  AnimatedBuilder _appBar() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return ClipRect(
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: 1.0 - _animationController.value,
            child: SlideTransition(
              position: _appBarAnimation,
              child: const AppBarComponent(
                title: 'Media',
              ),
            ),
          ),
        );
      },
    );
  }

  // workaround to achieve the correct visible spacing
  Visibility _actionButtonSpace() {
    return Visibility(
      visible: !_isFullScreen,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: SpaceComponent.standardHeight,
          width: double.infinity,
          color: Colors.white,
        ),
      ),
    );
  }

  void _onSwipeMedia(int value) {
    setState(() {
      _currentMediaIndex = value;
    });
  }

  void _onTapDelete() {
    setState(() {
      MediaModel media = widget.mediaList.reversed.toList()[_currentMediaIndex];
      widget.mediaList.removeWhere((element) => element.id == media.id);

      widget.onTapDelete?.call(media);

      if (widget.mediaList.isEmpty) {
        Navigator.pop(context);
        return;
      }

      if (_currentMediaIndex >= widget.mediaList.length) {
        _currentMediaIndex = widget.mediaList.length - 1;
      }
    });
  }

  _actionButtonsButtons() {
    bool isEditableType =
        widget.mediaList.reversed.toList()[_currentMediaIndex].type ==
            MediaTypeEnum.note;
    return SpaceColumnComponent(
      height: BottomNavigationComponent.standardMargin,
      child: Row(
        children: widget.isEditableByUser
            ? [
                const SpaceComponent(
                  width: ListItemContainerComponent.standardMargin,
                ),
                Expanded(
                    child: ListItemButtonComponent(
                  onTap: _onTapCancel,
                  text: '',
                  icon: IconEnum.arrowLeft.icon,
                  margin: EdgeInsets.zero,
                  isMainButton: false,
                )),
                const SpaceComponent(),
                Expanded(
                    child: ListItemButtonComponent(
                  onTap: _onTapEdit,
                  text: '',
                  icon: IconEnum.edit.icon,
                  margin: EdgeInsets.zero,
                  isMainButton: false,
                  isEnabled: isEditableType,
                )),
                const SpaceComponent(),
                Expanded(
                    child: ListItemButtonComponent(
                  onTap: _onTapDelete,
                  text: '',
                  icon: IconEnum.delete.icon,
                  margin: EdgeInsets.zero,
                  textColor: Theme.of(context).colorScheme.red,
                  isMainButton: false,
                )),
                const SpaceComponent(
                  width: ListItemContainerComponent.standardMargin,
                ),
              ]
            : [
                const SpaceComponent(
                  width: ListItemContainerComponent.standardMargin,
                ),
                Expanded(
                    child: ListItemButtonComponent(
                  onTap: _onTapCancel,
                  text: 'Cancel',
                  margin: EdgeInsets.zero,
                  isMainButton: false,
                )),
                const SpaceComponent(
                  width: ListItemContainerComponent.standardMargin,
                ),
              ],
      ),
    );
  }

  void _onTapEdit() {
    MediaModel media = widget.mediaList.reversed.toList()[_currentMediaIndex];
    switch (media.type) {
      case MediaTypeEnum.note:
        Navigator.push(context, MaterialPageRoute(builder: (builder) {
          return MediaNotePage(
            noteMedia: media as NoteMediaModel,
            groupChallenge: widget.groupChallenge,
            participant: widget.participant,
            attempt: widget.attempt,
            isEdit: true,
          );
        })).then((_) {
          setState(() {});
        });
        break;
      default:
        break;
    }
  }

  void _onTapCancel() {
    Navigator.pop(context);
  }
}
