import 'package:flutter/material.dart';

class Challenge {
  int? id;
  ChallengStatus? status;
  String title;
  String description;
  String thumbnailPath;
  DateTime? startDate;
  DateTime? endDate;
  List<AcceptanceCriteria> acceptanceCriteria;
  List<Media> media;

  Challenge(
      {required this.id,
      required this.status,
      required this.title,
      required this.description,
      required this.thumbnailPath,
      required this.startDate,
      required this.endDate,
      required this.acceptanceCriteria,
      required this.media});

  static Challenge fromJson(json) => Challenge(
      id: json['id'],
      status: ChallengStatus.factory(json['status']),
      title: json['title'],
      description: json['description'],
      thumbnailPath: json['thumbnailPath'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      acceptanceCriteria:
          AcceptanceCriteria.fromJsonList(json['acceptanceCriteria']),
      media: Media.fromJsonList(json['media']));
}

class Media {
  int id;
  String type;
  String title;
  String source;

  Media({required this.id, required this.type, required this.title, required this.source});

  static fromJsonList(json) {
    List<Media> list = [];
    json?.forEach((e) => list
        .add(Media(type: e['type'], title: e['title'], source: e['source'], id: e['id']) ));
    return list;
  }
}

class AcceptanceCriteria {
  Activity activity;
  String frequence;
  String tracking;
  int progress;
  List<Evidence> evidences;

  AcceptanceCriteria(
      {required this.activity,
      required this.frequence,
      required this.tracking,
      required this.progress,
      required this.evidences});

  static List<AcceptanceCriteria> fromJsonList(json) {
    List<AcceptanceCriteria> list = [];
    json?.forEach((e) => list.add(AcceptanceCriteria(
        activity: Activity.fromJson(e['activity']),
        frequence: e['frequence'],
        tracking: e['tracking'],
        progress: e['progress'],
        evidences: Evidence.fromJsonList(e['evidences']))));
    return list;
  }
}

class Evidence {
  int progress;
  List<int> mediaIds;

  Evidence({required this.progress, required this.mediaIds});

  static fromJsonList(json) {
    List<Evidence> list = [];
    json?.forEach((e) =>
        list.add(Evidence(progress: e['progress'], mediaIds: List.from(e['mediaIds']) )));
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
  inProgress('InProgress'),
  backlog('Backlog');

  const ChallengStatus(String status);

  static ChallengStatus factory(String status) {
    if (status == 'Success') {
      return ChallengStatus.success;
    } else if (status == 'Failed') {
      return ChallengStatus.failed;
    } else if (status == 'Backlog') {
      return ChallengStatus.backlog;
    } else {
      return ChallengStatus.inProgress;
    }
  }
}
