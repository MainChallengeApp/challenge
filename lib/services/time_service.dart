import 'package:ntp/ntp.dart';

class TimeService {
  static Future<DateTime> now() async {
    DateTime ntpTime = await NTP.now();
    return ntpTime;
  }
}
