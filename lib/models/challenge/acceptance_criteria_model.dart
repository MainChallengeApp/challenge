class AcceptanceCriteriaModel {
  double amount;
  String unit;

  AcceptanceCriteriaModel({required this.amount, required this.unit});

  AcceptanceCriteriaModel.empty({this.amount = 1, this.unit = ''});

  static AcceptanceCriteriaModel fromDoc(doc) {
    try {
      return AcceptanceCriteriaModel(amount: doc['amount'], unit: doc['unit']);
    } on Exception {
      rethrow;
    }
  }

  toDoc() {
    return {
      'amount': amount,
      'unit': unit,
    };
  }

  AcceptanceCriteriaModel copy() {
    return AcceptanceCriteriaModel(
      amount: amount,
      unit: unit,
    );
  }
}
