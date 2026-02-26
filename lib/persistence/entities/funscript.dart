import 'dart:convert';

import 'package:objectbox/objectbox.dart';
import 'package:syncopathy/persistence/entities/media.dart';
import 'package:syncopathy/sqlite/models/funscript_metadata.dart';

@Entity()
class FunscriptFile {
  @Id()
  int id = 0;
  String path;

  @Transient()
  FunscriptMetadata? metadata;
  String? get metadataDb => jsonEncode(metadata?.toMap());
  set metadataDb(String? json) =>
      json != null ? FunscriptMetadata.fromJson(jsonDecode(json)) : null;

  double? averageSpeed;
  double? averageMin;
  double? averageMax;

  @Backlink('funscripts')
  final media = ToMany<Media>();

  FunscriptFile({
    required this.path,
    required this.averageSpeed,
    required this.averageMin,
    required this.averageMax,
    this.metadata
  });
}
