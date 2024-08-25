class AcceptanceCriteriaModel {
  double amount;
  static const String amountField = 'amount';

  String unit;
  static const String unitField = 'unit';

  AcceptanceCriteriaModel({required this.amount, required this.unit});

  AcceptanceCriteriaModel.empty({this.amount = 1, this.unit = ''});

  static AcceptanceCriteriaModel fromDoc(doc) {
    try {
      return AcceptanceCriteriaModel(
          amount: doc[amountField], unit: doc[unitField]);
    } on Exception {
      rethrow;
    }
  }

  toDoc() {
    return {
      amountField: amount,
      unitField: unit,
    };
  }

  AcceptanceCriteriaModel copy() {
    return AcceptanceCriteriaModel(
      amount: amount,
      unit: unit,
    );
  }
}
