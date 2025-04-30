import 'package:challenge/services/time_service.dart';

class ReminderModel {
  int id;
  static const String idField = 'id';

  int hours;
  static const String hoursField = 'hours';

  int minutes;
  static const String minutesField = 'minutes';

  bool isActive;
  static const String isActiveField = 'isActive';

  ReminderModel(
      {required this.id,
      required this.hours,
      required this.minutes,
      required this.isActive});

  ReminderModel.empty()
      : id = TimeService.now().millisecondsSinceEpoch ~/ 1000,
        hours = TimeService.now().hour,
        minutes = TimeService.now().minute,
        isActive = false;

  factory ReminderModel.fromDoc(doc) {
    try {
      return ReminderModel(
          id: doc[idField],
          hours: doc[hoursField],
          minutes: doc[minutesField],
          isActive: doc[isActiveField]);
    } on Exception {
      rethrow;
    }
  }

  Map<String, dynamic> toDoc() {
    return {
      idField: id,
      hoursField: hours,
      minutesField: minutes,
      isActiveField: isActive,
    };
  }

  ReminderModel copy() {
    return ReminderModel(
      id: id,
      hours: hours,
      minutes: minutes,
      isActive: isActive,
    );
  }

  String timeToString() {
    String hourString = hours.toString().padLeft(2, '0');
    String minuteString = minutes.toString().padLeft(2, '0');
    return isActive ? '$hourString:$minuteString' : 'Off';
  }
}
