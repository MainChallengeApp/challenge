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

  static List<Unit> sortUnits(
      List<Unit> unitsSingularPlural, String editUnit, double editAmount) {
    unitsSingularPlural.sort((a, b) {
      // Function to calculate how well a unit matches the search term
      int matchScore(Unit unit) {
        String unitName = editAmount == 1 ? unit.singular : unit.plural;
        String lowerUnitName = unitName.toLowerCase();
        String lowerEditUnit = editUnit.toLowerCase();

        if (lowerUnitName == lowerEditUnit) return 3; // Exact match
        if (lowerUnitName.startsWith(lowerEditUnit)) return 2; // Starts with
        if (lowerUnitName.contains(lowerEditUnit)) return 1; // Contains
        return 0; // No match
      }

      int aScore = matchScore(a);
      int bScore = matchScore(b);

      if (aScore != bScore) {
        return bScore.compareTo(aScore); // Higher score first
      } else {
        // If scores are equal, sort alphabetically
        String aName = editAmount == 1 ? a.singular : a.plural;
        String bName = editAmount == 1 ? b.singular : b.plural;
        return aName.toLowerCase().compareTo(bName.toLowerCase());
      }
    });
    return unitsSingularPlural;
  }
}
