class AcceptanceCriteriaModel {
  double amount;
  String unit;

  AcceptanceCriteriaModel({required this.amount, required this.unit});

  AcceptanceCriteriaModel.empty({this.amount = 1, this.unit = ""});

  static AcceptanceCriteriaModel fromJson(json) {
    return AcceptanceCriteriaModel(amount: json['amount'], unit: json['unit']);
  }

  static toJson(AcceptanceCriteriaModel acceptanceCriteria) {
    return {
      'amount': acceptanceCriteria.amount,
      'unit': acceptanceCriteria.unit,
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
