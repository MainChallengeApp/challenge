import 'package:challenge/models/user/user_model.dart';

import '../../services/faker_service.dart';

UserModel mockUserModel({
  String? id,
  String? username,
  String? bio,
  List<String>? blockedUserIds,
  List<String>? connectedUserIds,
  String? pictureUrl,
}) {
  return UserModel(
    id: id ?? FakerService.guid(),
    username: username ?? FakerService.word(),
    bio: bio ?? FakerService.word(),
    blockedUserIds:
        blockedUserIds ?? FakerService.list((_) => FakerService.guid()),
    connectionIds:
        connectedUserIds ?? FakerService.list((_) => FakerService.guid()),
    pictureUrl: pictureUrl ?? FakerService.url(),
  );
}

void main() {}
