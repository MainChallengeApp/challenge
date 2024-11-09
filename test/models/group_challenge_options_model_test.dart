import 'package:challenge/enums/group_challenge_type_enum.dart';
import 'package:challenge/models/challenge/group_challenge_options_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../services/faker_service.dart';

GroupChallengeOptionsModel mockGroupChallengeOptionsModel({
  GroupChallengeTypeEnum? type,
  bool? isProgressIndividuell,
}) {
  return GroupChallengeOptionsModel(
    type: type ?? FakerService.randomObject(GroupChallengeTypeEnum.values),
    isProgressIndividuell: isProgressIndividuell ?? FakerService.boolean(),
  );
}

void main() {
  group('GroupChallengeOptionsModel', () {
    group('toDoc()', () {
      test('should return document of GroupChallengeOptionsModel', () {
        // arrange
        GroupChallengeOptionsModel groupChallengeOptions =
            mockGroupChallengeOptionsModel();
        // act
        final doc = groupChallengeOptions.toDoc();
        // assert
        expect(doc[GroupChallengeOptionsModel.typeField],
            groupChallengeOptions.type.text);
        expect(doc[GroupChallengeOptionsModel.isProgressIndividuellField],
            groupChallengeOptions.isProgressIndividuell);
      });
    });

    group('fromDoc()', () {
      test('should return group challenge options model from document', () {
        // arrange
        GroupChallengeOptionsModel groupChallengeOptions =
            mockGroupChallengeOptionsModel();
        Map<String, dynamic> doc = groupChallengeOptions.toDoc();
        // act
        final result = GroupChallengeOptionsModel.fromDoc(doc);
        // assert
        expect(result.type.text, groupChallengeOptions.type.text);
        expect(result.isProgressIndividuell,
            groupChallengeOptions.isProgressIndividuell);
      });
    });

    group('copy()', () {
      test('should return copy of group challenge options model', () {
        // arrange
        GroupChallengeOptionsModel groupChallengeOptions =
            mockGroupChallengeOptionsModel();
        // act
        final copy = groupChallengeOptions.copy();
        // assert
        expect(copy.type.text, groupChallengeOptions.type.text);
        expect(copy.isProgressIndividuell,
            groupChallengeOptions.isProgressIndividuell);
      });
    });
  });
}
