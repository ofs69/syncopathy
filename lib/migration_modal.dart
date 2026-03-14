import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/platform_utils.dart';
import 'package:syncopathy/migration_service.dart';

class MigrationModal extends StatefulWidget {
  const MigrationModal({super.key});

  @override
  State<MigrationModal> createState() => _MigrationModalState();
}

class _MigrationModalState extends State<MigrationModal> {
  bool _isMigrating = false;
  bool _hasMigrated = false;
  final _migrationService = MigrationService();

  @override
  Widget build(BuildContext context) {
    final duplicateVideos = _migrationService.duplicateVideos
        .watch(context)
        .toList();
    return AlertDialog(
      title: const Text("Database Migration"),
      content: SizedBox(
        width: double
            .maxFinite, // Ensures the modal doesn't horizontal-jitter either
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!_isMigrating && !_hasMigrated)
              Align(
                alignment: AlignmentGeometry.topLeft,
                child: const Text(
                  "The database needs to be migrated.\n"
                  "This may take a while.",
                ),
              ),
            if (_isMigrating)
              LinearProgressIndicator(
                value: _migrationService.progress.watch(context),
              ),
            if (_isMigrating)
              Align(
                alignment: AlignmentGeometry.topLeft,
                child: Text(_migrationService.statusSignal.watch(context)),
              ),
            if (_hasMigrated) const Text("Migration complete."),

            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: duplicateVideos.length,
                itemBuilder: (context, outerIndex) {
                  return ExpansionTile(
                    title: Text('Duplicate files ${outerIndex + 1}'),
                    children: duplicateVideos[outerIndex].map((item) {
                      return ListTile(
                        title: Text(item.videoPath),
                        leading: const Icon(Icons.arrow_right),
                        onTap: () async {
                          await PlatformUtils.openFileExplorer(item.videoPath);
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      actions: [
        Row(
          children: [
            if (!_hasMigrated && !_isMigrating)
              TextButton(
                onPressed: () => Navigator.of(context).pop(), // do nothing
                child: const Text("Don't migrate"),
              ),
            if (!_hasMigrated && !_isMigrating) const Spacer(),

            if (!_hasMigrated && !_isMigrating)
              TextButton(
                onPressed: () async {
                  if (_isMigrating || _hasMigrated) return;
                  setState(() {
                    _isMigrating = true;
                  });
                  await _migrationService.migrate();
                  setState(() {
                    _isMigrating = false;
                    _hasMigrated = true;
                  });
                },
                child: const Text("Migrate"),
              ),
            if (_hasMigrated)
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Close"),
              ),
          ],
        ),
      ],
    );
  }
}
