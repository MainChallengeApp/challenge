import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/no_animation_page_route_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/pages/account/settings/edit_account/edit_username_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditAccountPage extends StatefulWidget {
  final UserModel user;
  final String preTitle;

  const EditAccountPage({
    super.key,
    required this.user,
    required this.preTitle,
  });

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  bool isDescriptionExpanded = false;

  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);

  late UserModel editUser = widget.user.copy();

  bool isLoading = false;

  String title = 'Edit';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: isDescriptionExpanded ? true : false,
      appBar: AppBarComponent(preTitle: widget.preTitle, titleText: title),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          SpaceColumnComponent(
            child: ListItemIconTextComponent(
              icon: IconEnum.email.icon,
              title: 'Email',
              onTap: () {},
            ),
          ),
          SpaceColumnComponent(
            child: ListItemIconTextComponent(
              icon: IconEnum.password.icon,
              title: 'Password',
              onTap: () {},
            ),
          ),
          const SpaceComponent(),
          SpaceColumnComponent(
            child: ListItemIconTextComponent(
              icon: IconEnum.picture.icon,
              title: 'Picture',
              onTap: () {},
            ),
          ),
          SpaceColumnComponent(
            child: ListItemIconTextComponent(
              icon: IconEnum.username.icon,
              title: 'Username',
              onTap: onTapUsername,
            ),
          ),
          SpaceColumnComponent(
            child: ListItemIconTextComponent(
              icon: IconEnum.bio.icon,
              title: 'Bio',
              onTap: () {},
            ),
          )
        ],
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

    await usersProvider.update(editUser);

    setState(() {
      isLoading = false;
    });
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  void onTapUsername() {
    Navigator.push(
      context,
      NoAnimationPageRouteComponent(
        builder: (context) => EditUsernamePage(
            user: widget.user, preTitle: '${widget.preTitle}/$title'),
      ),
    );
  }
}
