import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/challenge/challenge_total_percentage_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/list_items/list_item_image_child_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListItemChallengeSmallComponent extends StatefulWidget {
  const ListItemChallengeSmallComponent({
    super.key,
    required this.onTap,
    required this.challenge,
    this.isSearch = false,
    this.onTapDeleteChallenge,
  });

  final dynamic Function() onTap;
  final ChallengeModel challenge;
  final bool isSearch;
  final void Function()? onTapDeleteChallenge;

  @override
  State<ListItemChallengeSmallComponent> createState() =>
      _ListItemChallengeSmallComponentState();
}

class _ListItemChallengeSmallComponentState
    extends State<ListItemChallengeSmallComponent> {
  final mediaService = MediaService();

  @override
  Widget build(BuildContext context) {
    return ListItemImageChildComponent(
        url: widget.challenge.thumbnail?.url,
        endActionPane: endActionPane,
        onTap: widget.onTap,
        scale: widget.challenge.thumbnail?.scale,
        fit: widget.challenge.thumbnail?.fit.fit,
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.challenge.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            // progressRecurring(),
            percentageDone()
            // progressCircle()
          ],
        ));
  }

  Container miniThumbnail() {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.themeColor4,
          borderRadius: const BorderRadius.all(
              Radius.circular(ListItemIconTextComponent.standardIconRadius))),
      width: ListItemIconTextComponent.iconContainerSize,
      height: ListItemIconTextComponent.iconContainerSize,
      margin: const EdgeInsets.only(right: 12),
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: widget.challenge.hasThumbnail()
              ? mediaService.isUrlLocal(widget.challenge.thumbnail!.url)
                  ? Transform.scale(
                      scale: widget.challenge.thumbnail!.scale,
                      child: Image.asset(
                        widget.challenge.thumbnail!.url,
                        fit: widget.challenge.thumbnail!.fit.fit,
                      ),
                    )
                  : Transform.scale(
                      scale: widget.challenge.thumbnail!.scale,
                      child: Image.network(
                        widget.challenge.thumbnail!.url,
                        fit: widget.challenge.thumbnail!.fit.fit,
                      ),
                    )
              : Center(
                  child: Icon(Icons.question_mark,
                      color: Theme.of(context).colorScheme.tertiary),
                )),
    );
  }

  percentageDone() {
    return ChallengeTotalPercentageComponent(
      padding: const EdgeInsets.all(7),
      challenge: widget.challenge,
      isVisible: !widget.isSearch && !widget.challenge.isInBacklog(),
    );
  }

  ActionPane? endActionPane(Function closeSlidable) {
    return widget.isSearch
        ? null
        : ActionPane(
            extentRatio: 0.22,
            motion: const ScrollMotion(),
            // dismissible: DismissiblePane(
            //   onDismissed: () {
            //     log('delete');
            //   },
            // ),
            children: [
                deleteSlider(closeSlidable),
                const SpaceComponent(
                  width: 20,
                )
              ]);
  }

  deleteSlider(Function closeSlidable) {
    return Expanded(
      child: TapContainerComponent(
        height: double.infinity,
        borderRadius: 24,
        onTap: () async {
          await closeSlidable();
          widget.onTapDeleteChallenge?.call();
        },
        child: Center(
            child: Icon(
          IconEnum.delete.icon,
          color: Theme.of(context).colorScheme.red,
        )),
      ),
    );
  }
}
