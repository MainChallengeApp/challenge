import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/providers/reports_provider.dart';
import 'package:challenge/providers/users_provider.dart';
import 'package:challenge/services/dependency_injection_service.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/snack_bar_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:challenge/ui/components/user/bio_component.dart';
import 'package:challenge/ui/components/user/user_picture_min_component.dart';
import 'package:challenge/ui/dialogs/block_user_dialog.dart';
import 'package:challenge/ui/dialogs/report_user_dialog.dart';
import 'package:challenge/ui/dialogs/unblock_user_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserCardComponent extends StatefulWidget {
  final UserModel user;

  const UserCardComponent({super.key, required this.user});

  @override
  State<UserCardComponent> createState() => _UserCardComponentState();
}

class _UserCardComponentState extends State<UserCardComponent> {
  final _usersProvider = getIt<UsersProvider>();
  late UsersProvider _listeningUsersProvider;
  final _reportsProvider = getIt<ReportsProvider>();

  bool _isBioExpanded = false;
  bool _isLoading = false;

  BuildContext? panelContext;

  @override
  Widget build(BuildContext context) {
    _listeningUsersProvider = Provider.of<UsersProvider>(context);
    return CardComponent(
      children: [
        _profilePicture(),
        _usernameAndMore(),
        _bio(),
        _challengesAndConnections(),
        _expandedSpace(),
        _actionButton()
      ],
    );
  }

  _profilePicture() {
    return SpaceColumnComponent(
      child: UserPictureMinComponent(
        userPictureUrl: widget.user.pictureUrl,
      ),
    );
  }

  _usernameAndMore() {
    return SpaceColumnComponent(
      child: Row(
        children: [
          Expanded(
              child: TapContainerComponent(
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.user.username,
                        overflow: TextOverflow.ellipsis,
                      )))),
          const SpaceComponent(),
          TapContainerComponent(
            isQuadratic: true,
            onTap: _onTapMore,
            child: Center(
              child: Icon(
                IconEnum.more.icon,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          )
        ],
      ),
    );
  }

  _onTapMore() async {
    await showCupertinoModalPopup(
      context: context,
      builder: (context) {
        panelContext = context;
        var size = MediaQuery.of(context).size;
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(CardComponent.standardBorderRadius),
              topRight: Radius.circular(CardComponent.standardBorderRadius),
            ),
          ),
          height: size.height * 0.3,
          child: Column(
            children: [
              const SpaceComponent(
                height: 5,
              ),
              SpaceColumnComponent(
                child: Center(
                    child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(24))),
                )),
              ),
              SpaceColumnComponent(
                  child: _usersProvider.user.isBlocked(widget.user.id)
                      ? ListItemIconTextComponent(
                          icon: IconEnum.blockedUsers.icon,
                          title: 'Unblock User',
                          onTap: _onTapUnblock)
                      : ListItemIconTextComponent(
                          icon: IconEnum.blockedUsers.icon,
                          title: 'Block User',
                          onTap: _onTapBlockUser)),
              SpaceColumnComponent(
                  child: ListItemIconTextComponent(
                      onTap: _onTapReport,
                      icon: IconEnum.reportUser.icon,
                      title: 'Report User')),
            ],
          ),
        );
      },
    );
  }

  _bio() {
    if (widget.user.bio == null || widget.user.bio!.isEmpty) {
      return Container();
    }
    BioComponent bioComponent = BioComponent(
      bio: widget.user.bio,
      onTap: () {
        setState(() {
          _isBioExpanded = !_isBioExpanded;
        });
      },
      isBioExpanded: _isBioExpanded,
    );
    return _isBioExpanded
        ? Expanded(
            child: Column(
              children: [
                Expanded(child: bioComponent),
                const SpaceComponent(),
              ],
            ),
          )
        : SpaceColumnComponent(
            child: bioComponent,
          );
  }

  _challengesAndConnections() {
    return Visibility(
      visible: !_isBioExpanded,
      child: SpaceColumnComponent(
        child: Row(
          children: [
            Expanded(
              child: TapContainerComponent(
                onTap: () {},
                child: const Column(
                  children: [
                    Text(
                      '-',
                    ),
                    Text(
                      'Challenges',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
            const SpaceComponent(),
            Expanded(
              child: TapContainerComponent(
                onTap: () {},
                child: const Column(
                  children: [
                    Text(
                      '-',
                    ),
                    Text(
                      'Connections',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _expandedSpace() {
    return _isBioExpanded ? Container() : Expanded(child: Container());
  }

  _actionButton() {
    return _usersProvider.user.isBlocked(widget.user.id)
        ? _unblock()
        : _connect();
  }

  _unblock() {
    return CustomButtonComponent(
      onTap: _onTapUnblock,
      isPrimaryButton: true,
      isLoading: _isLoading,
      text: 'Unblock',
    );
  }

  Future<void> _onTapUnblock() async {
    if (panelContext != null) {
      Navigator.of(panelContext!).pop();
    }
    UnblockUserDialog.show(
        // ignore: use_build_context_synchronously
        context: context,
        user: widget.user,
        onTapYes: () async {
          setState(() {
            _isLoading = true;
          });
          await _usersProvider.unblockUser(widget.user.id);
          setState(() {
            _isLoading = false;
          });
        });
  }

  Future<void> _onTapBlockUser() async {
    if (panelContext != null) {
      Navigator.of(panelContext!).pop();
    }
    BlockUserDialog.show(
        // ignore: use_build_context_synchronously
        context: context,
        user: widget.user,
        onTapYes: () async {
          setState(() {
            _isLoading = true;
          });
          await _usersProvider.blockUser(widget.user.id);
          setState(() {
            _isLoading = false;
          });
        });
  }

  _onTapReport() async {
    if (panelContext != null) {
      Navigator.of(panelContext!).pop();
    }
    ReportUserDialog.show(
        // ignore: use_build_context_synchronously
        context: context,
        user: widget.user,
        onTapYes: (String reason) async {
          await _reportsProvider.createReport(widget.user.id, reason);
          // ignore: use_build_context_synchronously
          SnackBarComponent.showSnackBar('Report sent successfully');
        });
  }

  _connect() {
    return _listeningUsersProvider.openConnectionRequests
                .map((user) => user.id)
                .contains(widget.user.id) ||
            _listeningUsersProvider.user.isConnectedWith(widget.user)
        ? CustomButtonComponent(
            onTap: _onTapDisconnect,
            isPrimaryButton: false,
            isLoading: _isLoading,
            text: widget.user.isConnectedWith(_listeningUsersProvider.user)
                ? 'Disconnect'
                : 'Cancel Request',
          )
        : CustomButtonComponent(
            onTap: _onTapConnect,
            isLoading: _isLoading,
            isPrimaryButton: true,
            text: 'Connect',
          );
  }

  _onTapConnect() async {
    setState(() {
      _isLoading = true;
    });
    await _usersProvider.connectToUser(widget.user.id);
    setState(() {
      _isLoading = false;
    });
  }

  _onTapDisconnect() async {
    setState(() {
      _isLoading = true;
    });
    await _usersProvider.disconnectFromUser(widget.user.id);
    setState(() {
      _isLoading = false;
    });
  }
}
