import 'package:image_picker/image_picker.dart';

class UploadMediaService {
  static Future onTapUploadMedia() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
  }
}
