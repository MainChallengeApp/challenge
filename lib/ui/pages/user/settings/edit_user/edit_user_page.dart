import 'package:challenge/enums/box_fit_enum.dart';
import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/globals.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_child_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/pages/user/settings/edit_user/edit_bio_page.dart';
import 'package:challenge/ui/pages/user/settings/edit_user/edit_picture_page.dart';
import 'package:challenge/ui/pages/user/settings/edit_user/edit_username_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditUserPage extends StatefulWidget {
  final String preTitle;

  const EditUserPage({
    super.key,
    required this.preTitle,
  });

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  bool isDescriptionExpanded = false;

  late final listeningUsersProvider = Provider.of<UsersProvider>(context);

  late UserModel user;

  bool isLoading = false;

  String title = 'Edit';

  var mediaService = MediaService();

  @override
  Widget build(BuildContext context) {
    user = listeningUsersProvider.user;
    return Scaffold(
      resizeToAvoidBottomInset: isDescriptionExpanded ? true : false,
      appBar: AppBarComponent(preTitle: widget.preTitle, titleText: title),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          SpaceColumnComponent(
            child: ListItemIconChildComponent(
              icon: IconEnum.email.icon,
              onTap: () {},
              child: Row(
                children: [
                  const Text('Email'),
                  const SpaceComponent(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      user.email,
                      style: const TextStyle(color: themeColor3),
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SpaceColumnComponent(
            child: ListItemIconChildComponent(
              icon: IconEnum.password.icon,
              onTap: () {},
              child: const Row(
                children: [
                  Text('Password'),
                  SpaceComponent(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      '******',
                      style: TextStyle(color: themeColor3),
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SpaceComponent(),
          SpaceColumnComponent(
            child: ListItemIconChildComponent(
              icon: IconEnum.picture.icon,
              onTap: onTapPicture,
              child: Row(
                children: [
                  const Text('Picture'),
                  const SpaceComponent(
                    width: 10,
                  ),
                  Expanded(child: Container()),
                  ContainerInContainerComponent(
                      // TODO: merge with ListItemImageChildComponent
                      padding: const EdgeInsets.all(0),
                      margin: const EdgeInsets.all(0),
                      height: ListItemIconTextComponent.iconContainerSize,
                      width: ListItemIconTextComponent.iconContainerSize,
                      borderRadius: const BorderRadius.all(Radius.circular(
                          ListItemIconTextComponent.standardIconRadius)),
                      child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(
                              ListItemIconTextComponent.standardIconRadius)),
                          child: user.pictureUrl == null
                              ? Center(
                                  child: Icon(IconEnum.user.icon,
                                      color: themeColor3),
                                )
                              : mediaService.isUrlLocal(user.pictureUrl!)
                                  ? Image.asset(user.pictureUrl!,
                                      fit: BoxFitEnum.cover.fit,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Center(
                                                child: Icon(IconEnum.user.icon,
                                                    color: themeColor3),
                                              ))
                                  : Image.network(user.pictureUrl!,
                                      fit: BoxFitEnum.cover.fit,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Center(
                                                child: Icon(IconEnum.user.icon,
                                                    color: themeColor3),
                                              )))),
                ],
              ),
            ),
          ),
          SpaceColumnComponent(
            child: ListItemIconChildComponent(
                icon: IconEnum.username.icon,
                onTap: onTapUsername,
                child: Row(
                  children: [
                    const Text('Username'),
                    const SpaceComponent(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        '@${user.username}',
                        style: const TextStyle(color: themeColor3),
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )),
          ),
          SpaceColumnComponent(
            child: ListItemIconChildComponent(
                icon: IconEnum.bio.icon,
                onTap: onTapBio,
                child: Row(
                  children: [
                    const Text('Bio'),
                    const SpaceComponent(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        user.bio?.replaceAll('\n', ' ') ?? '',
                        style: const TextStyle(color: themeColor3),
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }

  void onTapUsername() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) =>
            EditUsernamePage(user: user, preTitle: '${widget.preTitle}/$title'),
      ),
    );
  }

  void onTapBio() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) =>
            EditBioPage(user: user, preTitle: '${widget.preTitle}/$title'),
      ),
    );
  }

  void onTapPicture() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) =>
            EditPicturePage(user: user, preTitle: '${widget.preTitle}/$title'),
      ),
    );
  }
}
