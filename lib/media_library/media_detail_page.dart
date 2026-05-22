import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/debouncer.dart';
import 'package:syncopathy/helper/effect_dispose_mixin.dart';
import 'package:syncopathy/helper/platform_utils.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/persistence/entities/funscript_file.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/persistence/entities/user_category.dart';
import 'package:syncopathy/persistence/fast_file_hash.dart';
import 'package:syncopathy/helper/constants.dart';

class MediaDetailPage extends StatefulWidget {
  final MediaFile media;
  const MediaDetailPage({super.key, required this.media});

  @override
  State<MediaDetailPage> createState() => _MediaDetailPageState();
}

class _MediaDetailPageState extends State<MediaDetailPage>
    with SignalsMixin, EffectDispose {
  late final TextEditingController _nameController;
  late final TextEditingController _aliasController;
  late final ListSignal<String> _tempAliases;
  late final Signal<int> _mainFunscriptId;
  late final Signal<String> _nameSignal;
  late final Signal<MediaRating> _ratingSignal;
  late final Signal<MediaType> _typeSignal;
  late final Signal<String> _pathSignal;
  late final ListSignal<FunscriptFile> _funscriptsSignal;
  late final ListSignal<UserCategory> _categoriesSignal;
  late final Debouncer _saveDebouncer;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.media.name);
    _nameSignal = createSignal(widget.media.name);
    _nameController.addListener(() {
      _nameSignal.value = _nameController.text;
    });

    _aliasController = TextEditingController();
    _tempAliases = createListSignal(List.from(widget.media.aliases));
    _mainFunscriptId = createSignal(widget.media.mainFunscript.targetId);
    _ratingSignal = createSignal(widget.media.rating ?? MediaRating.noRating);
    _typeSignal = createSignal(widget.media.type ?? MediaType.unknown);
    _pathSignal = createSignal(widget.media.mediaPath);
    _funscriptsSignal = createListSignal(List.from(widget.media.funscripts));
    _categoriesSignal = createListSignal(List.from(widget.media.categories));

    _saveDebouncer = Debouncer(milliseconds: 500);

    effectAdd([
      effect(() {
        _nameSignal.value;
        _tempAliases.value;
        _mainFunscriptId.value;
        _ratingSignal.value;
        _typeSignal.value;
        _pathSignal.value;
        _funscriptsSignal.value;
        _categoriesSignal.value;

        _saveDebouncer.run(_save);
      }),
    ]);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _aliasController.dispose();
    _saveDebouncer.dispose();
    effectDispose();
    super.dispose();
  }

  void _handleExit() {
    _save();
    Navigator.of(context).pop();
  }

  void _addAlias() {
    final val = _aliasController.text.trim();
    if (val.isNotEmpty && !_tempAliases.contains(val)) {
      _tempAliases.add(val);
      _aliasController.clear();
    }
  }

  void _save() {
    widget.media.name = _nameController.text.trim();
    widget.media.aliases = _tempAliases.value;
    widget.media.rating = _ratingSignal.value;
    widget.media.type = _typeSignal.value;
    widget.media.mediaPath = _pathSignal.value;

    oBox.mediaService.save(widget.media);
  }

  Future<void> _relocatePath() async {
    final result = await FilePicker.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      final newPath = result.files.single.path!;
      final newHash = await fastFileHash(
        File(newPath),
        cacheService: oBox.fastHashCacheService,
      );
      if (newHash != null) {
        widget.media.fileHash = newHash;
        widget.media.fileNotFound = false;
        _pathSignal.value = newPath;
      }
    }
  }

  Future<void> _addFunscript() async {
    final result = await FilePicker.pickFiles(
      type: FileType.any,
      allowMultiple: true,
    );

    if (result != null) {
      for (final file in result.files) {
        if (file.path == null) continue;
        final hash = await fastFileHash(
          File(file.path!),
          cacheService: oBox.fastHashCacheService,
        );
        final newFs = FunscriptFile(
          path: file.path!,
          averageSpeed: 0,
          averageMin: 0,
          averageMax: 0,
          isScriptToken: false,
          fileNotFound: false,
          funscriptHash: hash,
        );
        widget.media.funscripts.add(newFs);
        _funscriptsSignal.add(newFs);
      }
    }
  }

  void _toggleCategory(UserCategory category) {
    if (widget.media.categories.any((c) => c.id == category.id)) {
      widget.media.categories.removeWhere((c) => c.id == category.id);
      _categoriesSignal.removeWhere((c) => c.id == category.id);
    } else {
      widget.media.categories.add(category);
      _categoriesSignal.add(category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.escape): _handleExit,
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: _handleExit,
              tooltip: 'Back (Esc)',
            ),
            title: Watch((context) => Text('Editing ${_nameSignal.value}')),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('General Information'),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Media Name',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.title),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Watch((context) {
                          return SegmentedButton<MediaType>(
                            segments: const [
                              ButtonSegment(
                                value: MediaType.video,
                                icon: Icon(Icons.movie_outlined),
                                label: Text('Video'),
                              ),
                              ButtonSegment(
                                value: MediaType.audio,
                                icon: Icon(Icons.audiotrack_outlined),
                                label: Text('Audio'),
                              ),
                            ],
                            selected: {_typeSignal.value},
                            onSelectionChanged: (val) {
                              _typeSignal.value = val.first;
                            },
                          );
                        }),
                        const SizedBox(width: 16),
                        Watch((context) {
                          return SegmentedButton<MediaRating>(
                            segments: [
                              ButtonSegment(
                                value: MediaRating.like,
                                icon: Icon(
                                  _ratingSignal.value == MediaRating.like
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: _ratingSignal.value == MediaRating.like
                                      ? favoriteColor
                                      : null,
                                ),
                                label: const Text('Favorite'),
                              ),
                              ButtonSegment(
                                value: MediaRating.dislike,
                                icon: Icon(
                                  _ratingSignal.value == MediaRating.dislike
                                      ? Icons.thumb_down
                                      : Icons.thumb_down_outlined,
                                  color:
                                      _ratingSignal.value == MediaRating.dislike
                                      ? dislikeColor
                                      : null,
                                ),
                                label: const Text('Dislike'),
                              ),
                            ],
                            selected: {_ratingSignal.value},
                            onSelectionChanged: (val) {
                              if (val.isEmpty) {
                                _ratingSignal.value = MediaRating.noRating;
                              } else {
                                _ratingSignal.value = val.first;
                              }
                            },
                            emptySelectionAllowed: true,
                            showSelectedIcon: false,
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 20),

                    _buildSectionTitle('Categories'),
                    _buildCategoryChips(),
                    const Divider(height: 40),

                    _buildSectionTitle('Aliases'),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _aliasController,
                            decoration: const InputDecoration(
                              hintText: 'Add new alias...',
                              border: OutlineInputBorder(),
                            ),
                            onSubmitted: (_) => _addAlias(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filledTonal(
                          onPressed: _addAlias,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Watch((context) {
                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _tempAliases.map((alias) {
                          return GestureDetector(
                            onTap: () {
                              _aliasController.text = alias;
                            },
                            child: Chip(
                              label: Text(alias),
                              onDeleted: () => _tempAliases.remove(alias),
                            ),
                          );
                        }).toList(),
                      );
                    }),
                    const Divider(height: 40),

                    _buildSectionTitle('Funscripts'),
                    _buildFunscriptList(),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: _addFunscript,
                      icon: const Icon(Icons.add_link),
                      label: const Text('Add Funscript File'),
                    ),
                    const Divider(height: 40),

                    _buildSectionTitle('Technical Information'),
                    _buildTechnicalInfo(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    final allCategories = oBox.userCategoryService.getAllUserCategories();
    return Watch((context) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: allCategories.map((cat) {
          final isSelected = _categoriesSignal.any((c) => c.id == cat.id);
          return FilterChip(
            label: Text(cat.name),
            selected: isSelected,
            onSelected: (_) => _toggleCategory(cat),
          );
        }).toList(),
      );
    });
  }

  Widget _buildTechnicalInfo() {
    final meta = widget.media.metadata.target;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow(
              'File Path',
              _pathSignal.value,
              action: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.open_in_new),
                    onPressed: () =>
                        PlatformUtils.openFileExplorer(_pathSignal.value),
                    tooltip: 'Open in explorer',
                  ),
                  IconButton(
                    icon: const Icon(Icons.folder_open),
                    onPressed: _relocatePath,
                    tooltip: 'Relocate',
                  ),
                ],
              ),
            ),
            _buildInfoRow('File Hash', widget.media.fileHash ?? 'Unknown'),
            _buildInfoRow('Play Count', widget.media.playCount.toString()),
            if (meta != null) ...[
              const Divider(),
              _buildInfoRow(
                'Resolution',
                '${meta.width ?? 0}x${meta.height ?? 0}',
              ),
              _buildInfoRow('Duration', '${meta.duration.toStringAsFixed(2)}s'),
              _buildInfoRow('Video Codec', meta.videoCodec ?? 'Unknown'),
              _buildInfoRow('Audio Codec', meta.audioCodec ?? 'Unknown'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Widget? action}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontFamily: 'monospace'),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ?action,
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFunscriptList() {
    return Watch((context) {
      final allScripts = _funscriptsSignal.value;
      if (allScripts.isEmpty) {
        return const Text(
          'No funscripts attached.',
          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
        );
      }

      return Card(
        child: Column(
          children: allScripts.map((fs) {
            final isMain = _mainFunscriptId.value == fs.id;
            return ListTile(
              leading: Icon(
                isMain ? Icons.star_rounded : Icons.description_outlined,
                color: isMain ? Colors.amber : null,
              ),
              title: Text(fs.fileName),
              subtitle: Text(fs.path),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isMain)
                    const Badge(label: Text('MAIN'))
                  else
                    TextButton(
                      onPressed: () {
                        widget.media.mainFunscript.target = fs;
                        _mainFunscriptId.value = fs.id;
                      },
                      child: const Text('Set Main'),
                    ),
                  IconButton(
                    icon: const Icon(Icons.open_in_new),
                    onPressed: () => PlatformUtils.openFileExplorer(fs.path),
                    tooltip: 'Open in explorer',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      widget.media.funscripts.remove(fs);
                      _funscriptsSignal.remove(fs);
                      if (isMain) {
                        widget.media.mainFunscript.target = null;
                        _mainFunscriptId.value = 0;
                      }
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    });
  }
}
