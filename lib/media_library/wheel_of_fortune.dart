import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

class WheelOfFortuneDialog extends StatefulWidget {
  final List<MediaFile> mediaFiles;
  final Function(MediaFile) onMediaSelected;

  const WheelOfFortuneDialog({
    super.key,
    required this.mediaFiles,
    required this.onMediaSelected,
  });

  @override
  State<WheelOfFortuneDialog> createState() => _WheelOfFortuneDialogState();
}

class _WheelOfFortuneDialogState extends State<WheelOfFortuneDialog>
    with SignalsMixin {
  final StreamController<int> _selected = StreamController<int>();
  late final Signal<int> _selectedIndex = createSignal(0);
  final _random = Random();

  @override
  void initState() {
    super.initState();
    if (widget.mediaFiles.isEmpty) return;
    _selectedIndex.value = _random.nextInt(widget.mediaFiles.length);
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _spinWheel();
      }
    });
  }

  @override
  void dispose() {
    _selected.close();
    super.dispose();
  }

  void _spinWheel() {
    _selectedIndex.value = _random.nextInt(widget.mediaFiles.length);
    // Add a short delay before adding to stream to allow the state to update
    Future.delayed(const Duration(milliseconds: 25), () {
      _selected.add(_selectedIndex.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mediaFiles.isEmpty) {
      return AlertDialog(
        content: const Text('No videos available to pick from.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      );
    }

    _selectedIndex.watch(context);
    final items = <FortuneItem>[
      for (var i = 0; i < widget.mediaFiles.length; i++)
        FortuneItem(
          style: FortuneItemStyle(
            color: HSLColor.fromAHSL(
              1.0,
              i * (360.0 / widget.mediaFiles.length),
              0.5,
              0.5,
            ).toColor(),
          ),
          child: Text(
            widget.mediaFiles[i].name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
    ];

    // Keep the wheel square but never larger than the available window, so it
    // doesn't overflow on small windows (this is a resizable desktop/web app).
    final screenSize = MediaQuery.of(context).size;
    final side = min(600.0, min(screenSize.width, screenSize.height) * 0.8);

    return AlertDialog(
      content: SizedBox(
        height: side,
        width: side,
        child: RepaintBoundary(
          child: FortuneWheel(
            selected: _selected.stream,
            animateFirst: false,
            items: items,
            rotationCount: 4,
            duration: const Duration(seconds: 2, milliseconds: 0),
            onAnimationEnd: () {
              Future.delayed(const Duration(milliseconds: 500), () {
                if (!context.mounted) return;
                Navigator.of(context).pop();
                widget.onMediaSelected(widget.mediaFiles[_selectedIndex.value]);
              });
            },
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
