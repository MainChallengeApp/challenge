class Media {
  int id;
  String type;
  String title;
  String source;

  Media(
      {required this.id,
      required this.type,
      required this.title,
      required this.source});

  static fromJsonList(json) {
    List<Media> list = [];
    json?.forEach((e) => list.add(Media(
        type: e['type'], title: e['title'], source: e['source'], id: e['id'])));
    return list;
  }

  static toJsonList(List<Media> media) {
    return media
        .map((e) =>
            {'id': e.id, 'type': e.type, 'title': e.title, 'source': e.source})
        .toList();
  }

  static copyMediaIdList(List<int> mediaIdList) {
    List<int> mediaIdListCopy = [];
    for (var id in mediaIdList) {
      mediaIdListCopy.add(id);
    }
    return mediaIdListCopy;
  }

  static copyMediaList(List<Media> mediaList) {
    List<Media> mediaListCopy = [];
    for (var media in mediaList) {
      mediaListCopy.add(Media(
          id: media.id,
          type: media.type,
          title: media.title,
          source: media.source));
    }
  }
}
