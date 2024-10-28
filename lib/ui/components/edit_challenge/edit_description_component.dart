import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/services/database_service.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:challenge/ui/themes/theme_constants.dart';
import 'package:flutter/material.dart';

class EditDescriptionComponent extends StatefulWidget {
  final ChallengeModel challenge;
  final bool isDescriptionExpanded;
  final void Function()? onTap;

  const EditDescriptionComponent(
      {super.key,
      required this.challenge,
      this.isDescriptionExpanded = false,
      this.onTap});

  @override
  State<EditDescriptionComponent> createState() =>
      _EditDescriptionComponentState();
}

class _EditDescriptionComponentState extends State<EditDescriptionComponent> {
  late final TextEditingController textEditingController =
      TextEditingController(text: widget.challenge.description);

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.only(
        left: CustomContainerComponent.standardPadding,
        right: CustomContainerComponent.standardPadding,
        top: CustomContainerComponent.standardPadding - 2,
        bottom: CustomContainerComponent.standardPadding - 2);

    return widget.isDescriptionExpanded
        ? TapContainerComponent(
            height: double.infinity,
            onTap: widget.onTap,
            padding: padding,
            child: Column(
              children: [
                Expanded(
                  child: TextField(
                    maxLength: DatabaseService.maxCharactersLong,
                    buildCounter: (_,
                            {required currentLength,
                            required isFocused,
                            required maxLength}) =>
                        null,
                    autofocus: true,
                    maxLines: null,
                    style: Theme.of(context).textTheme.textInputSmall,
                    onChanged: (value) => widget.challenge.description = value,
                    controller: textEditingController,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Description',
                      hintStyle: Theme.of(context).textTheme.textInputHintSmall,
                    ),
                    keyboardType: TextInputType.multiline,
                    onSubmitted: (value) {
                      textEditingController.text = value.trim();
                      widget.challenge.description = value.trim();
                    },
                    onTapOutside: (_) {
                      textEditingController.text =
                          textEditingController.text.trim();
                      widget.challenge.description =
                          textEditingController.text.trim();
                    },
                  ),
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'show less',
                      style: Theme.of(context).textTheme.textInputHintSmall,
                    ))
              ],
            ),
          )
        : TapContainerComponent(
            onTap: widget.onTap,
            padding: padding,
            child: Text(
              overflow: widget.challenge.description.isEmpty
                  ? null
                  : TextOverflow.ellipsis,
              widget.challenge.description.isEmpty
                  ? 'Description'
                  : widget.challenge.description,
              maxLines: 2,
              style: widget.challenge.description.isEmpty
                  ? Theme.of(context).textTheme.textInputHintSmall
                  : Theme.of(context).textTheme.textInputSmall,
            ));
  }
}
