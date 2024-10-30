import 'package:challenge/collections/migration_collection.dart';
import 'package:challenge/collections/migrations/migration.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersionService {
  static MigrationCollection migrationCollection = MigrationCollection();

  static Future<String> getAppVersionOnDevice() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static Future<String> getLatestNecessaryMigrationAppVersion() async {
    try {
      Migration newestMigration =
          await migrationCollection.getNewestMigration();
      return newestMigration.appVersion;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> isDeviceAppVersionUpToDate() async {
    String appVersionOnDevice = await getAppVersionOnDevice();
    String latestNecessaryMigrationAppVersion =
        await getLatestNecessaryMigrationAppVersion();

    List<String> appVersionOnDeviceParts = appVersionOnDevice.split('.');
    List<String> latestNecessaryMigrationAppVersionParts =
        latestNecessaryMigrationAppVersion.split('.');
    for (int i = 0; i < latestNecessaryMigrationAppVersionParts.length; i++) {
      try {
        int appVersionOnDevicePart = int.parse(appVersionOnDeviceParts[i]);
        int latestNecessaryMigrationAppVersionPart =
            int.parse(latestNecessaryMigrationAppVersionParts[i]);
        if (appVersionOnDevicePart > latestNecessaryMigrationAppVersionPart) {
          return true;
        }
        if (appVersionOnDevicePart < latestNecessaryMigrationAppVersionPart) {
          return false;
        }
      } on FormatException catch (e) {
        throw FormatException(
            'App version parts must be integers [appVersionOnDevice = $appVersionOnDevice] and [latestNecessaryMigrationAppVersion = $latestNecessaryMigrationAppVersion]  Error: ${e.toString()}');
      }
    }

    return true;
  }
}
