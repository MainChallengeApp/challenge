enum ChallengeCategoryEnum {
  physicalHealth('physicalHealth'),
  mentalHealth('mentalHealth'),
  social('social'),
  other('other');

  const ChallengeCategoryEnum(this.value);

  final String value;

  static ChallengeCategoryEnum factory(String status) {
    return ChallengeCategoryEnum.values.firstWhere((e) => e.value == status,
        orElse: () =>
            throw Exception('Invalid ChallengeCategoryEnum value: $status'));
  }

  static List<ChallengeCategoryEnum> fromJsonList(List json) {
    List<ChallengeCategoryEnum> list = [];
    for (var item in json) {
      list.add(factory(item));
    }
    return list;
  }

  static List<String> toJsonList(List<ChallengeCategoryEnum> list) {
    List<String> jsonList = [];
    for (var item in list) {
      jsonList.add(item.value);
    }
    return jsonList;
  }

  static List<ChallengeCategoryEnum> copyCategoryList(
      List<ChallengeCategoryEnum> list) {
    List<ChallengeCategoryEnum> newList = [];
    for (var item in list) {
      newList.add(item);
    }
    return newList;
  }
}
