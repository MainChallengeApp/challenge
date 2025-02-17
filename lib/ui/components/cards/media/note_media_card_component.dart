import 'package:challenge/models/challenge/media/note_media_model.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:flutter/material.dart';

class NoteMediaCardComponent extends StatefulWidget {
  final NoteMediaModel noteMedia;
  final bool isFullScreen;
  const NoteMediaCardComponent({
    super.key,
    required this.noteMedia,
    required this.isFullScreen,
  });

  @override
  State<NoteMediaCardComponent> createState() => _NoteMediaCardComponentState();
}

class _NoteMediaCardComponentState extends State<NoteMediaCardComponent> {
  @override
  Widget build(BuildContext context) {
    return _note();
  }

  Widget _note() {
    return widget.isFullScreen
        ? SafeArea(
            child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: CardComponent.standardSideMargin),
            child: Column(children: _titleAndContent()),
          ))
        : CardComponent(
            children: _titleAndContent(),
          );
  }

  List<Widget> _titleAndContent() {
    return [
      Align(
        alignment: Alignment.topLeft,
        child: SpaceColumnComponent(
          heightMultiplier: 0.5,
          child: Text(
            widget.noteMedia.title,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.titleLarge,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      Expanded(
        // Wrap the content in an Expanded widget
        child: Align(
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
            physics: widget.isFullScreen
                ? const AlwaysScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            child: Text(
              widget.noteMedia.content,
              softWrap: true,
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ),
    ];
  }
}
