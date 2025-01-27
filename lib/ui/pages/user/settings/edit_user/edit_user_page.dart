import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/tab_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/auth_service.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_child_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_text_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/simple_components/image_in_list_item_component.dart';
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
  const EditUserPage({
    super.key,
  });

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  late final _listeningUsersProvider = Provider.of<UsersProvider>(context);
  final _tabProvider = getIt<TabProvider>();

  late UserModel _user;

  final String _title = 'Edit User';

  final _authService = AuthService();

  late String _email = _authService.getCurrentUser() != null
      ? _authService.getCurrentUser()!.email!
      : 'Email not found';
  @override
  Widget build(BuildContext context) {
    _user = _listeningUsersProvider.user;
    return ScaffoldComponent(
      appBar: AppBarComponent(title: _title),
      body: ListView(
        children: [
          SpaceColumnComponent(
            child: ListItemIconTextTextComponent(
              icon: IconEnum.email.icon,
              onTap: _onTapEmail,
              text: 'Email',
              text2: _email,
            ),
          ),
          SpaceColumnComponent(
            child: ListItemIconTextTextComponent(
              icon: IconEnum.password.icon,
              onTap: _onTapPassword,
              text: 'Password',
              text2: '******',
            ),
          ),
          const SpaceComponent(),
          SpaceColumnComponent(
              child: ListItemIconTextChildComponent(
            icon: IconEnum.picture.icon,
            onTap: _onTapPicture,
            text: 'Picture',
            child: ImageInListItemComponent(
              url: _user.pictureUrl,
              icon: IconEnum.user.icon,
            ),
          )),
          SpaceColumnComponent(
            child: ListItemIconTextTextComponent(
                icon: IconEnum.username.icon,
                onTap: _onTapUsername,
                text: 'Username',
                text2: _user.username),
          ),
          SpaceColumnComponent(
            child: ListItemIconTextTextComponent(
                icon: IconEnum.bio.icon,
                onTap: _onTapBio,
                text: 'Bio',
                text2: _user.bio ?? ''),
          ),
        ],
      ),
    );
  }

  void _onTapUsername() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUsernamePage(user: _user),
      ),
    ).then((_) {
      _tabProvider.setBottomNavigationVisibility(true);
    });
  }

  void _onTapBio() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBioPage(user: _user),
      ),
    ).then((_) {
      _tabProvider.setBottomNavigationVisibility(true);
    });
  }

  void _onTapPicture() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPicturePage(user: _user),
      ),
    ).then((_) {
      _tabProvider.setBottomNavigationVisibility(true);
    });
  }

  void _onTapEmail() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditEmailPage(),
      ),
    ).then((_) {
      _tabProvider.setBottomNavigationVisibility(true);
      _authService.getCurrentUser()?.reload().then((_) {
        setState(() {
          _email = _authService.getCurrentUser() != null
              ? _authService.getCurrentUser()!.email!
              : 'Email not found';
        });
      }, onError: (error) {
        _authService.logout();
      });
    });
  }

  void _onTapPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditPasswordPage(),
      ),
    ).then((_) {
      _tabProvider.setBottomNavigationVisibility(true);
      _authService.getCurrentUser()?.reload().catchError((_) {
        _authService.logout();
      });
    });
  }
}
