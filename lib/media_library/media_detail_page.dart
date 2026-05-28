import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as p;
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/funscript_algo.dart';
import 'package:syncopathy/helper/debouncer.dart';
import 'package:syncopathy/helper/effect_dispose_mixin.dart';
import 'package:syncopathy/helper/platform_utils.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/model/json/funscript_json.dart';
import 'package:syncopathy/model/settings_model.dart';
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
  late final Signal<FunscriptFile?> _mainFunscriptSignal;
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
    _mainFunscriptSignal = createSignal(widget.media.mainFunscript.target);
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
        _mainFunscriptSignal.value;
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
    widget.media.mainFunscript.target = _mainFunscriptSignal.value;

    oBox.funscriptService.saveMany(_funscriptsSignal.value);
    oBox.mediaService.save(widget.media);
  }

  bool _isPathInConfiguredMediaPaths(String filePath) {
    final settings = getIt.get<SettingsModel>();
    final configuredPaths = settings.mediaPaths.value;

    final canonFile = p.canonicalize(filePath);
    for (final configuredPath in configuredPaths) {
      if (p.isWithin(p.canonicalize(configuredPath), canonFile)) {
        return true;
      }
    }
    return false;
  }

  void _showPathWarning(String filePath) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'The selected file is outside of your configured media paths:\n$filePath',
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Future<({String path, String hash})?> _pickAndHashFile() async {
    final result = await FilePicker.pickFile(type: FileType.any);

    if (result != null && result.path != null) {
      final path = result.path!;

      if (!_isPathInConfiguredMediaPaths(path)) {
        _showPathWarning(path);
        return null;
      }

      final hash = await fastFileHash(
        File(path),
        cacheService: oBox.fastHashCacheService,
      );
      if (hash != null) {
        return (path: path, hash: hash);
      }
    }
    return null;
  }

  Future<FunscriptFile?> _loadFunscriptData(String path, String hash) async {
    try {
      final file = File(path);
      final jsonText = await file.readAsString();
      final json = FunscriptJson.fromJson(jsonDecode(jsonText));
      final actions = json.actions;

      return FunscriptFile(
        path: path,
        averageSpeed: FunscriptAlgorithms.averageSpeed(actions),
        averageMin: FunscriptAlgorithms.averageMin(actions),
        averageMax: FunscriptAlgorithms.averageMax(actions),
        isScriptToken: Funscript.isScriptToken(actions),
        fileNotFound: false,
        funscriptHash: hash,
        metadata: json.metadata,
      )..firstIndexedOn = DateTime.now();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading funscript: $e')));
      }
      return null;
    }
  }

  Future<void> _relocatePath() async {
    final picked = await _pickAndHashFile();
    if (picked != null) {
      final existing = oBox.mediaService.getByHash(picked.hash);
      if (existing != null && existing.id != widget.media.id) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Error: A media file with this hash already exists in the library.',
              ),
            ),
          );
        }
        return;
      }

      widget.media.fileHash = picked.hash;
      widget.media.fileNotFound = false;
      _pathSignal.value = picked.path;
    }
  }

  Future<void> _addFunscript() async {
    final picked = await _pickAndHashFile();
    if (picked == null) return;

    FunscriptFile? fs = oBox.funscriptService.getByHash(picked.hash);
    if (fs == null) {
      fs = await _loadFunscriptData(picked.path, picked.hash);
      if (fs == null) return;
      oBox.funscriptService.save(fs);
    }

    final fsToLink = fs;
    if (!_funscriptsSignal.any((f) => f.id == fsToLink.id)) {
      widget.media.funscripts.add(fsToLink);
      _funscriptsSignal.add(fsToLink);
    }
  }

  Future<void> _relocateFunscript(FunscriptFile oldFs) async {
    final picked = await _pickAndHashFile();
    if (picked == null) return;

    FunscriptFile? newFs = oBox.funscriptService.getByHash(picked.hash);

    if (newFs != null && newFs.id != oldFs.id) {
      // Found a different existing funscript with this hash.
      // Use it and update its path/status just in case.
      newFs.path = picked.path;
      newFs.fileNotFound = false;
      oBox.funscriptService.save(newFs);

      final isMain = _mainFunscriptSignal.value?.id == oldFs.id;

      widget.media.funscripts.remove(oldFs);
      if (!widget.media.funscripts.any((f) => f.id == newFs.id)) {
        widget.media.funscripts.add(newFs);
      }

      if (isMain) {
        _mainFunscriptSignal.value = newFs;
        widget.media.mainFunscript.target = newFs;
      }

      _funscriptsSignal.value = List.from(widget.media.funscripts);
    } else {
      // Either newFs is null or it's the same funscript (by ID).
      // Update the current instance (oldFs) to ensure UI correctly reflects changes.
      final FunscriptFile source;
      if (newFs == null) {
        final loaded = await _loadFunscriptData(picked.path, picked.hash);
        if (loaded == null) return;
        source = loaded;
      } else {
        source = newFs;
      }

      oldFs.path = picked.path;
      oldFs.funscriptHash = picked.hash;
      oldFs.averageSpeed = source.averageSpeed;
      oldFs.averageMin = source.averageMin;
      oldFs.averageMax = source.averageMax;
      oldFs.isScriptToken = source.isScriptToken;
      oldFs.metadata = source.metadata;
      oldFs.fileNotFound = false;

      oBox.funscriptService.save(oldFs);
      // Trigger UI update by assigning a new list
      _funscriptsSignal.value = List.from(_funscriptsSignal.value);

      // Force update of main funscript signal if this was the main one
      if (_mainFunscriptSignal.value?.id == oldFs.id) {
        _mainFunscriptSignal.value = null; // Reset to force trigger
        _mainFunscriptSignal.value = oldFs;
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
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: _addFunscript,
                          icon: const Icon(Icons.add_link),
                          label: const Text('Add Funscript File'),
                        ),
                      ],
                    ),
                    const Divider(height: 40),

                    _buildSectionTitle('Technical Information'),
                    Watch((context) => _buildTechnicalInfo()),
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
    final dateStr = widget.media.firstIndexedOn != null
        ? widget.media.firstIndexedOn!
              .toLocal()
              .toString()
              .split('.')
              .first // Remove microseconds
        : 'Unknown';

    final fileNotFound = widget.media.fileNotFound;
    final mainFs = _mainFunscriptSignal.value;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 120,
                    child: Text(
                      'File Path',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _pathSignal.value,
                      style: GoogleFonts.robotoMono().copyWith(
                        color: fileNotFound ? Colors.red : null,
                        decoration: fileNotFound
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (fileNotFound)
                    const Padding(
                      padding: EdgeInsets.only(right: 4.0),
                      child: Tooltip(
                        message: 'File not found',
                        child: Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange,
                          size: 20,
                        ),
                      ),
                    ),
                  IconButton(
                    icon: const Icon(Icons.open_in_new),
                    onPressed: fileNotFound
                        ? null
                        : () =>
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
            _buildInfoRow('File Hash', widget.media.fileHash),
            if (mainFs != null)
              _buildInfoRow('Funscript Hash', mainFs.funscriptHash),
            _buildInfoRow('Date Added', dateStr),
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
              style: GoogleFonts.robotoMono(),
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
            final isMain =
                _mainFunscriptSignal.value?.id == fs.id && fs.id != 0;
            return ListTile(
              leading: Icon(
                fs.fileNotFound
                    ? Icons.error_outline
                    : (isMain
                          ? Icons.star_rounded
                          : Icons.description_outlined),
                color: fs.fileNotFound
                    ? Colors.red
                    : (isMain ? Colors.amber : null),
              ),
              title: Text(
                fs.fileName,
                style: TextStyle(
                  color: fs.fileNotFound ? Colors.red : null,
                  decoration: fs.fileNotFound
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fs.path,
                    style: TextStyle(
                      color: fs.fileNotFound
                          ? Colors.red.withValues(alpha: 0.7)
                          : null,
                    ),
                  ),
                  Text(
                    'Hash: ${fs.funscriptHash}',
                    style: GoogleFonts.robotoMono(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (fs.fileNotFound)
                    const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Tooltip(
                        message: 'File not found',
                        child: Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange,
                          size: 20,
                        ),
                      ),
                    ),
                  if (isMain)
                    const Badge(label: Text('MAIN'))
                  else
                    TextButton(
                      onPressed: () {
                        _mainFunscriptSignal.value = fs;
                      },
                      child: const Text('Set Main'),
                    ),
                  IconButton(
                    icon: const Icon(Icons.open_in_new),
                    onPressed: fs.fileNotFound
                        ? null
                        : () => PlatformUtils.openFileExplorer(fs.path),
                    tooltip: 'Open in explorer',
                  ),
                  IconButton(
                    icon: const Icon(Icons.folder_open),
                    onPressed: () => _relocateFunscript(fs),
                    tooltip: 'Relocate',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      widget.media.funscripts.remove(fs);
                      _funscriptsSignal.remove(fs);
                      if (isMain) {
                        _mainFunscriptSignal.value = null;
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
