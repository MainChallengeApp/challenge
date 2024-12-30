import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvVarsService {
  String environment;

  bool useEmulator;

  String migrationUserEmail;

  String migrationUserPassword;

  String localDevMachineIp;

  EnvVarsService._create(
      {required this.environment,
      required this.useEmulator,
      required this.migrationUserEmail,
      required this.migrationUserPassword,
      required this.localDevMachineIp});

  static Future<EnvVarsService> create() async {
    await dotenv.load(fileName: '.env');
    return EnvVarsService._create(
      environment: dotenv.env['ENVIRONMENT'] ??
          const String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev'),
      useEmulator: dotenv.env['USE_EMULATOR'] == 'true',
      migrationUserEmail: dotenv.env['MIGRATION_USER_EMAIL'] ??
          const String.fromEnvironment('MIGRATION_USER_EMAIL',
              defaultValue: ''),
      migrationUserPassword: dotenv.env['MIGRATION_USER_PASSWORD'] ??
          const String.fromEnvironment('MIGRATION_USER_PASSWORD',
              defaultValue: ''),
      localDevMachineIp: dotenv.env['LOCAL_DEV_MACHINE_IP'] ??
          const String.fromEnvironment('LOCAL_DEV_MACHINE_IP',
              defaultValue: 'localhost'),
    );
  }
}
