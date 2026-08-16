import 'dart:io';

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

  /// Why this entry is up for removal. Shown in [DeleteMediaDialog.databaseOnly]
  /// mode, where the caller picked the entries rather than the user.
  final String? reason;

  _FileEntry({required this.path, required this.isFunscript, this.reason});

  String get fileName => p.basename(path);
}

class DeleteMediaDialog extends SignalStatefulWidget {
  final Set<MediaFile> selectedMedia;

  /// Funscript records to drop alongside [selectedMedia]. Only honoured in
  /// [databaseOnly] mode, where the caller decides exactly which records go.
  final Set<FunscriptFile> selectedFunscripts;

  /// Removes nothing but the listed database records: no disk-deletion option,
  /// no funscripts pulled in via relations, and no reindex afterwards. The
  /// removal itself is left to [onConfirmed].
  final bool databaseOnly;

  /// Runs on confirm in [databaseOnly] mode, in place of the dialog's own
  /// removal, so the caller stays in charge of what a cleanup means.
  final Future<void> Function()? onConfirmed;

  final String? title;

  /// Extra line under the list, for anything being removed that has no file to
  /// show (orphaned records, for instance).
  final String? summary;

  const DeleteMediaDialog({
    super.key,
    required this.selectedMedia,
    this.selectedFunscripts = const {},
    this.databaseOnly = false,
    this.onConfirmed,
    this.title,
    this.summary,
  }) : assert(
         !databaseOnly || onConfirmed != null,
         'databaseOnly mode leaves the removal to onConfirmed',
       );

  @override
  State<DeleteMediaDialog> createState() => _DeleteMediaDialogState();
}

class _DeleteMediaDialogState extends State<DeleteMediaDialog> {
  late final List<_FileEntry> _entries;
  final Signal<bool> _deleteFromDisk = signal(false);
  final Signal<bool> _isDeleting = signal(false);

  @override
  void initState() {
    super.initState();
    _entries = _buildEntries();
  }

  @override
  void dispose() {
    _deleteFromDisk.dispose();
    _isDeleting.dispose();
    super.dispose();
  }

  List<_FileEntry> _buildEntries() {
    final entries = <_FileEntry>[];
    final seenPaths = <String>{};
    final selectedIds = widget.selectedMedia.map((m) => m.id).toSet();

    if (widget.databaseOnly) {
      for (final media in widget.selectedMedia) {
        if (seenPaths.add(media.mediaPath)) {
          entries.add(
            _FileEntry(
              path: media.mediaPath,
              isFunscript: false,
              reason: media.unplayableReason,
            ),
          );
        }
      }
      for (final script in widget.selectedFunscripts) {
        if (seenPaths.add(script.path)) {
          entries.add(
            _FileEntry(
              path: script.path,
              isFunscript: true,
              reason: script.fileNotFound
                  ? 'Funscript file not found.'
                  : 'Not linked to any media.',
            ),
          );
        }
      }
      return entries;
    }

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

    if (widget.databaseOnly) {
      await widget.onConfirmed!();
      if (mounted) Navigator.pop(context, true);
      return;
    }

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
      oBox.mediaRepository.remove(media.id);
    }

    getIt.get<MediaManager>().startIndexing();

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final deleteFromDisk = _deleteFromDisk.value;
    final isDeleting = _isDeleting.value;
    final count = widget.databaseOnly
        ? _entries.length
        : widget.selectedMedia.length;

    final screenSize = MediaQuery.of(context).size;
    final contentWidth = screenSize.width * 0.6;
    final contentHeight = screenSize.height * 0.6;

    return AlertDialog(
      title: Text(
        widget.title ?? 'Remove ${count == 1 ? '1 Item' : '$count Items'}?',
      ),
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
                            if (entry.reason != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                entry.reason!,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: colorScheme.error,
                                ),
                              ),
                            ],
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
            if (!widget.databaseOnly) ...[
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
            ],
            if (widget.summary != null) ...[
              Text(
                widget.summary!,
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 4),
            ],
            Text(
              widget.databaseOnly
                  ? 'Only these library entries are removed. Nothing is deleted from disk; anything that reappears in your search paths is picked up again on the next reindex.'
                  : deleteFromDisk
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
