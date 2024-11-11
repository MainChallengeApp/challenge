import 'package:faker/faker.dart';

class FakerService {
  static Faker faker = Faker();

  static String guid() {
    return faker.guid.guid();
  }

  static double decimal({num min = 0}) {
    return faker.randomGenerator.decimal(min: min);
  }

  static bool boolean() {
    return faker.randomGenerator.boolean();
  }

  static int integer({int min = 0, int max = 1000}) {
    return faker.randomGenerator.integer(max, min: min);
  }

  static String word() {
    return faker.lorem.word();
  }

  static String url() {
    return faker.internet.httpsUrl();
  }

  static T randomObject<T>(List<T> list) {
    return faker.randomGenerator.element(list);
  }

  static DateTime dateTime() {
    return faker.date.dateTime(maxYear: 2500, minYear: 2000);
  }

  static List<T> list<T>(T Function(int) function,
      {int max = 20, int min = 0}) {
    return List.generate(
        integer(max: max, min: min), (index) => function.call(index));
  }
}
