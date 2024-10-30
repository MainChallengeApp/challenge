import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/media_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/card_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/components/user/user_picture_max_component.dart';
import 'package:challenge/ui/pages/user/settings/edit_user/edit_bio_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditPicturePage extends StatefulWidget {
  final UserModel user;
  final String preTitle;
  final bool isRegistration;

  const EditPicturePage({
    super.key,
    required this.user,
    required this.preTitle,
    this.isRegistration = false,
  });

  @override
  State<EditPicturePage> createState() => _EditPicturePageState();
}

class _EditPicturePageState extends State<EditPicturePage> {
  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);

  late UserModel editUser = widget.user.copy();

  bool isLoading = false;

  String title = 'Picture';

  var mediaService = MediaService();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBarComponent(preTitle: widget.preTitle, titleText: title),
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SpaceColumnComponent(
                      child: CustomContainerComponent(
                        borderRadius: CardComponent.standardBorderRadius,
                        isHeightDynamic: true,
                        margin: const EdgeInsets.only(
                          left: ListItemContainerComponent.standardMargin,
                          right: ListItemContainerComponent.standardMargin,
                        ),
                        padding:
                            const EdgeInsets.all(CardComponent.standardPadding),
                        child: UserPictureMaxComponent(
                            userPictureUrl: editUser.pictureUrl),
                      ),
                    ),
                    SpaceColumnComponent(
                      child: ListItemIconTextComponent(
                          onTap: onTapUpload,
                          icon: IconEnum.upload.icon,
                          title: 'Upload'),
                    ),
                    SpaceColumnComponent(
                      child: ListItemIconTextComponent(
                          onTap: onTapRemove,
                          icon: IconEnum.remove.icon,
                          title: 'Remove'),
                    )
                  ],
                ),
              ),
            ),
            SpaceColumnComponent(
              height: 20,
              child: Row(
                children: [
                  Expanded(
                    child: ListItemButtonComponent(
                      onTap: widget.isRegistration ? onTapSkip : onTapCancel,
                      text: widget.isRegistration ? 'Skip' : 'Cancel',
                      isMainButton: false,
                      margin: const EdgeInsets.only(
                          left: ListItemContainerComponent.standardMargin),
                    ),
                  ),
                  const SpaceComponent(
                    width: ListItemContainerComponent.standardMargin,
                  ),
                  Expanded(
                    child: ListItemButtonComponent(
                      margin: const EdgeInsets.only(
                          right: ListItemContainerComponent.standardMargin),
                      onTap: onTapSave,
                      text: 'Save',
                      isLoading: isLoading,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onTapSave() async {
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    editUser.pictureUrl = await mediaService.uploadLocalUserPicture(editUser);

    await usersProvider.update(editUser);

    setState(() {
      isLoading = false;
    });

    if (widget.isRegistration) {
      nextInRegistration();
      return;
    }

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  void onTapCancel() {
    Navigator.pop(context);
  }

  void onTapSkip() {
    nextInRegistration();
  }

  void onTapUpload() async {
    MediaModel? media = await mediaService.openImagePicker();
    if (media == null) {
      return;
    }
    setState(() {
      editUser.pictureUrl = media.source;
    });
  }

  void onTapRemove() {
    setState(() {
      editUser.pictureUrl = null;
    });
  }

  void nextInRegistration() {
    Navigator.push(
        context,
        NoAnimationPageRouteComponent(
            builder: (builder) => EditBioPage(
                  user: editUser,
                  preTitle: 'Registration',
                  isRegistration: true,
                )));
  }
}
