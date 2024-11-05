import 'package:challenge/enums/group_challenge_type_enum.dart';

class GroupChallengeOptionsModel {
  GroupChallengeTypeEnum type;
  static const String typeField = 'type';

  bool isProgressIndividuell;
  static const String isProgressIndividuellField = 'isProgressIndividuell';

  GroupChallengeOptionsModel({
    this.type = GroupChallengeTypeEnum.multiSolos,
    this.isProgressIndividuell = false,
  });

  Map<String, dynamic> toDoc() {
    return {
      typeField: type.text,
      isProgressIndividuellField: isProgressIndividuell,
    };
  }

  static GroupChallengeOptionsModel fromDoc(Map<String, dynamic> doc) {
    return GroupChallengeOptionsModel(
        type: GroupChallengeTypeEnum.fromString(doc[typeField]),
        isProgressIndividuell: doc[isProgressIndividuellField] ?? false);
  }

  GroupChallengeOptionsModel copy(
      {bool isTryAgain = false, bool withId = false}) {
    return GroupChallengeOptionsModel(type: type);
  }
}
