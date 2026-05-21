import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/migration_service.dart';

class MigrationModal extends StatefulWidget {
  const MigrationModal({super.key});

  @override
  State<MigrationModal> createState() => _MigrationModalState();
}

class _MigrationModalState extends State<MigrationModal> {
  final _migrationService = MigrationService();

  String _formatDuration(Duration? duration) {
    if (duration == null) return "";
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    if (minutes > 0) {
      return "ETA: ${minutes}m ${seconds}s";
    }
    return "ETA: ${seconds}s";
  }

  @override
  Widget build(BuildContext context) {
    final eta = _migrationService.eta.watch(context);
    final progress = _migrationService.progress.watch(context);
    final status = _migrationService.statusSignal.watch(context);
    final isMigrating = _migrationService.isMigrating.watch(context);
    final hasMigrated = _migrationService.hasMigrated.watch(context);

    return AlertDialog(
      title: const Text("Database Migration"),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMigrating && !hasMigrated)
              const Text(
                "The database needs to be migrated to the new format. "
                "This will re-hash your library and retrieve metadata.",
              ),
            if (isMigrating) ...[
              const SizedBox(height: 10),
              LinearProgressIndicator(value: progress),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      status,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (eta != null)
                    Text(
                      _formatDuration(eta),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ],
            if (hasMigrated)
              const Text(
                "Migration complete. You can now close this dialog.",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      actions: [
        if (!hasMigrated && !isMigrating)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
        if (!hasMigrated && !isMigrating)
          ElevatedButton(
            onPressed: () => _migrationService.migrate(),
            child: const Text("Start Migration"),
          ),
        if (hasMigrated)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
      ],
    );
  }
}
