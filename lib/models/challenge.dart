import 'package:flutter/material.dart';

class Challenge {
  final int id;
  final ChallengStatus status;
  final String title;
  final String description;
  final String thumbnailPath;
  final DateTime startDate;
  final DateTime endDate;
  final List<AcceptanceCriteria> acceptanceCriteria;

  Challenge(
      {required this.id,
      required this.status,
      required this.title,
      required this.description,
      required this.thumbnailPath,
      required this.startDate,
      required this.endDate,
      required this.acceptanceCriteria});

  static Challenge fromJson(json) => Challenge(
      id: json['id'],
      status: ChallengStatus.factory(json['status']),
      title: json['title'],
      description: json['description'],
      thumbnailPath: json['thumbnailPath'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      acceptanceCriteria:
          AcceptanceCriteria.fromJsonList(json['acceptanceCriteria']));
}

class AcceptanceCriteria {
  Activity activity;
  String frequence;
  String tracking;
  int progress;

  AcceptanceCriteria(
      {required this.activity,
      required this.frequence,
      required this.tracking,
      required this.progress});

  static AcceptanceCriteria fromJson(json) => AcceptanceCriteria(
      activity: json['activity'],
      frequence: json['frequence'],
      tracking: json['tracking'],
      progress: json['progress']);

  static List<AcceptanceCriteria> fromJsonList(json) {
    List<AcceptanceCriteria> list = [];
    json.forEach((e) => list.add(AcceptanceCriteria(
        activity: Activity.fromJson(e['activity']),
        frequence: e['frequence'],
        tracking: e['tracking'],
        progress: e['progress'])));
    return list;
  }
}

class Activity {
  String title;
  double amount;
  String unit;

  Activity({required this.title, required this.amount, required this.unit});

  static fromJson(json) => Activity(
      title: json['title'], amount: json['amount'], unit: json['unit']);
}

enum ChallengStatus {
  success('Success'),
  failed('Failed'),
  inProgress('InProgress');

  const ChallengStatus(String status);

  static ChallengStatus factory(String status) {
    if (status == 'Success')
      return ChallengStatus.success;
    else if (status == 'Failed')
      return ChallengStatus.failed;
    else
      return ChallengStatus.inProgress;
  }
}
