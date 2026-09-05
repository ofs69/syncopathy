import 'package:objectbox/objectbox.dart';

/// A parsed funscript's derived numbers, kept so a rescan does not decode the
/// same JSON again.
///
/// The match tool reads every funscript it cannot resolve by name, which is a
/// full JSON decode of an action array per file. Nothing about that result
/// depends on anything but the bytes of the file, so it is keyed by content
/// hash rather than by path: two copies of one script share a row, and a file
/// that is edited gets a new hash and therefore a new one.
///
/// Only what the file itself says is stored. A library row's metadata is a
/// fallback applied where that row is known, so what is cached stays a pure
/// function of the file's content.
@Entity()
class FunscriptAnalysisCache {
  @Id()
  int id = 0;

  @Index(type: IndexType.value)
  @Unique(onConflict: ConflictStrategy.replace)
  String funscriptHash;

  /// The `FunscriptAlgorithms.algorithmVersion` the averages were computed
  /// under. A row written by an older version is a miss, not a value.
  int algorithmVersion;

  double averageSpeed;
  double averageMin;
  double averageMax;
  bool isScriptToken;

  /// The script's own metadata as JSON, or null when the file carries none.
  String? metadataJson;

  /// Timestamp of the last action, in seconds. Null for a script with no
  /// actions at all.
  double? lastActionSeconds;

  /// When a scan last used this row.
  ///
  /// Nothing else in the database refers to these entries — they exist for the
  /// files the library deliberately does not hold — so there is no relation to
  /// prune them by. This is what lets cleanup tell a row still in use from one
  /// whose file has been gone for months.
  @Property(type: PropertyType.date)
  DateTime lastSeenOn;

  FunscriptAnalysisCache({
    required this.funscriptHash,
    required this.algorithmVersion,
    required this.averageSpeed,
    required this.averageMin,
    required this.averageMax,
    required this.isScriptToken,
    required this.lastSeenOn,
    this.metadataJson,
    this.lastActionSeconds,
  });
}
