import 'package:challenge/enums/box_fit_enum.dart';
import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_child_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_text_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/container_in_container_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/pages/user/settings/edit_user/edit_bio_page.dart';
import 'package:challenge/ui/pages/user/settings/edit_user/edit_email_page.dart';
import 'package:challenge/ui/pages/user/settings/edit_user/edit_password_page.dart';
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

  var authService = AuthService();

  String email = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      email = authService.getCurrentUser() != null
          ? authService.getCurrentUser()!.email!
          : 'email not found';
    });
  }

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
            child: ListItemIconTextTextComponent(
              icon: IconEnum.email.icon,
              onTap: onTapEmail,
              text: 'Email',
              text2: email,
            ),
          ),
          SpaceColumnComponent(
            child: ListItemIconTextTextComponent(
              icon: IconEnum.password.icon,
              onTap: onTapPassword,
              text: 'Password',
              text2: '******',
            ),
          ),
          const SpaceComponent(),
          SpaceColumnComponent(
            child: ListItemIconTextChildComponent(
              icon: IconEnum.picture.icon,
              onTap: onTapPicture,
              text: 'Picture',
              child: ContainerInContainerComponent(
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
                                  color:
                                      Theme.of(context).colorScheme.tertiary),
                            )
                          : mediaService.isUrlLocal(user.pictureUrl!)
                              ? Image.asset(user.pictureUrl!,
                                  fit: BoxFitEnum.cover.fit,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Center(
                                        child: Icon(IconEnum.user.icon,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary),
                                      ))
                              : Image.network(user.pictureUrl!,
                                  fit: BoxFitEnum.cover.fit,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Center(
                                        child: Icon(IconEnum.user.icon,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary),
                                      )))),
            ),
          ),
          SpaceColumnComponent(
            child: ListItemIconTextTextComponent(
                icon: IconEnum.username.icon,
                onTap: onTapUsername,
                text: 'Username',
                text2: '@${user.username}'),
          ),
          SpaceColumnComponent(
            child: ListItemIconTextTextComponent(
                icon: IconEnum.bio.icon,
                onTap: onTapBio,
                text: 'Bio',
                text2: user.bio?.replaceAll('\n', ' ') ?? ''),
          ),
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

  void onTapEmail() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) =>
            EditEmailPage(preTitle: '${widget.preTitle}/$title'),
      ),
    ).then((_) {
      authService.getCurrentUser()?.reload().then((_) {
        setState(() {
          email = authService.getCurrentUser() != null
              ? authService.getCurrentUser()!.email!
              : 'email not found';
        });
      }, onError: (error) {
        authService.logout();
      });
    });
  }

  void onTapPassword() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) =>
            EditPasswordPage(preTitle: '${widget.preTitle}/$title'),
      ),
    ).then((_) {
      authService.getCurrentUser()?.reload().catchError((_) {
        authService.logout();
      });
    });
  }
}
