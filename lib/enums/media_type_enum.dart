enum MediaTypeEnum {
  image,
  video,
  text;

  static MediaTypeEnum factory(String type) {
    if (type == 'MediaTypeEnum.image') {
      return MediaTypeEnum.image;
    } else if (type == 'MediaTypeEnum.video') {
      return MediaTypeEnum.video;
    } else if (type == 'MediaTypeEnum.text') {
      return MediaTypeEnum.text;
    } else {
      return MediaTypeEnum.image;
    }
  }
}
