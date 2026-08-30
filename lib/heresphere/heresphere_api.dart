import 'package:syncopathy/heresphere/heresphere_library.dart';

/// Value of the header HereSphere uses to recognise a compatible server.
const String hereSphereJsonVersionHeader = 'HereSphere-JSON-Version';
const String hereSphereJsonVersion = '1';

/// `access` values in an API response: 1 grants the client the library, 0 asks
/// it to log in, -1 reports a failed login. Syncopathy authorises by token in
/// the URL, so a request that gets a response at all is already authorised.
const int hereSphereAccessGranted = 1;

/// Asks the client to prompt for a username and password. What a request with
/// no usable credentials gets.
const int hereSphereAccessLoginRequired = 0;

/// Reports that the credentials sent were wrong.
const int hereSphereAccessDenied = -1;

/// Builds the JSON bodies of the HereSphere API.
///
/// Pure map construction against a base URL, so the shape of every response can
/// be asserted in tests without binding a socket. [baseUrl] is the tokenised
/// prefix every URL handed to the client is built from, without a trailing
/// slash.
class HereSphereApi {
  final String baseUrl;

  const HereSphereApi(this.baseUrl);

  String videoUrl(String id) => '$baseUrl/video/${Uri.encodeComponent(id)}';
  String scriptUrl(String id, int index) =>
      '$baseUrl/script/${Uri.encodeComponent(id)}/$index';
  String mediaUrl(String id) => '$baseUrl/media/${Uri.encodeComponent(id)}';
  String thumbnailUrl(String id) => '$baseUrl/thumb/${Uri.encodeComponent(id)}';
  String get eventUrl => '$baseUrl/event';

  /// The library index: named sections, each listing per-video metadata URLs.
  /// The library index: named sections, each listing per-video metadata URLs.
  Map<String, dynamic> index(List<HereSphereSection> sections) => {
    'access': hereSphereAccessGranted,
    'library': [
      for (final section in sections)
        {
          'name': section.name,
          'list': [for (final entry in section.entries) videoUrl(entry.id)],
        },
    ],
  };

  /// Metadata for one entry.
  ///
  /// [fileSizeBytes] is reported to the client when known; it is the only field
  /// that needs the file itself, so the caller stats it rather than this
  /// builder reaching for the filesystem.
  ///
  /// [scripts] is the one field that decides who drives the device. Passing an
  /// empty list — the default — leaves `scripts` out entirely, which is what
  /// keeps HereSphere from taking the funscript over. The caller supplies a
  /// non-empty list only when the user has chosen to hand it over.
  Map<String, dynamic> videoData(
    HereSphereEntry entry, {
    int? fileSizeBytes,
    List<HereSphereScript> scripts = const [],
  }) {
    final duration = entry.durationSeconds;
    return {
      'access': hereSphereAccessGranted,
      'title': entry.title,
      if (entry.addedOn != null)
        'dateAdded': _formatDate(entry.addedOn!.toLocal()),
      // HereSphere reports durations in milliseconds.
      if (duration != null && duration > 0) 'duration': duration * 1000.0,
      'thumbnailImage': thumbnailUrl(entry.id),
      'rating': ?entry.rating,
      'isFavorite': entry.isFavorite,
      // Layout fields appear only when the filename actually declared them.
      // Publishing a guess would be worse than publishing nothing: HereSphere
      // trusts what the API says and stops working the layout out for itself,
      // so an absent field leaves its own detection in charge.
      'projection': ?entry.projection.projection,
      'stereo': ?entry.projection.stereo,
      'fov': ?entry.projection.fov,
      'lens': ?entry.projection.lens,
      'media': [
        {
          'name': 'Direct',
          'sources': [
            {
              'resolution': ?entry.height,
              'width': ?entry.width,
              'height': ?entry.height,
              'size': ?fileSizeBytes,
              'url': mediaUrl(entry.id),
            },
          ],
        },
      ],
      // Present only when the user put HereSphere in charge of the device.
      // Left out otherwise: a script URL is exactly what lets HereSphere
      // command the hardware, and in the other mode Syncopathy is doing that.
      // The `Interactive` tag marks the entry either way, without handing
      // anything over.
      if (scripts.isNotEmpty)
        'scripts': [
          for (final script in scripts)
            {'name': script.name, 'url': scriptUrl(entry.id, script.index)},
        ],
      'tags': ?_tags(entry),
      'eventServer': eventUrl,
      // Nothing in the library is writable from the headset yet.
      'writeFavorite': false,
      'writeRating': false,
      'writeTags': false,
    };
  }

  /// Bulk metadata for the whole library in one response.
  ///
  /// Without it HereSphere learns nothing about an entry until it fetches that
  /// entry's own metadata URL, so browsing a large library means thousands of
  /// round trips and its search only covers what it has already pulled. This
  /// hands it every title, date, duration, rating and tag up front, which is
  /// what makes its own search, sort and filter work across the whole library.
  Map<String, dynamic> scan(List<HereSphereEntry> entries) => {
    'access': hereSphereAccessGranted,
    'scanData': [for (final entry in entries) _scanEntry(entry)],
  };

  Map<String, dynamic> _scanEntry(HereSphereEntry entry) {
    final duration = entry.durationSeconds;
    return {
      'link': videoUrl(entry.id),
      'title': entry.title,
      if (entry.addedOn != null)
        'dateAdded': _formatDate(entry.addedOn!.toLocal()),
      // Seconds here, where `videoData` publishes milliseconds. That asymmetry
      // is not a mistake on this side: it is what the reference implementation
      // has sent for years, and it is the only behaviour with evidence behind
      // it. Flagged for the manual pass — if durations read wrong in the
      // headset's browser but right once an entry opens, this scale is why.
      if (duration != null && duration > 0) 'duration': duration,
      'rating': ?entry.rating,
      'isFavorite': entry.isFavorite,
      'tags': ?_tags(entry),
    };
  }

  /// The entry's tags in wire form, or null when it has none.
  ///
  /// Null rather than an empty list so the field is left out entirely: an
  /// empty `tags` array reads to the player as "this entry has no tags", which
  /// is a claim, where an absent field is silence.
  static List<Map<String, dynamic>>? _tags(HereSphereEntry entry) {
    if (entry.tags.isEmpty) return null;
    return [
      for (final tag in entry.tags) {'name': tag},
    ];
  }

  static String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
