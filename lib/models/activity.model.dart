class ActivityModel {
  String title;
  double amount;
  String unit;

  ActivityModel(
      {required this.title, required this.amount, required this.unit});

  static fromJson(json) => ActivityModel(
      title: json['title'], amount: json['amount'], unit: json['unit']);

  static toJson(ActivityModel activity) {
    return {
      'title': activity.title,
      'amount': activity.amount,
      'unit': activity.unit
    };
  }

  static copyActivity(ActivityModel activity) {
    return ActivityModel(
        title: activity.title, amount: activity.amount, unit: activity.unit);
  }
}
