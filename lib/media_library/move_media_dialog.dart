import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/ioc.dart' show getIt, oBox;
import 'package:syncopathy/media_library/media_manager.dart';
import 'package:syncopathy/notification_feed.dart';
import 'package:syncopathy/persistence/entities/funscript_file.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

class _FileEntry {
  final String path;
  final bool isFunscript;
  final Signal<bool> selected = signal(true);
  final MediaFile? mediaFile;
  final FunscriptFile? funscriptFile;

  _FileEntry({
    required this.path,
    required this.isFunscript,
    this.mediaFile,
    this.funscriptFile,
  });

  String get fileName => p.basename(path);
}

class MoveMediaDialog extends StatefulWidget {
  final Set<MediaFile> selectedMedia;
  final List<String> searchPaths;

  const MoveMediaDialog({
    super.key,
    required this.selectedMedia,
    required this.searchPaths,
  });

  @override
  State<MoveMediaDialog> createState() => _MoveMediaDialogState();
}

class _MoveMediaDialogState extends State<MoveMediaDialog> with SignalsMixin {
  late final List<_FileEntry> _entries;
  late final Signal<String?> _destinationDir = createSignal(null);
  late final Signal<bool> _isMoving = createSignal(false);

  @override
  void initState() {
    super.initState();
    _entries = _buildEntries();
  }

  List<_FileEntry> _buildEntries() {
    final entries = <_FileEntry>[];
    final seenPaths = <String>{};

    for (final media in widget.selectedMedia) {
      if (seenPaths.add(media.mediaPath)) {
        entries.add(
          _FileEntry(
            path: media.mediaPath,
            isFunscript: false,
            mediaFile: media,
          ),
        );
      }
      for (final script in media.funscripts) {
        if (seenPaths.add(script.path)) {
          entries.add(
            _FileEntry(
              path: script.path,
              isFunscript: true,
              funscriptFile: script,
            ),
          );
        }
      }
    }

    return entries;
  }

  Future<void> _pickDirectory() async {
    final dir = await FilePicker.getDirectoryPath();
    if (dir != null && mounted) {
      _destinationDir.value = dir;
    }
  }

  Future<void> _move() async {
    final dest = _destinationDir.value;
    if (dest == null) return;
    _isMoving.value = true;

    for (final entry in _entries.where((e) => e.selected.value)) {
      final newPath = p.join(dest, p.basename(entry.path));
      try {
        final src = File(entry.path);
        if (!await src.exists()) continue;
        try {
          await src.rename(newPath);
        } catch (_) {
          await src.copy(newPath);
          await src.delete();
        }
        final inSearchPaths = widget.searchPaths.any(
          (sp) => p.isWithin(sp, newPath),
        );
        if (inSearchPaths) {
          if (entry.mediaFile != null) {
            entry.mediaFile!.mediaPath = newPath;
            oBox.mediaRepository.save(entry.mediaFile!);
          } else if (entry.funscriptFile != null) {
            entry.funscriptFile!.path = newPath;
            oBox.mediaRepository.saveFunscript(entry.funscriptFile!);
          }
        } else {
          if (entry.mediaFile != null) {
            entry.mediaFile!.fileNotFound = true;
            oBox.mediaRepository.save(entry.mediaFile!);
          } else if (entry.funscriptFile != null) {
            entry.funscriptFile!.fileNotFound = true;
            oBox.mediaRepository.saveFunscript(entry.funscriptFile!);
          }
        }
      } catch (e) {
        AlertManager.showError('Failed to move ${entry.fileName}: $e');
      }
    }

    getIt.get<MediaManager>().startIndexing();

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dest = _destinationDir.watch(context);
    final isMoving = _isMoving.watch(context);
    final anySelected = _entries.any((e) => e.selected.watch(context));
    final canMove = dest != null && anySelected && !isMoving;

    final screenSize = MediaQuery.of(context).size;
    final contentWidth = screenSize.width * 0.6;
    final contentHeight = screenSize.height * 0.6;

    return AlertDialog(
      title: const Text('Move Files'),
      content: SizedBox(
        width: contentWidth,
        height: contentHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Material(
                  color: colorScheme.surfaceContainerLow,
                  child: ListView.separated(
                    itemCount: _entries.length,
                    separatorBuilder: (_, _) =>
                        const Divider(height: 1, indent: 16, endIndent: 16),
                    itemBuilder: (context, i) {
                      final entry = _entries[i];
                      return CheckboxListTile(
                        value: entry.selected.watch(context),
                        onChanged: isMoving
                            ? null
                            : (v) => entry.selected.value = v ?? false,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: const EdgeInsets.only(
                          left: 8,
                          right: 12,
                          top: 2,
                          bottom: 2,
                        ),
                        dense: true,
                        title: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: entry.isFunscript
                                    ? colorScheme.tertiaryContainer
                                    : colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                entry.isFunscript ? 'Script' : 'Media',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: entry.isFunscript
                                      ? colorScheme.onTertiaryContainer
                                      : colorScheme.onSecondaryContainer,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                entry.fileName,
                                style: const TextStyle(fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            entry.path,
                            style: TextStyle(
                              fontSize: 11,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The library will be reindexed after moving to update file locations.',
              style: TextStyle(
                fontSize: 11,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    dest ?? 'No destination selected',
                    style: TextStyle(
                      fontSize: 12,
                      color: dest != null
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.tonalIcon(
                  onPressed: isMoving ? null : _pickDirectory,
                  icon: const Icon(Icons.folder_open, size: 18),
                  label: const Text('Choose'),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isMoving ? null : () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: canMove ? _move : null,
          child: isMoving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Move'),
        ),
      ],
    );
  }
}
