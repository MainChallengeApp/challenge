import 'dart:io';

import 'package:challenge/models/challenge/media_model.dart';
import 'package:image_picker/image_picker.dart';

class MediaService {
  Future onTapUploadMedia() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
  }

  deleteMedia(MediaModel media) {
    File file = File(media.source);
    file.exists().then((value) {
      if (value) {
        file.delete();
      }
    });
  }
}
