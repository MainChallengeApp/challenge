import 'package:flutter_dotenv/flutter_dotenv.dart';

class Dotenv {
  late String environment;

  Dotenv._create(this.environment);

  static Future<Dotenv> create() async {
    await dotenv.load(fileName: '.env');
    String environment = dotenv.env['ENVIRONMENT']!;
    return Dotenv._create(environment);
  }
}
