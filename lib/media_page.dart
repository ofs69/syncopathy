import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/model/app_model.dart';
import 'package:syncopathy/media_library.dart';

class MediaPage extends StatefulWidget {
  const MediaPage({super.key});

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  Future<void> _openVideoFile() async {
    final model = context.read<SyncopathyModel>();

    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      final String? filePath = result.files.single.path;
      if (filePath != null) {
        await model.tryToOpenVideo(filePath);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<SyncopathyModel>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: MediaLibrary(
              mediaPaths: model.settings.mediaPaths,
              onVideoTapped: (v) =>
                  model.openVideoAndScript(v.videoPath, v.funscriptPath),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _openVideoFile,
                icon: const Icon(Icons.folder_open),
                label: const Text('Open Video'),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => model.closeVideo(),
                icon: const Icon(Icons.close),
                label: const Text('Close Video'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
