import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/helper/extensions.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/model/player_model.dart';

class WebDragAndDrop extends StatefulWidget {
  final Widget child;
  const WebDragAndDrop({super.key, required this.child});
  @override
  State<WebDragAndDrop> createState() => _WebDragAndDropState();
}

class _WebDragAndDropState extends State<WebDragAndDrop> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragEntered: (details) => setState(() => _isDragging = true),
      onDragExited: (details) => setState(() => _isDragging = false),
      onDragDone: (details) {
        setState(() => _isDragging = false);
        _handleFiles(details.files);
      },
      child: Stack(
        children: [
          widget.child, // Your main app UI
          if (_isDragging) _buildOverlay(),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    return Container(
      color: Colors.black.withAlphaF(0.2), // Dim the background
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 3,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.play_arrow,
                size: 64,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              SizedBox(height: 16),
              Text(
                "Drop files here to load them",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFiles(List<DropItem> files) async {
    if (files.length > 2) return;
    final playerModel = context.read<PlayerModel>();

    try {
      for (var file in files) {
        playerModel.openFile(
          file.name,
          file.path,
          file.mimeType,
          () => file.readAsString(),
        );
      }
    } catch (e) {
      Logger.error(e.toString());
    }
  }
}
