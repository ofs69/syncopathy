import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:syncopathy/sqlite/models/video_model.dart';

class WheelOfFortuneDialog extends StatefulWidget {
  final List<Video> videos;
  final Function(Video) onVideoSelected;

  const WheelOfFortuneDialog({
    super.key,
    required this.videos,
    required this.onVideoSelected,
  });

  @override
  State<WheelOfFortuneDialog> createState() => _WheelOfFortuneDialogState();
}

class _WheelOfFortuneDialogState extends State<WheelOfFortuneDialog> {
  final StreamController<int> _selected = StreamController<int>();
  late int _selectedIndex;
  bool _isSpinning = false;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _selectedIndex = _random.nextInt(widget.videos.length);
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
      _isSpinning = true;
      _selectedIndex = _random.nextInt(widget.videos.length);
    });
    // Add a short delay before adding to stream to allow the state to update
    Future.delayed(const Duration(milliseconds: 25), () {
      _selected.add(_selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = <FortuneItem>[
      for (var i = 0; i < widget.videos.length; i++)
        FortuneItem(
          style: FortuneItemStyle(
            color: HSLColor.fromAHSL(
              1.0,
              i * (360.0 / widget.videos.length),
              0.5,
              0.5,
            ).toColor(),
          ),
          child: Text(
            widget.videos[i].title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
    ];

    return AlertDialog(
      title: const Center(child: Text('Spin the Wheel!')),
      content: SizedBox(
        height: 600,
        width: 600,
        child: FortuneWheel(
          selected: _selected.stream,
          animateFirst: false,
          items: items,
          duration: const Duration(seconds: 1, milliseconds: 0),
          onAnimationEnd: () {
            Future.delayed(const Duration(milliseconds: 500), () {
              if (!mounted) return;
              setState(() => _isSpinning = false);
              if (!context.mounted) return; // Additional check
              Navigator.of(context).pop();
              widget.onVideoSelected(widget.videos[_selectedIndex]);
            });
          },
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        FilledButton.icon(
          icon: const Icon(Icons.casino),
          label: const Text('Spin'),
          onPressed: _isSpinning ? null : _spinWheel,
        ),
      ],
    );
  }
}
