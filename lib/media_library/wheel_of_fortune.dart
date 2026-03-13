import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
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

class _WheelOfFortuneDialogState extends State<WheelOfFortuneDialog> {
  final StreamController<int> _selected = StreamController<int>();
  late int _selectedIndex;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _selectedIndex = _random.nextInt(widget.mediaFiles.length);
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
    setState(() {
      _selectedIndex = _random.nextInt(widget.mediaFiles.length);
    });
    // Add a short delay before adding to stream to allow the state to update
    Future.delayed(const Duration(milliseconds: 25), () {
      _selected.add(_selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
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

    return AlertDialog(
      content: SizedBox(
        height: 600,
        width: 600,
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
              widget.onMediaSelected(widget.mediaFiles[_selectedIndex]);
            });
          },
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
