enum ChallengeCategoryEnum {
  knowledge,
  fitness,
  mentalHealth,
  social,
  work,
  other;

  // const ChallengeStatus(String status);

  static ChallengeCategoryEnum factory(String status) {
    if (status == 'knowledge') {
      return ChallengeCategoryEnum.knowledge;
    } else if (status == 'fitness') {
      return ChallengeCategoryEnum.fitness;
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
}
