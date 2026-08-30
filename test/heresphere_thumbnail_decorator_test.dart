import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/heresphere/thumbnail_decorator.dart';
import 'package:syncopathy/media_library/media_badge.dart';
import 'package:syncopathy/model/json/funscript_json.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

/// A plain coloured PNG standing in for a generated thumbnail.
Future<Uint8List> sourceImage({int width = 320, int height = 180}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(
    recorder,
    Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
  );
  canvas.drawRect(
    Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
    Paint()..color = const Color(0xFF334455),
  );
  final picture = recorder.endRecording();
  final image = await picture.toImage(width, height);
  picture.dispose();
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  return data!.buffer.asUint8List();
}

/// Decodes [bytes] far enough to assert its dimensions.
Future<ui.Image> decode(Uint8List bytes) async {
  final codec = await ui.instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  codec.dispose();
  return frame.image;
}

MediaFile clip() => MediaFile(
  name: 'clip',
  mediaPath: r'Q:\media\clip.mp4',
  fileHash: 'hash-clip',
  playCount: 7,
  fileNotFound: false,
);

/// A simple up-down script, enough for the heatmap to have something to colour.
List<FunscriptAction> script() => [
  for (var i = 0; i < 40; i++)
    FunscriptAction(at: i * 500, pos: i.isEven ? 10 : 90),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Uint8List source;

  setUp(() async {
    source = await sourceImage();
  });

  test('nothing to draw leaves the thumbnail alone', () async {
    // Null means "serve the original", which costs no decode and no re-encode.
    final result = await decorateThumbnail(
      source: source,
      media: clip(),
      overlay: const HereSphereThumbnailOverlay(),
    );
    expect(result, isNull);
  });

  test('a script with no duration draws no strip', () async {
    // The strip is laid out along the media's length; without one there is
    // nowhere to put the actions.
    final result = await decorateThumbnail(
      source: source,
      media: clip(),
      overlay: HereSphereThumbnailOverlay(heatmapActions: script()),
    );
    expect(result, isNull);
  });

  test('badges are drawn and the picture keeps its size', () async {
    final result = await decorateThumbnail(
      source: source,
      media: clip(),
      overlay: HereSphereThumbnailOverlay(
        badges: resolveBadges(const ['playCount']),
      ),
    );

    expect(result, isNotNull);
    final image = await decode(result!);
    addTearDown(image.dispose);
    expect(image.width, 320);
    expect(image.height, 180);
    // Re-encoded, so it is a PNG rather than the JPEG the generator produced.
    expect(result.sublist(1, 4), utf8PngSignature);
  });

  test('a heatmap strip is drawn when the script has a duration', () async {
    final result = await decorateThumbnail(
      source: source,
      media: clip(),
      overlay: HereSphereThumbnailOverlay(
        heatmapActions: script(),
        durationSeconds: 20,
      ),
    );

    expect(result, isNotNull);
    final image = await decode(result!);
    addTearDown(image.dispose);
    expect(image.height, 180);
  });

  test('badges and heatmap together produce one picture', () async {
    final result = await decorateThumbnail(
      source: source,
      media: clip(),
      overlay: HereSphereThumbnailOverlay(
        badges: resolveBadges(const ['playCount']),
        heatmapActions: script(),
        durationSeconds: 20,
      ),
    );
    expect(result, isNotNull);
  });

  test('an unreadable thumbnail degrades to the plain one', () async {
    // Anything that cannot be decorated must still be servable, so a failure
    // here is null rather than an exception.
    final result = await decorateThumbnail(
      source: Uint8List.fromList([1, 2, 3, 4, 5]),
      media: clip(),
      overlay: HereSphereThumbnailOverlay(
        badges: resolveBadges(const ['playCount']),
      ),
    );
    expect(result, isNull);
  });

  test('a badge that does not apply to this media is skipped', () async {
    // The AI marker only applies to a generated script, and this clip has no
    // script at all — so nothing is drawn and the original is served.
    final result = await decorateThumbnail(
      source: source,
      media: clip(),
      overlay: HereSphereThumbnailOverlay(
        badges: resolveBadges(const ['aiGenerated']),
      ),
    );
    expect(result, isNull);
  });
}

/// `PNG` — bytes 1..3 of the PNG signature.
final List<int> utf8PngSignature = 'PNG'.codeUnits;
