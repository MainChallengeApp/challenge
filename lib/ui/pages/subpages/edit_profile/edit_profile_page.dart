import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/profile/edit_bio_component.dart';
import 'package:challenge/ui/components/profile/upload_profile_picture_component.dart';
import 'package:challenge/ui/components/profile/user_name_text_field_component.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/custom_card_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;
  final String preTitle;

  const EditProfilePage({
    super.key,
    required this.user,
    required this.preTitle,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool isDescriptionExpanded = false;

  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);

  late UserModel editUser = widget.user.copy();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          resizeToAvoidBottomInset: isDescriptionExpanded ? true : false,
          appBar: AppBarComponent(
              preTitle: widget.preTitle, titleText: 'Edit Profile'),
          backgroundColor: Colors.white,
          body: CardComponent(
            scrollPhysics: const AlwaysScrollableScrollPhysics(),
            children: [
              profilePictureUploadAndUserName(),
              bio(),
              email(),
              password(),
              Visibility(
                  visible: !isDescriptionExpanded,
                  child: Expanded(child: Container())),
              cancelAndSaveButton()
            ],
          ),
          bottomNavigationBar: const BottomNavigationComponent()),
    );
  }

  cancelAndSaveButton() {
    return Visibility(
      visible: !isDescriptionExpanded,
      child: Row(
        children: [
          Expanded(
            child: CustomButtonComponent(
              onTap: onTapCancel,
              text: 'Cancel',
            ),
          ),
          const SpaceComponent(),
          Expanded(
            child: CustomButtonComponent(
              onTap: onTapSave,
              text: 'Save',
              isPrimaryButton: true,
              isLoading: isLoading,
            ),
          )
        ],
      ),
    );
  }

  bio() {
    EditBioComponent bioComponent = EditBioComponent(
      user: editUser,
      isDescriptionExpanded: isDescriptionExpanded,
      onTap: () => setState(() {
        isDescriptionExpanded = !isDescriptionExpanded;
      }),
    );
    return isDescriptionExpanded
        ? Expanded(child: bioComponent)
        : Column(
            children: [
              bioComponent,
              const SpaceComponent(
                heightMultiplier: 2,
              )
            ],
          );
  }

  profilePictureUploadAndUserName() {
    return Column(
      children: [
        Row(
          children: [
            UploadProfilePictureComponent(editUser: editUser),
            const SpaceComponent(),
            UserNameTextFieldComponent(user: editUser)
          ],
        ),
        const SpaceComponent()
      ],
    );
  }

  void onTapCancel() {
    Navigator.pop(context);
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

  email() {
    return Container();
  }

  password() {
    return Container();
  }
}
