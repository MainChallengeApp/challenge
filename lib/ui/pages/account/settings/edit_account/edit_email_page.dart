import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditEmailPage extends StatefulWidget {
  final UserModel user;
  final String preTitle;

  const EditEmailPage({
    super.key,
    required this.user,
    required this.preTitle,
  });

  @override
  State<EditEmailPage> createState() => _EditEmailPageState();
}

class _EditEmailPageState extends State<EditEmailPage> {
  bool isDescriptionExpanded = false;

  late final usersProvider = Provider.of<UsersProvider>(context, listen: false);

  late UserModel editUser = widget.user.copy();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: isDescriptionExpanded ? true : false,
      appBar: AppBarComponent(preTitle: widget.preTitle, titleText: 'Edit'),
      backgroundColor: Colors.white,
      body: Container(),
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
}
