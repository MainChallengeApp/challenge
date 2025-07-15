import 'package:challenge/services/util_service.dart';

enum UnitEnum {
  centimeter(plural: 'Centimeters', singular: 'Centimeter', isSmart: false),
  entry(plural: 'Entries', singular: 'Entry', isSmart: true),
  gram(plural: 'Grams', singular: 'Gram', isSmart: false),
  hour(plural: 'Hours', singular: 'Hour', isSmart: true),
  image(plural: 'Images', singular: 'Image', isSmart: true),
  kilogram(plural: 'Kilograms', singular: 'Kilogram', isSmart: false),
  kilometer(plural: 'Kilometers', singular: 'Kilometer', isSmart: false),
  liter(plural: 'Liters', singular: 'Liter', isSmart: false),
  meter(plural: 'Meters', singular: 'Meter', isSmart: false),
  milliliter(plural: 'Milliliters', singular: 'Milliliter', isSmart: false),
  note(plural: 'Notes', singular: 'Note', isSmart: true),
  minute(plural: 'Minutes', singular: 'Minute', isSmart: true),
  piece(plural: 'Pieces', singular: 'Piece', isSmart: false),
  point(plural: 'Points', singular: 'Point', isSmart: false);

  final String plural;
  final String singular;
  final bool isSmart;

  const UnitEnum(
      {required this.singular, required this.plural, required this.isSmart});

  static List<UnitEnum> getUnits() {
    return UnitEnum.values;
  }

  static UnitEnum? getUnit(String unit) {
    var singular = UtilService.firstWhereOrNull(
        UnitEnum.values, (e) => e.singular == unit);
    var plural =
        UtilService.firstWhereOrNull(UnitEnum.values, (e) => e.plural == unit);

    return singular ?? plural;
  }
}
