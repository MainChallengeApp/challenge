import 'dart:io';

import 'package:challenge/collections/group_challenges_collection.dart';
import 'package:challenge/collections/users_collection.dart';
import 'package:challenge/enums/media_type_enum.dart';
import 'package:challenge/models/challenge/attempt_model.dart';
import 'package:challenge/models/challenge/group_challenge_model.dart';
import 'package:challenge/models/challenge/media_model.dart';
import 'package:challenge/models/user/user_model.dart';
import 'package:challenge/services/storage_service.dart';
import 'package:challenge/services/time_service.dart';
import 'package:image_picker/image_picker.dart';

class MediaService {
  final storageService = StorageService();

  Future<MediaModel?> openImagePicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      return null;
    }

    MediaModel media = MediaModel(
        type: MediaTypeEnum.image,
        title: TimeService.now().toString().split('.')[0],
        source: pickedFile.path);

    return media;
  }

  Future<MediaModel?> uploadLocalMedia(MediaModel media,
      GroupChallengeModel groupChallenge, String userId) async {
    try {
      String path =
          '${GroupChallengesCollection.collectionName}/${groupChallenge.id}/$userId/${media.title}';

      String imageUrl =
          await storageService.uploadFile(File(media.source), path);

      media.source = imageUrl;

      return media;
    } on Exception {
      rethrow;
    }
  }

  Future<String> uploadLocalThumbnail(
      String groupChallengeId, String url) async {
    try {
      String path =
          '${GroupChallengesCollection.collectionName}/$groupChallengeId/thumbnail';

      String imageUrl = await storageService.uploadFile(File(url), path);

      return imageUrl;
    } on Exception {
      rethrow;
    }
  }

  Future<String?> uploadLocalUserPicture(UserModel user) async {
    if (!user.hasPicture() || !isUrlLocal(user.pictureUrl!)) {
      return user.pictureUrl;
    }
    String path = '${UsersCollection.collectionName}/${user.id}/user_picture';
    try {
      String imageUrl =
          await storageService.uploadFile(File(user.pictureUrl!), path);
      return imageUrl;
    } on Exception {
      rethrow;
    }
  }

  deleteMedia(MediaModel media) {
    File file = File(media.source);
    file.exists().then((value) {
      if (value) {
        file.delete();
      }
    });

    if (isUrlLocal(media.source)) {
      return;
    }

    storageService.deleteFileByUrl(media.source);
  }

  deleteMediaInChallengeByIds(List<String> mediaIds, AttemptModel attempt) {
    for (var mediaId in mediaIds) {
      MediaModel media =
          attempt.media.firstWhere((element) => element.id == mediaId);
      attempt.removeMedia(media);
      deleteMedia(media);
    }
  }

  isUrlLocal(String url) {
    return !url.startsWith('https://');
  }
}
