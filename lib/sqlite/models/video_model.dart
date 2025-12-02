
import 'package:syncopathy/sqlite/models/funscript_metadata.dart';
import 'package:syncopathy/sqlite/models/user_category.dart';

class Video {
  final int? id;
  final String title;
  final String videoPath;
  final String funscriptPath;
  double averageSpeed;
  double averageMin;
  double averageMax;
  bool isFavorite;
  bool isDislike;
  DateTime dateFirstFound;
  double? duration;
  int? funscriptMetadataId;

  // Joined data
  FunscriptMetadata? funscriptMetadata;
  List<UserCategory> categories;

  Video({
    this.id,
    required this.title,
    required this.videoPath,
    required this.funscriptPath,
    required this.averageSpeed,
    required this.averageMin,
    required this.averageMax,
    this.isFavorite = false,
    this.isDislike = false,
    required this.dateFirstFound,
    this.duration,
    this.funscriptMetadataId,
    this.funscriptMetadata,
    this.categories = const [],
  });

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
      'dateFirstFound': dateFirstFound.millisecondsSinceEpoch,
      'duration': duration,
      'funscriptMetadataId': funscriptMetadataId,
    };
  }

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      id: map['id'],
      title: map['title'],
      videoPath: map['videoPath'],
      funscriptPath: map['funscriptPath'],
      averageSpeed: map['averageSpeed'],
      averageMin: map['averageMin'],
      averageMax: map['averageMax'],
      isFavorite: map['isFavorite'] == 1,
      isDislike: map['isDislike'] == 1,
      dateFirstFound: DateTime.fromMillisecondsSinceEpoch(map['dateFirstFound']),
      duration: map['duration'],
      funscriptMetadataId: map['funscriptMetadataId'],
    );
  }
}
