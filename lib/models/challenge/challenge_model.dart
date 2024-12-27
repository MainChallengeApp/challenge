import 'package:challenge/enums/challenge_category_enum.dart';
import 'package:challenge/enums/challenge_status_enum.dart';
import 'package:challenge/enums/frequency_type_enum.dart.dart';
import 'package:challenge/models/challenge/frequency_model.dart';
import 'package:challenge/models/challenge/thumbnail_model.dart';
import 'package:challenge/services/time_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import 'acceptance_criteria_model.dart';
import 'media_model.dart';

class ChallengeModel {
  String id;
  static const String idField = 'id';

  ChallengeStatusEnum status;
  static const String statusField = 'status';

  String title;
  static const String titleField = 'title';

  String titleLowerCase; // only for search
  static const String titleLowerCaseField = 'titleLowerCase';

  String description;
  static const String descriptionField = 'description';

  ThumbnailModel? thumbnail;
  static const String thumbnailField = 'thumbnail';

  DateTime? startDate;
  static const String startDateField = 'startDate';

  DateTime? endDate;
  static const String endDateField = 'endDate';

  late AcceptanceCriteriaModel acceptanceCriteria;
  static const String acceptanceCriteriaField = 'acceptanceCriteria';

  late FrequencyModel frequency;
  static const String frequencyField = 'frequency';

  List<MediaModel> media;
  static const String mediaField = 'media';

  List<ChallengeCategoryEnum> categories;
  static const String categoriesField = 'categories';

  DateTime createdAt;
  static const String createdAtField = 'createdAt';

  ChallengeModel(
      {required this.id,
      required this.status,
      required this.title,
      required this.titleLowerCase,
      required this.description,
      required this.thumbnail,
      this.startDate,
      this.endDate,
      required this.acceptanceCriteria,
      required this.frequency,
      required this.media,
      this.categories = const [],
      DateTime? createdAt})
      : createdAt = createdAt ?? TimeService.now();

  ChallengeModel.empty({
    this.id = '',
    this.status = ChallengeStatusEnum.backlog,
    this.title = '',
    this.titleLowerCase = '',
    this.description = '',
    this.media = const [],
    this.categories = const [],
    this.thumbnail,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? TimeService.now() {
    id = const Uuid().v4();
    acceptanceCriteria = AcceptanceCriteriaModel.empty();
    frequency = FrequencyModel.empty();
    media = [];
  }

  static ChallengeModel fromDoc(DocumentSnapshot doc) {
    try {
      ChallengeModel challenge = ChallengeModel(
        id: doc.id,
        status: ChallengeStatusEnum.fromString(doc[statusField]),
        title: doc[titleField],
        titleLowerCase: doc[titleLowerCaseField],
        description: doc[descriptionField],
        thumbnail: doc[thumbnailField] == null
            ? null
            : ThumbnailModel.fromDoc(doc[thumbnailField]),
        startDate: doc[startDateField] == null
            ? null
            : (doc[startDateField] as Timestamp).toDate(),
        endDate: doc[endDateField] == null
            ? null
            : (doc[endDateField] as Timestamp).toDate(),
        acceptanceCriteria:
            AcceptanceCriteriaModel.fromDoc(doc[acceptanceCriteriaField]),
        frequency: FrequencyModel.fromDoc(doc[frequencyField]),
        media: MediaModel.fromDocs(doc[mediaField]),
        categories: ChallengeCategoryEnum.fromDocs(doc[categoriesField]),
        createdAt: (doc[createdAtField] as Timestamp).toDate(),
      );

      return challenge;
    } on Exception {
      rethrow;
    }
  }

  Map<String, dynamic> toDoc() {
    return {
      statusField: status.status,
      titleField: title,
      titleLowerCaseField: title.toLowerCase(),
      descriptionField: description,
      thumbnailField: thumbnail?.toDoc(),
      startDateField: startDate,
      endDateField: endDate,
      acceptanceCriteriaField: acceptanceCriteria.toDoc(),
      frequencyField: frequency.toDoc(),
      mediaField: media.map((media) => media.toDoc()).toList(),
      categoriesField: ChallengeCategoryEnum.toDocs(categories),
      createdAtField: createdAt
    };
  }

  ChallengeModel copy({bool isTryAgain = false, bool withId = false}) {
    return ChallengeModel(
        id: withId ? id : '',
        status: isTryAgain ? ChallengeStatusEnum.backlog : status,
        title: title,
        titleLowerCase: titleLowerCase,
        startDate: isTryAgain ? null : startDate,
        endDate: isTryAgain ? null : endDate,
        description: description,
        thumbnail: thumbnail?.copy(),
        acceptanceCriteria: acceptanceCriteria.copy(),
        frequency: frequency.copy(),
        media: isTryAgain ? [] : MediaModel.copyList(media),
        categories: ChallengeCategoryEnum.copyCategoryList(categories),
        createdAt: createdAt);
  }

  bool searchInChallenge(String searchText) {
    if (title.toLowerCase().startsWith(searchText.toLowerCase())) return true;

    // too advanced for a free Firebase plan
    // TODO: we should implement the search better when we use the paid subscription
    // if (description.toLowerCase().contains(searchText.toLowerCase())) {
    //   return true;
    // }
    // if (acceptanceCriteria.unit
    //     .toLowerCase()
    //     .contains(searchText.toLowerCase())) {
    //   return true;
    // }
    return false;
  }

  bool isInCategories(List<ChallengeCategoryEnum> categories) {
    return categories.isEmpty
        ? true
        : this.categories.toSet().intersection(categories.toSet()).isNotEmpty;
  }

  setStartDate() {
    if (frequency.type == FrequencyTypeEnum.daily) {
      if (frequency.amount == null) {
        startDate = null;
      } else if (endDate != null) {
        startDate = endDate!.subtract(Duration(days: frequency.amount!));
      }
    } else if (frequency.type == FrequencyTypeEnum.time) {
      if (endDate != null &&
          startDate != null &&
          endDate!.isBefore(startDate!)) {
        startDate = endDate;
      }
    }
  }

  setEndDate() {
    if (startDate != null &&
        frequency.type == FrequencyTypeEnum.daily &&
        frequency.amount != null) {
      endDate = startDate!.add(Duration(days: frequency.amount!));
    } else if (frequency.type == FrequencyTypeEnum.daily &&
        frequency.amount == null) {
      endDate = null;
    }
  }

  setFrequencyAmount() {
    if (startDate == null && endDate == null) return;

    if (startDate != null &&
        endDate != null &&
        frequency.type == FrequencyTypeEnum.daily) {
      int amount = endDate!.difference(startDate!).inDays +
          (endDate!.difference(startDate!).inSeconds -
                      endDate!.difference(startDate!).inDays * 24 * 60 * 60 >
                  0
              ? 1
              : 0); // if there is not a whole day difference, add one day
      if (amount >= 0) {
        frequency.amount = amount;
      }
    } else if (frequency.type == FrequencyTypeEnum.daily && endDate == null) {
      frequency.amount = null;
    }
  }

  hasThumbnail() {
    return thumbnail != null && thumbnail!.url != '';
  }

  bool isInBacklog() {
    return status == ChallengeStatusEnum.backlog;
  }

  bool isInProgress() {
    return status == ChallengeStatusEnum.inProgress;
  }

  bool isSucceeded() {
    return status == ChallengeStatusEnum.success;
  }

  bool isFailed() {
    return status == ChallengeStatusEnum.failed;
  }

  bool isEditable() {
    return status == ChallengeStatusEnum.backlog ||
        status == ChallengeStatusEnum.inProgress;
  }

  // TODO: complete the sorting
  static List<ChallengeModel> sortChallengeList(
      {required List<ChallengeModel> challenges}) {
    challenges.sort((a, b) {
      if (a.status == b.status) {
        return a.title.compareTo(b.title);
      } else {
        return a.status.status.compareTo(b.status.status);
      }
    });
    return challenges;
  }
}
