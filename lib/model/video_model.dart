import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:isar/isar.dart';
import 'package:syncopathy/model/funscript_metadata.dart';
import 'package:syncopathy/model/user_category.dart';

part 'video_model.g.dart';

@collection
class Video {
  Id id = Isar.autoIncrement;
  final String title;
  final String videoPath;
  final String funscriptPath;
  double averageSpeed;
  bool isFavorite = false;
  bool isDislike = false;
  FunscriptMetadata? funscriptMetadata;
  DateTime dateFirstFound = DateTime.now();

  final categories = IsarLinks<UserCategory>();

  Video({
    required this.title,
    required this.videoPath,
    required this.funscriptPath,
    required this.averageSpeed,
    this.funscriptMetadata,
  });

  String get videoHash {
    final bytes = utf8.encode(videoPath);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
