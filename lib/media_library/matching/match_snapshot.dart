import 'package:syncopathy/media_library/matching/name_normalizer.dart';
import 'package:syncopathy/persistence/entities/funscript_file.dart';

/// The media facts the matcher and the review UI need, and nothing else.
///
/// Snapshots deliberately carry no entity, no `File`, and no absolute path.
/// Discovery builds them from either the filesystem or the database, so matching
/// stays a pure function over plain data — a description of a file rather than a
/// handle to one. The caller keeps its own hash-to-path map.
class MediaSnapshot {
  final String fileHash;

  /// Filename without its extension.
  final String basename;

  /// Name of the immediate parent folder. A label, never a path: a sibling
  /// script and video usually share it, which is weak but real evidence.
  final String? directoryLabel;

  final double? durationSeconds;
  final int? width;
  final int? height;

  /// Which words normalization throws away. Carried per snapshot rather than
  /// read from a global so a re-rank under changed settings builds names the
  /// new settings agree with.
  final NoiseVocabulary vocabulary;

  late final NormalizedName name = normalizeName(
    basename,
    vocabulary: vocabulary,
  );
  late final NormalizedName? directory = directoryLabel == null
      ? null
      : normalizeName(directoryLabel!, vocabulary: vocabulary);

  MediaSnapshot({
    required this.fileHash,
    required this.basename,
    this.directoryLabel,
    this.durationSeconds,
    this.width,
    this.height,
    this.vocabulary = NoiseVocabulary.standard,
  });
}

/// The funscript facts the matcher needs, on the same terms as [MediaSnapshot].
class FunscriptSnapshot {
  final String funscriptHash;

  /// Filename without its extension, axis suffix included — [name] is what has
  /// the suffix stripped.
  final String basename;

  final String? directoryLabel;

  /// `metadata.title`, when the script carries any.
  final String? metadataTitle;

  final List<String> performers;

  /// `metadata.duration`, in seconds.
  final double? metadataDurationSeconds;

  /// Timestamp of the script's last action, in seconds. A lower bound on the
  /// media's length, and the only duration signal an unannotated script has.
  final double? lastActionSeconds;

  /// See [MediaSnapshot.vocabulary].
  final NoiseVocabulary vocabulary;

  late final NormalizedName name = normalizeName(
    basename,
    stripAxis: true,
    vocabulary: vocabulary,
  );
  late final NormalizedName? directory = directoryLabel == null
      ? null
      : normalizeName(directoryLabel!, vocabulary: vocabulary);
  late final NormalizedName? title = metadataTitle == null
      ? null
      : normalizeName(metadataTitle!, vocabulary: vocabulary);

  /// The basename with any axis suffix removed. Every script of one multi-axis
  /// set shares this, which is what bundles them.
  late final String axisStem = stripFunscriptAxisSuffix(basename);

  /// Rank of this script as a main-script candidate: 0 plain, 1 explicit
  /// stroke, 2 a secondary axis. The bundle's primary is its lowest rank, so a
  /// twist track can never be the script a match is decided on.
  late final int axisRank = funscriptAxisRank(basename);

  /// Metadata duration when the script declares one, otherwise the last action
  /// timestamp. Scripts frequently stop before the media does, so this is
  /// treated as supporting evidence rather than proof.
  double? get effectiveDurationSeconds =>
      metadataDurationSeconds ?? lastActionSeconds;

  FunscriptSnapshot({
    required this.funscriptHash,
    required this.basename,
    this.directoryLabel,
    this.metadataTitle,
    this.performers = const [],
    this.metadataDurationSeconds,
    this.lastActionSeconds,
    this.vocabulary = NoiseVocabulary.standard,
  });
}
