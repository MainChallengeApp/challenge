class Activity {
  String title;
  double amount;
  String unit;

  Activity({required this.title, required this.amount, required this.unit});

  static fromJson(json) => Activity(
      title: json['title'], amount: json['amount'], unit: json['unit']);

  static toJson(Activity activity) {
    return {
      'title': activity.title,
      'amount': activity.amount,
      'unit': activity.unit
    };
  }

  static copyActivity(Activity activity) {
    return Activity(
        title: activity.title, amount: activity.amount, unit: activity.unit);
  }
}
