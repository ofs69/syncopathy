import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:syncopathy/sqlite/models/user_category_old.dart';

class VideoOld {
  final int? id;
  final String title;
  final String videoPath;
  final String funscriptPath;
  double averageSpeed;
  double averageMin;
  double averageMax;
  bool isFavorite;
  bool isDislike;
  int playCount;
  DateTime dateFirstFound;
  double? duration;
  int? funscriptMetadataId;

  // Joined data
  List<UserCategoryOld> categories;

  VideoOld({
    this.id,
    required this.title,
    required this.videoPath,
    required this.funscriptPath,
    required this.averageSpeed,
    required this.averageMin,
    required this.averageMax,
    this.isFavorite = false,
    this.isDislike = false,
    this.playCount = 0,
    required this.dateFirstFound,
    this.duration,
    this.funscriptMetadataId,
    List<UserCategoryOld>? categories,
  }) : categories = categories ?? [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'videoPath': videoPath,
      'funscriptPath': funscriptPath,
      'averageSpeed': averageSpeed,
      'averageMin': averageMin,
      'averageMax': averageMax,
      'isFavorite': isFavorite ? 1 : 0,
      'isDislike': isDislike ? 1 : 0,
      'playCount': playCount,
      'dateFirstFound': dateFirstFound.millisecondsSinceEpoch,
      'duration': duration,
      'funscriptMetadataId': funscriptMetadataId,
    };
  }

  factory VideoOld.fromMap(Map<String, dynamic> map) {
    return VideoOld(
      id: map['id'],
      title: map['title'],
      videoPath: map['videoPath'],
      funscriptPath: map['funscriptPath'],
      averageSpeed: map['averageSpeed'],
      averageMin: map['averageMin'],
      averageMax: map['averageMax'],
      isFavorite: map['isFavorite'] == 1,
      isDislike: map['isDislike'] == 1,
      playCount: map['playCount'] ?? 0,
      dateFirstFound: DateTime.fromMillisecondsSinceEpoch(
        map['dateFirstFound'],
      ),
      duration: map['duration'],
      funscriptMetadataId: map['funscriptMetadataId'],
    );
  }

  String get videoHash {
    final bytes = utf8.encode(videoPath);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
