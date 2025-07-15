import 'package:challenge/enums/unit_enum.dart';

class Unit {
  final String singular;
  final String plural;
  final bool isSmart;

  Unit({required this.singular, required this.plural, this.isSmart = false});

  static List<Unit> getUnits() {
    return UnitEnum.getUnits()
        .map((e) =>
            Unit(singular: e.singular, plural: e.plural, isSmart: e.isSmart))
        .toList();
  }
}
