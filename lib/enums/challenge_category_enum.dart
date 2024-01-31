enum ChallengeCategoryEnum {
  knowledge,
  physicalHealth,
  mentalHealth,
  social,
  work,
  other;

  // const ChallengeStatus(String status);

  static ChallengeCategoryEnum factory(String status) {
    if (status == 'knowledge') {
      return ChallengeCategoryEnum.knowledge;
    } else if (status == 'physicalHealth') {
      return ChallengeCategoryEnum.physicalHealth;
    } else if (status == 'mentalHealth') {
      return ChallengeCategoryEnum.mentalHealth;
    } else if (status == 'social') {
      return ChallengeCategoryEnum.social;
    } else if (status == 'work') {
      return ChallengeCategoryEnum.work;
    } else {
      return ChallengeCategoryEnum.other;
    }
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
      jsonList.add(item.toString());
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
