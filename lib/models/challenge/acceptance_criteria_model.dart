import 'package:challenge/models/challenge/group_challenge_model.dart';

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
          amount: (doc[amountField] as num?)?.toDouble() ?? 0.0,
          unit: doc[unitField]);
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

  double getAmount(GroupChallengeModel groupChallenge) {
    return groupChallenge.groupChallengeOptions.isProgressIndividuell
        ? amount
        : groupChallenge.acceptanceCriteria.amount;
  }
}
