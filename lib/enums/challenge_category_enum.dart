import 'package:challenge/exceptions/challenge_category_is_not_supported_exception.dart';

enum ChallengeCategoryEnum {
  physicalHealth('physicalHealth'),
  mentalHealth('mentalHealth'),
  social('social'),
  other('other');

  const ChallengeCategoryEnum(this.category);

  final String category;

  static ChallengeCategoryEnum fromString(String category) {
    return ChallengeCategoryEnum.values.firstWhere(
        (e) => e.category == category,
        orElse: () => throw ChallengeCategoryIsNotSupportedException(category));
  }

  static List<ChallengeCategoryEnum> fromDocs(List docs) {
    List<ChallengeCategoryEnum> list = [];
    for (var doc in docs) {
      list.add(fromString(doc));
    }
    return list;
  }

  static List<String> toDocs(List<ChallengeCategoryEnum> categories) {
    return categories.map((category) => category.category).toList();
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
