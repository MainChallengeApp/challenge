import 'package:challenge/globals.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:flutter/material.dart';

class EditBioComponent extends StatefulWidget {
  final UserModel user;
  final bool isDescriptionExpanded;
  final void Function()? onTap;

  const EditBioComponent(
      {super.key,
      required this.user,
      this.isDescriptionExpanded = false,
      this.onTap});

  @override
  State<EditBioComponent> createState() => _EditBioComponentState();
}

class _EditBioComponentState extends State<EditBioComponent> {
  late TextStyle commonTextStyle = TextStyle(
    fontSize: basicFontSize,
    color: widget.user.bio == null || widget.user.bio!.isEmpty
        ? Colors.grey[700]
        : Colors.black,
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
                    onChanged: (value) {
                      if (value.isEmpty) {
                        widget.user.bio = null;
                      } else {
                        widget.user.bio = value;
                      }
                    },
                    controller: TextEditingController()
                      ..text = widget.user.bio ?? '',
                    decoration:
                        const InputDecoration.collapsed(hintText: 'Bio'),
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
              overflow: widget.user.bio == null || widget.user.bio!.isEmpty
                  ? null
                  : TextOverflow.ellipsis,
              widget.user.bio == null || widget.user.bio!.isEmpty
                  ? 'Bio'
                  : widget.user.bio!,
              maxLines: 2,
              style: commonTextStyle,
            ));
  }
}
