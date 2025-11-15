import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:isar/isar.dart';
import 'package:syncopathy/model/funscript_metadata.dart';
import 'package:syncopathy/model/user_category.dart';
import 'package:syncopathy/model/funscript.dart'; // Added import

part 'video_model.g.dart';

@collection
class Video {
  Id id = Isar.autoIncrement;
  final String title;
  final String videoPath;
  final String funscriptPath;
  double averageSpeed;
  double averageMin;
  double averageMax;
  bool isFavorite = false;
  bool isDislike = false;
  FunscriptMetadata? funscriptMetadata;
  DateTime dateFirstFound = DateTime.now();
  double? duration;

  @ignore
  Funscript? _funscript; // Added field
  @ignore
  Funscript? get funscript => _funscript; // Added getter

  final categories = IsarLinks<UserCategory>();

  Video({
    required this.title,
    required this.videoPath,
    required this.funscriptPath,
    required this.averageSpeed,
    required this.averageMin,
    required this.averageMax,
    this.funscriptMetadata,
    this.duration,
  });

  Future<void> loadFunscript() async {
    if (funscriptPath.isNotEmpty && _funscript == null) {
      try {
        _funscript = await Funscript.fromFile(funscriptPath);
      } catch (e) {
        print('Error loading funscript from $funscriptPath: $e');
        _funscript = null; // Ensure funscript is null on error
      }
    }
  }

  String get videoHash {
    final bytes = utf8.encode(videoPath);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
