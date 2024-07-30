import 'dart:io';

import 'package:challenge/globals.dart';
import 'package:challenge/json_file_controller/challenge_controller.dart';
import 'package:challenge/models/challenge_model.dart';
import 'package:challenge/models/media_model.dart';
import 'package:image_picker/image_picker.dart';

class MediaService {
  ChallengeController challengeController = ChallengeController();

  Future onTapUploadMedia() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
  }

  deleteMedia(MediaModel media, ChallengeModel challenge) {
    File file = File(media.source);
    file.exists().then((value) {
      if (value) {
        file.delete();
      }
    });

    challenge.removeMedia(media);

    allChallengesList
        .map((challengeEntry) =>
            challengeEntry.id == challenge.id ? challenge : challengeEntry)
        .toList();

    challengeController.writeFile(allChallengesList);
  }
}
