import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

class MediaDetailPage extends StatefulWidget {
  final MediaFile media;
  const MediaDetailPage({super.key, required this.media});

  @override
  State<MediaDetailPage> createState() => _MediaDetailPageState();
}

class _MediaDetailPageState extends State<MediaDetailPage> {
  late TextEditingController _nameController;
  late TextEditingController _aliasController;
  late List<String> _tempAliases;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.media.name);
    _aliasController = TextEditingController();
    _tempAliases = List.from(widget.media.aliases);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _aliasController.dispose();
    super.dispose();
  }

  void _handleExit() {
    Navigator.of(context).pop();
  }

  void _addAlias() {
    final val = _aliasController.text.trim();
    if (val.isNotEmpty && !_tempAliases.contains(val)) {
      setState(() {
        _tempAliases.add(val);
        _aliasController.clear();
      });
    }
  }

  void _saveChanges() {
    setState(() {
      widget.media.name = _nameController.text.trim();
      widget.media.aliases = _tempAliases;
      // Note: Call your ObjectBox box.put(widget.media) here or in the parent
    });
    _handleExit();
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
            title: Text('Editing ${widget.media.name}'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: FilledButton.icon(
                  onPressed: _saveChanges,
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('Save'),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('General Information'),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Media Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.title),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Path Section
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('File Path'),
                      subtitle: Text(widget.media.mediaPath),
                      trailing: OutlinedButton(
                        onPressed: () {
                          /* TODO: Reassign Path */
                        },
                        child: const Text('Relocate'),
                      ),
                    ),
                    const Divider(height: 40),

                    _buildSectionTitle('Search Aliases'),
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
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _tempAliases.map((alias) {
                        return Chip(
                          label: Text(alias),
                          onDeleted: () =>
                              setState(() => _tempAliases.remove(alias)),
                        );
                      }).toList(),
                    ),
                    const Divider(height: 40),

                    _buildSectionTitle('Funscripts'),
                    _buildFunscriptList(),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () {
                        /* TODO: Add Funscript Logic */
                      },
                      icon: const Icon(Icons.add_link),
                      label: const Text('Add Funscript File'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
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
    final allScripts = widget.media.funscripts;
    if (allScripts.isEmpty) {
      return const Text(
        'No funscripts attached.',
        style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
      );
    }

    return Card(
      child: Column(
        children: allScripts.map((fs) {
          final isMain = widget.media.mainFunscript.targetId == fs.id;
          return ListTile(
            leading: Icon(
              isMain ? Icons.star_rounded : Icons.description_outlined,
              color: isMain ? Colors.amber : null,
            ),
            title: Text(fs.fileName),
            subtitle: Text(fs.path),
            trailing: isMain
                ? const Badge(label: Text('MAIN'))
                : TextButton(
                    onPressed: () {
                      setState(() => widget.media.mainFunscript.target = fs);
                    },
                    child: const Text('Set Main'),
                  ),
          );
        }).toList(),
      ),
    );
  }
}
