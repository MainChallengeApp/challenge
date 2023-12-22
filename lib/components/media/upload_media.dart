import 'dart:io';

import 'package:image_picker/image_picker.dart';

class UploadMedia {
  File? _image;

//Image Picker function to get image from gallery
  static Future onTapUploadMedia() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
  }
}
