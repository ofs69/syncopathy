import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:syncopathy/heatmap.dart';
import 'package:syncopathy/media_library/media_badge.dart';
import 'package:syncopathy/model/json/funscript_json.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

/// Width the badge geometry is calibrated for.
///
/// Badges are sized in logical pixels for a library card of roughly this width.
/// A thumbnail is a bare bitmap with no such scale, so everything drawn onto it
/// is scaled by its width against this, which keeps a badge the same fraction
/// of the picture whatever size the thumbnail happens to be.
const double _referenceWidth = 320.0;

/// Bounds on that scale.
///
/// A tiny thumbnail would otherwise get badges too small to read, and a very
/// large one badges that swallow the frame.
const double _minScale = 1.0;
const double _maxScale = 3.0;

/// Heatmap strip height, as a fraction of the thumbnail's height.
const double _heatmapFraction = 0.09;
const double _minHeatmapHeight = 8.0;

/// What to draw over one thumbnail.
///
/// Assembled by the caller, which is what knows the user's badge settings and
/// can read the script off disk; this file only draws.
class HereSphereThumbnailOverlay {
  /// Badges to draw, in the order the library grid draws them.
  final List<BadgeSpec> badges;

  /// Actions for the heatmap strip. Empty draws no strip.
  final List<FunscriptAction> heatmapActions;

  /// Length of the media, needed to lay the heatmap out along the strip.
  final double? durationSeconds;

  const HereSphereThumbnailOverlay({
    this.badges = const [],
    this.heatmapActions = const [],
    this.durationSeconds,
  });

  /// Whether this overlay would put nothing on [media]'s thumbnail.
  ///
  /// Takes the media because a badge decides for itself whether it applies —
  /// the AI marker and the script count are absent for most entries. Asking
  /// before decoding matters: a library with no scripts would otherwise pay a
  /// decode and a re-encode per thumbnail to draw nothing at all.
  bool nothingToDrawFor(MediaFile media) =>
      !hasHeatmap && !badges.any((spec) => spec.build(media) != null);

  /// Whether there is a strip to draw: actions to plot, and a length to plot
  /// them along.
  bool get hasHeatmap =>
      heatmapActions.length >= 2 &&
      durationSeconds != null &&
      durationSeconds! > 0;
}

/// Draws [overlay] onto [source] and re-encodes it, or returns null when there
/// is nothing to add or the image cannot be read.
///
/// Returning null rather than throwing is deliberate: a thumbnail that cannot
/// be decorated should still be served undecorated, so every failure here
/// degrades to the plain picture instead of to a missing one.
Future<Uint8List?> decorateThumbnail({
  required Uint8List source,
  required MediaFile media,
  required HereSphereThumbnailOverlay overlay,
}) async {
  if (overlay.nothingToDrawFor(media)) return null;

  ui.Image? image;
  ui.Image? rendered;
  try {
    image = await _decode(source);
    if (image == null) return null;

    final width = image.width;
    final height = image.height;
    if (width <= 0 || height <= 0) return null;

    final scale = (width / _referenceWidth).clamp(_minScale, _maxScale);
    final size = Size(width.toDouble(), height.toDouble());

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Offset.zero & size);
    canvas.drawImage(image, Offset.zero, Paint());

    _paintHeatmap(canvas, size, overlay);
    _paintBadges(canvas, size, media, overlay.badges, scale);

    final picture = recorder.endRecording();
    try {
      rendered = await picture.toImage(width, height);
    } finally {
      picture.dispose();
    }

    final data = await rendered.toByteData(format: ui.ImageByteFormat.png);
    if (data == null) return null;
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  } catch (_) {
    // A malformed thumbnail, or a raster the engine refused. The caller serves
    // the original.
    return null;
  } finally {
    image?.dispose();
    rendered?.dispose();
  }
}

Future<ui.Image?> _decode(Uint8List bytes) async {
  final codec = await ui.instantiateImageCodec(bytes);
  try {
    final frame = await codec.getNextFrame();
    return frame.image;
  } finally {
    codec.dispose();
  }
}

/// The heatmap strip along the bottom edge.
///
/// Drawn on a dark backing rather than straight onto the frame: a heatmap over
/// a bright scene is unreadable, and the strip has to be legible on every
/// thumbnail or it is worse than no strip at all.
void _paintHeatmap(
  Canvas canvas,
  Size size,
  HereSphereThumbnailOverlay overlay,
) {
  final actions = overlay.heatmapActions;
  final duration = overlay.durationSeconds;
  if (actions.length < 2 || duration == null || duration <= 0) return;

  final stripHeight = (size.height * _heatmapFraction).clamp(
    _minHeatmapHeight,
    size.height / 2,
  );
  final top = size.height - stripHeight;

  canvas.drawRect(
    Rect.fromLTWH(0, top, size.width, stripHeight),
    Paint()..color = Colors.black.withValues(alpha: 0.55),
  );

  final painter = HeatmapPainter(
    actions: actions,
    totalDuration: Duration(milliseconds: (duration * 1000).round()),
    playbackSpeed: 1.0,
    // Unscaled: the strip describes the script as stored, not as one particular
    // set of range settings would play it.
    effectiveSpeeds: heatmapEffectiveSpeeds(
      actions,
      1.0,
      const RangeValues(0, 100),
    ),
  );

  canvas.save();
  canvas.translate(0, top);
  canvas.clipRect(Rect.fromLTWH(0, 0, size.width, stripHeight));
  painter.paint(canvas, Size(size.width, stripHeight));
  canvas.restore();
}

/// The badge cluster in the top-right corner.
///
/// Lays out the same way [MediaBadgeOverlay] does — right-aligned pills that
/// wrap onto further rows — but by hand, because there is no widget tree here
/// to run a `Wrap` in.
void _paintBadges(
  Canvas canvas,
  Size size,
  MediaFile media,
  List<BadgeSpec> badges,
  double scale,
) {
  if (badges.isEmpty) return;

  final pills = <_Pill>[];
  for (final spec in badges) {
    final value = spec.build(media);
    if (value == null) continue;
    pills.add(_Pill.layout(spec, value, scale));
  }
  if (pills.isEmpty) return;

  final margin = mediaBadgePadding * scale;
  final spacing = mediaBadgeSpacing * scale;
  final available = size.width - margin * 2;

  // Split into rows first, so each row can be right-aligned once its total
  // width is known.
  final rows = <List<_Pill>>[];
  var row = <_Pill>[];
  var used = 0.0;
  for (final pill in pills) {
    final needed = row.isEmpty ? pill.width : used + spacing + pill.width;
    if (row.isNotEmpty && needed > available) {
      rows.add(row);
      row = [pill];
      used = pill.width;
      continue;
    }
    row.add(pill);
    used = needed;
  }
  if (row.isNotEmpty) rows.add(row);

  var y = margin;
  for (final current in rows) {
    final rowHeight = current.fold<double>(
      0,
      (m, p) => p.height > m ? p.height : m,
    );
    var totalWidth = 0.0;
    for (final pill in current) {
      totalWidth += pill.width;
    }
    totalWidth += spacing * (current.length - 1);

    var x = size.width - margin - totalWidth;
    for (final pill in current) {
      pill.paint(canvas, Offset(x, y));
      x += pill.width + spacing;
    }
    y += rowHeight + spacing;
  }
}

/// One laid-out badge, ready to draw at a given offset.
class _Pill {
  final TextPainter icon;
  final TextPainter? label;
  final Color tint;
  final double scale;
  final double width;
  final double height;

  _Pill._({
    required this.icon,
    required this.label,
    required this.tint,
    required this.scale,
    required this.width,
    required this.height,
  });

  factory _Pill.layout(BadgeSpec spec, BadgeValue value, double scale) {
    const foreground = Colors.white;
    final glyph = value.icon ?? spec.icon;
    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(glyph.codePoint),
        style: TextStyle(
          fontFamily: glyph.fontFamily,
          package: glyph.fontPackage,
          fontSize: mediaBadgeIconSize * scale,
          color: foreground,
          height: 1.0,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    TextPainter? labelPainter;
    final text = value.text;
    if (text != null && text.isNotEmpty) {
      labelPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: mediaBadgeTextStyle(
            color: foreground,
            fontSize: mediaBadgeFontSize * scale,
          ),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout();
    }

    final padding = mediaBadgePadding * scale;
    final gap = mediaBadgeGap * scale;
    final contentWidth =
        iconPainter.width +
        (labelPainter == null ? 0 : gap + labelPainter.width);
    final contentHeight = labelPainter == null
        ? iconPainter.height
        : (labelPainter.height > iconPainter.height
              ? labelPainter.height
              : iconPainter.height);

    return _Pill._(
      icon: iconPainter,
      label: labelPainter,
      tint: value.tint ?? Colors.black54,
      scale: scale,
      width: contentWidth + padding * 2,
      height: contentHeight + padding * 2,
    );
  }

  void paint(Canvas canvas, Offset origin) {
    final radius = Radius.circular(mediaBadgeRadius * scale);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(origin.dx, origin.dy, width, height),
        radius,
      ),
      Paint()..color = tint,
    );

    final padding = mediaBadgePadding * scale;
    final contentTop = origin.dy + padding;
    final contentHeight = height - padding * 2;

    icon.paint(
      canvas,
      Offset(
        origin.dx + padding,
        contentTop + (contentHeight - icon.height) / 2,
      ),
    );

    final labelPainter = label;
    if (labelPainter != null) {
      labelPainter.paint(
        canvas,
        Offset(
          origin.dx + padding + icon.width + mediaBadgeGap * scale,
          contentTop + (contentHeight - labelPainter.height) / 2,
        ),
      );
    }
  }
}
