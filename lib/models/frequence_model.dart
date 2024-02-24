import 'package:challenge/enums/frequence_type_enum.dart.dart';

class FrequenceModel {
  int? amount;
  FrequenceTypeEnum type;

  FrequenceModel({this.amount, required this.type});

  static fromJson(json) {
    return FrequenceModel(
        amount: json['amount'], type: FrequenceTypeEnum.factory(json['type']));
  }

  static toJson(FrequenceModel frequenceModel) {
    return '{"amount": ${frequenceModel.amount ?? 0}, "type": "${frequenceModel.type.toString2()}" }';
  }
}
