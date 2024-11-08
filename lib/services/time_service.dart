import 'package:ntp/ntp.dart';

class TimeService {
  static DateTime now() {
    return DateTime.now().add(trustedOffset);
  }

  static Duration trustedOffset = Duration.zero;

  static void initializeTrustedTime() async {
    DateTime serverTime =
        await NTP.now(); // Get trusted time from server or NTP
    DateTime localTime = DateTime.now(); // Device time at the same moment
    trustedOffset = serverTime.difference(localTime); // Calculate offset
  }
}
