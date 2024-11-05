import 'package:challenge/exceptions/group_challenge_type_is_not_supported_exception.dart';

enum GroupChallengeTypeEnum {
  multiSolos('multiSolos'),
  team('team'),
  multiTeams('multiTeams');

  const GroupChallengeTypeEnum(this.text);

  final String text;

  static GroupChallengeTypeEnum fromString(String category) {
    return GroupChallengeTypeEnum.values.firstWhere((e) => e.text == category,
        orElse: () =>
            throw GroupChallengeTypeIsNotSupportedException(category));
  }
}
