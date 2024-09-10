import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/simple_components/custom_button_component.dart';
import 'package:challenge/ui/components/simple_components/custom_card_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:challenge/ui/components/simple_components/tap_container_component.dart';
import 'package:challenge/ui/components/simple_components/title_component.dart';
import 'package:challenge/ui/components/user/bio_component.dart';
import 'package:challenge/ui/components/user/user_picture_min_component.dart';
import 'package:flutter/material.dart';

class SearchUserPage extends StatefulWidget {
  const SearchUserPage(
      {super.key,
      required this.title,
      required this.users,
      required this.initUserIndex});
  final String title;
  final List<UserModel> users;
  final int initUserIndex;

  @override
  State<SearchUserPage> createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  bool isBioExpanded = false;
  late PageController pageController =
      PageController(initialPage: widget.initUserIndex);

  bool isKeyboardUp = false;

  late int currentUserIndex = widget.initUserIndex;

  final mediaService = MediaService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (var user in widget.users) {
      if (!user.hasPicture() || mediaService.isUrlLocal(user.pictureUrl!)) {
        continue;
      }
      precacheImage(NetworkImage(user.pictureUrl!), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarComponent(preTitle: widget.title),
      backgroundColor: Colors.white,
      body: Center(
        child: PageView(
            controller: pageController,
            onPageChanged: onPageChanged,
            scrollDirection: Axis.vertical,
            children: widget.users.map(
              (user) {
                return Builder(builder: (context) {
                  return CardComponent(
                    scrollPhysics: isKeyboardUp
                        ? const AlwaysScrollableScrollPhysics()
                        : widget.users.length == 1
                            ? const AlwaysScrollableScrollPhysics()
                            : const NeverScrollableScrollPhysics(),
                    children: [
                      pictureAndUsername(user),
                      bio(user),
                      challengesAndConnections(user),
                      expandedSpace(),
                      connect(user)
                    ],
                  );
                });
              },
            ).toList()),
      ),
      bottomNavigationBar: const BottomNavigationComponent(),
    );
  }

  void onPageChanged(int value) {
    setState(() {
      currentUserIndex = value;
      pageController = PageController(initialPage: value);
      isBioExpanded = false;
    });
  }

  bio(UserModel user) {
    BioComponent bioComponent = BioComponent(
      bio: user.bio,
      onTap: () {
        setState(() {
          isBioExpanded = !isBioExpanded;
        });
      },
      isBioExpanded: isBioExpanded,
    );
    return isBioExpanded
        ? Expanded(
            child: Column(
              children: [
                Expanded(child: bioComponent),
                const SpaceComponent(),
              ],
            ),
          )
        : user.bio != null && user.bio!.isNotEmpty
            ? SpaceColumnComponent(
                heightMultiplier: 2,
                child: bioComponent,
              )
            : Container();
  }

  challengesAndConnections(UserModel user) {
    return Visibility(
      visible: !isBioExpanded,
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
                      style: TextStyle(fontSize: 9),
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
                      style: TextStyle(fontSize: 9),
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

  connect(UserModel user) {
    return CustomButtonComponent(
      onTap: onTapConnect,
      isPrimaryButton: true,
      text: 'Connect',
    );
  }

  userName(UserModel user) {
    return SpaceColumnComponent(
      height: 11,
      child: TitleComponent(title: '@${user.username}'),
    );
  }

  expandedSpace() {
    return isBioExpanded ? Container() : Expanded(child: Container());
  }

  pictureAndUsername(UserModel user) {
    return SpaceColumnComponent(
      child: Row(
        children: [
          UserPictureMinComponent(
            userPictureUrl: user.pictureUrl,
            onTap: onTapPicture,
          ),
          const SpaceComponent(),
          Expanded(
              child: TapContainerComponent(
                  onTap: onTapUsername,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '@${user.username}',
                        overflow: TextOverflow.ellipsis,
                      )))),
        ],
      ),
    );
  }

  onTapPicture() {
    print('onTapPicture');
    // Navigator.push(
    //     context,
    //     NoAnimationPageRouteComponent(
    //       builder: (context) => EditPicturePage(
    //         preTitle: widget.title,
    //         user: user,
    //       ),
    //     ));
  }

  onTapUsername() {
    print('onTapUsername');
    // Navigator.push(
    //     context,
    //     NoAnimationPageRouteComponent(
    //       builder: (context) => EditUsernamePage(
    //         preTitle: widget.title,
    //         user: user,
    //       ),
    //     ));
  }

  onTapConnect() {
    print('onTapConnect');
  }
}
