enum FrequencyTypeEnum {
  time,
  daily,
  weekday;

  // const ChallengeStatus(String status);

  static FrequencyTypeEnum factory(String frequencyType) {
    if (frequencyType == 'daily') {
      return FrequencyTypeEnum.daily;
    } else if (frequencyType == 'weekday') {
      return FrequencyTypeEnum.weekday;
    } else {
      return FrequencyTypeEnum.time;
    }
  }

  String toString2() {
    return toString().split('.')[1];
  }
}
