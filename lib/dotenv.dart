import 'package:flutter_dotenv/flutter_dotenv.dart';

class Dotenv {
  String environment;

  String migrationUserEmail;

  String migrationUserPassword;

  Dotenv._create(
      {required this.environment,
      required this.migrationUserEmail,
      required this.migrationUserPassword});

  static Future<Dotenv> create() async {
    await dotenv.load(fileName: '.env');
    return Dotenv._create(
        environment: dotenv.env['ENVIRONMENT']!,
        migrationUserEmail: dotenv.env['MIGRATION_USER_EMAIL']!,
        migrationUserPassword: dotenv.env['MIGRATION_USER_PASSWORD']!);
  }
}
