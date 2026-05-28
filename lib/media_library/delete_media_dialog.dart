import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/ioc.dart' show getIt, oBox;
import 'package:syncopathy/media_library/media_manager.dart';
import 'package:syncopathy/notification_feed.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

class _FileEntry {
  final String path;
  final bool isFunscript;

  _FileEntry({required this.path, required this.isFunscript});

  String get fileName => p.basename(path);
}

class DeleteMediaDialog extends StatefulWidget {
  final Set<MediaFile> selectedMedia;

  const DeleteMediaDialog({super.key, required this.selectedMedia});

  @override
  State<DeleteMediaDialog> createState() => _DeleteMediaDialogState();
}

class _DeleteMediaDialogState extends State<DeleteMediaDialog>
    with SignalsMixin {
  late final List<_FileEntry> _entries;
  late final Signal<bool> _deleteFromDisk = createSignal(false);
  late final Signal<bool> _isDeleting = createSignal(false);

  @override
  void initState() {
    super.initState();
    _entries = _buildEntries();
  }

  List<_FileEntry> _buildEntries() {
    final entries = <_FileEntry>[];
    final seenPaths = <String>{};
    final selectedIds = widget.selectedMedia.map((m) => m.id).toSet();

    for (final media in widget.selectedMedia) {
      if (seenPaths.add(media.mediaPath)) {
        entries.add(_FileEntry(path: media.mediaPath, isFunscript: false));
      }
      for (final script in media.funscripts) {
        // Omit funscripts shared with media outside the selection
        final sharedWithOthers = script.media.any(
          (m) => !selectedIds.contains(m.id),
        );
        if (sharedWithOthers) continue;
        if (seenPaths.add(script.path)) {
          entries.add(_FileEntry(path: script.path, isFunscript: true));
        }
      }
    }

    return entries;
  }

  Future<void> _delete() async {
    _isDeleting.value = true;

    if (_deleteFromDisk.value) {
      final selectedIds = widget.selectedMedia.map((m) => m.id).toSet();
      for (final media in widget.selectedMedia) {
        try {
          final file = File(media.mediaPath);
          if (await file.exists()) await file.delete();
          for (final script in media.funscripts) {
            final sharedWithOthers = script.media.any(
              (m) => !selectedIds.contains(m.id),
            );
            if (sharedWithOthers) continue;
            final scriptFile = File(script.path);
            if (await scriptFile.exists()) await scriptFile.delete();
          }
        } catch (e) {
          AlertManager.showError(
            'Failed to delete files for ${media.name}: $e',
          );
        }
      }
    }

    for (final media in widget.selectedMedia) {
      oBox.mediaService.remove(media.id);
    }

    getIt.get<MediaManager>().startIndexing();

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final deleteFromDisk = _deleteFromDisk.watch(context);
    final isDeleting = _isDeleting.watch(context);
    final count = widget.selectedMedia.length;

    return AlertDialog(
      title: Text('Remove ${count == 1 ? '1 Item' : '$count Items'}?'),
      content: SizedBox(
        width: 520,
        height: 420,
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
                      return ListTile(
                        contentPadding: const EdgeInsets.only(
                          left: 16,
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
            const SizedBox(height: 12),
            CheckboxListTile(
              value: deleteFromDisk,
              onChanged: isDeleting
                  ? null
                  : (v) => _deleteFromDisk.value = v ?? false,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: const Text('Delete files from disk'),
            ),
            const SizedBox(height: 4),
            Text(
              deleteFromDisk
                  ? 'Files will be permanently deleted. The library will be reindexed after removal.'
                  : 'Files kept on disk will be re-discovered on the next reindex if they remain in your search paths.',
              style: TextStyle(
                fontSize: 11,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isDeleting ? null : () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.error,
            foregroundColor: colorScheme.onError,
          ),
          onPressed: isDeleting ? null : _delete,
          child: isDeleting
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.onError,
                  ),
                )
              : const Text('Remove'),
        ),
      ],
    );
  }
}
