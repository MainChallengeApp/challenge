import 'package:challenge/globals.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
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
  late TextStyle commonTextStyle = TextStyle(
    fontSize: basicFontSize,
    color:
        widget.challenge.description.isEmpty ? Colors.grey[700] : Colors.black,
  );

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
                    autofocus: true,
                    maxLines: null,
                    style: const TextStyle(
                      fontSize: basicFontSize,
                    ),
                    onChanged: (value) => widget.challenge.description = value,
                    controller: TextEditingController()
                      ..text = widget.challenge.description,
                    decoration: const InputDecoration.collapsed(
                        hintText: 'Description'),
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                const Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'show less',
                      style: TextStyle(
                          fontSize: basicFontSize, color: themeColor3),
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
              style: commonTextStyle,
            ));
  }
}
