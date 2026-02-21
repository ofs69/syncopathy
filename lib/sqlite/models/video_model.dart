import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:syncopathy/model/funscript.dart';
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
  int playCount;
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
    this.playCount = 0,
    required this.dateFirstFound,
    this.duration,
    this.funscriptMetadataId,
    this.funscriptMetadata,
    List<UserCategory>? categories,
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

  // HACK: remove this
  Funscript? _funscript;
  Funscript? get funscript => _funscript;

  Future<void> loadFunscript() async {
    if (funscriptPath.isNotEmpty && _funscript == null) {
      try {
        _funscript = await Funscript.fromFile(funscriptPath);
      } catch (e) {
        debugPrint('Error loading funscript from $funscriptPath: $e');
        _funscript = null; // Ensure funscript is null on error
      }
    }
  }
}
