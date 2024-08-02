class AcceptanceCriteriaModel {
  double amount;
  String unit;

  AcceptanceCriteriaModel({required this.amount, required this.unit});

  AcceptanceCriteriaModel.empty({this.amount = 1, this.unit = ''});

  static AcceptanceCriteriaModel fromJson(json) {
    try {
      return AcceptanceCriteriaModel(
          amount: json['amount'], unit: json['unit']);
    } on Exception {
      rethrow;
    }
  }

  toJson() {
    return {
      'amount': amount,
      'unit': unit,
    };
  }

  static AcceptanceCriteriaModel copyAcceptanceCriteria(
      AcceptanceCriteriaModel ac,
      {bool isTryAgain = false}) {
    return AcceptanceCriteriaModel(
      amount: ac.amount,
      unit: ac.unit,
    );
  }
}
