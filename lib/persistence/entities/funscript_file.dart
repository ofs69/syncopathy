import 'dart:convert';

import 'package:objectbox/objectbox.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/model/json/funscript_metadata.dart';

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

  bool isScriptToken;
  bool fileNotFound;

  @Backlink('funscripts')
  final media = ToMany<MediaFile>();

  FunscriptFile({
    required this.path,
    required this.averageSpeed,
    required this.averageMin,
    required this.averageMax,
    required this.isScriptToken,
    required this.fileNotFound,
    this.metadata,
  });
}
