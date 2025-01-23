class Unit {
  final String singular;
  final String plural;

  Unit({required this.singular, required this.plural});

  static getUnits() {
    return [
      Unit(singular: 'Piece', plural: 'Pieces'),
      Unit(singular: 'Point', plural: 'Points'),
      Unit(singular: 'Hour', plural: 'Hours'),
      Unit(singular: 'Minute', plural: 'Minutes'),
      Unit(singular: 'Kilogram', plural: 'Kilograms'),
      Unit(singular: 'Gram', plural: 'Grams'),
      Unit(singular: 'Liter', plural: 'Liters'),
      Unit(singular: 'Milliliter', plural: 'Milliliters'),
      Unit(singular: 'Kilometer', plural: 'Kilometers'),
      Unit(singular: 'Meter', plural: 'Meters'),
      Unit(singular: 'Centimeter', plural: 'Centimeters'),
    ];
  }
}
