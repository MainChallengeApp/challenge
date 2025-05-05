import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/media/image_media_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/simple_components/custom_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/components/user/user_picture_max_component.dart';
import 'package:challenge/ui/pages/user/settings/edit_user/edit_bio_page.dart';
import 'package:flutter/material.dart';

class EditPicturePage extends StatefulWidget {
  final UserModel user;
  final bool isRegistration;

  const EditPicturePage({
    super.key,
    required this.user,
    this.isRegistration = false,
  });

  @override
  State<EditPicturePage> createState() => _EditPicturePageState();
}

class _EditPicturePageState extends State<EditPicturePage> {
  final _usersProvider = getIt<UsersProvider>();

  late final UserModel _editUser = widget.user.copy();

  bool _isLoading = false;

  final _mediaService = MediaService();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ScaffoldComponent(
        appBar: const AppBarComponent(title: 'Edit Picture'),
        isBottomNavigationVisible: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                          userPictureUrl: _editUser.pictureUrl),
                    ),
                  ),
                  SpaceColumnComponent(
                    child: ListItemIconTextComponent(
                        onTap: _onTapUpload,
                        icon: IconEnum.upload.icon,
                        title: 'Upload'),
                  ),
                  SpaceColumnComponent(
                    child: ListItemIconTextComponent(
                        onTap: _onTapRemove,
                        icon: IconEnum.remove.icon,
                        title: 'Remove'),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: BottomNavigationComponent.standardMargin,
              ),
              child: SpaceColumnComponent(
                height: BottomNavigationComponent.standardMargin,
                child: Row(
                  children: [
                    Expanded(
                      child: ListItemButtonComponent(
                        onTap:
                            widget.isRegistration ? _onTapSkip : _onTapCancel,
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
                        onTap: _onTapSave,
                        text: 'Save',
                        isLoading: _isLoading,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTapSave() async {
    if (_isLoading) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    _editUser.pictureUrl =
        await _mediaService.uploadLocalUserPicture(_editUser);

    await _usersProvider.update(_editUser);

    setState(() {
      _isLoading = false;
    });

    if (widget.isRegistration) {
      _nextInRegistration();
      return;
    }

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  void _onTapCancel() {
    Navigator.pop(context);
  }

  void _onTapSkip() {
    _nextInRegistration();
  }

  void _onTapUpload() async {
    ImageMediaModel? imageMedia = await _mediaService.openImagePicker(context);
    if (imageMedia == null) {
      return;
    }
    setState(() {
      _editUser.pictureUrl = imageMedia.source;
    });
  }

  void _onTapRemove() {
    setState(() {
      _editUser.pictureUrl = null;
    });
  }

  void _nextInRegistration() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) => EditBioPage(
                  user: _editUser,
                  isRegistration: true,
                )));
  }
}
