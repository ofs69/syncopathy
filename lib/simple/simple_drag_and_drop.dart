import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/helper/extensions.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/simple/stub.dart'
    if (dart.library.js_interop) 'package:syncopathy/simple/web.dart'
    if (dart.library.io) 'package:syncopathy/simple/native.dart';

class SimpleModeDragAndDrop extends StatefulWidget {
  final Widget child;
  const SimpleModeDragAndDrop({super.key, required this.child});
  @override
  State<SimpleModeDragAndDrop> createState() => _SimpleModeDragAndDropState();
}

class _SimpleModeDragAndDropState extends State<SimpleModeDragAndDrop> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    if (!syncopathySimpleMode) return widget.child;

    return DropTarget(
      onDragEntered: (details) => setState(() => _isDragging = true),
      onDragExited: (details) => setState(() => _isDragging = false),
      onDragDone: (details) {
        setState(() => _isDragging = false);
        _handleFiles(details.files);
      },
      child: Stack(children: [widget.child, if (_isDragging) _buildOverlay()]),
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
        await SimpleMode.openFile(
          playerModel,
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
