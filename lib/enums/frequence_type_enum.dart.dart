enum FrequenceTypeEnum {
  time,
  daily,
  weekday;

  // const ChallengeStatus(String status);

  static FrequenceTypeEnum factory(String frequenceType) {
    if (frequenceType == 'daily') {
      return FrequenceTypeEnum.daily;
    } else if (frequenceType == 'weekday') {
      return FrequenceTypeEnum.weekday;
    } else {
      return FrequenceTypeEnum.time;
    }
  }

  String toString2() {
    return toString().split('.')[1];
  }
}
