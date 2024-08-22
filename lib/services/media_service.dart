import 'dart:io';

import 'package:challenge/enums/media_type_enum.dart';
import 'package:challenge/models/challenge/media_model.dart';
import 'package:challenge/models/challenge/user_challenge_model.dart';
import 'package:challenge/services/storage_service.dart';
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
        title: DateTime.now().toString().split('.')[0],
        source: pickedFile.path);

    return media;
  }

  Future<MediaModel?> uploadLocalMedia(
      MediaModel media, UserChallengeModel userChallenge) async {
    try {
      String path = 'user_challenges/${userChallenge.id}/${media.title}';

      String imageUrl =
          await storageService.uploadFile(File(media.source), path);

      media.source = imageUrl;

      return media;
    } on Exception {
      rethrow;
    }
  }

  Future<String> uploadLocalThumbnail(UserChallengeModel userChallenge) async {
    try {
      String path = 'user_challenges/${userChallenge.id}/thumbnail';

      String imageUrl = await storageService.uploadFile(
          File(userChallenge.thumbnail.url), path);

      return imageUrl;
    } on Exception {
      rethrow;
    }
  }

  Future<void> uploadMediaList(
      List<MediaModel> mediaList, UserChallengeModel userChallenge) async {
    for (var media in mediaList) {
      MediaModel? mediaWithUrl = await uploadLocalMedia(media, userChallenge);

      if (mediaWithUrl == null) {
        continue;
      }

      MediaModel mediaWithId = MediaModel(
          id: media.id,
          type: media.type,
          title: media.title,
          source: mediaWithUrl.source);
      userChallenge.media.add(mediaWithId);
    }
  }

  deleteMedia(MediaModel media) {
    File file = File(media.source);
    file.exists().then((value) {
      if (value) {
        file.delete();
      }
    });
    storageService.deleteFileByUrl(media.source);
  }

  deleteMediaInChallengeByIds(
      List<String> mediaIds, UserChallengeModel userChallenge) {
    for (var mediaId in mediaIds) {
      MediaModel media =
          userChallenge.media.firstWhere((element) => element.id == mediaId);
      userChallenge.removeMedia(media);
      deleteMedia(media);
    }
  }
}
