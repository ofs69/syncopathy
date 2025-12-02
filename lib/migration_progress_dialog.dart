
import 'package:flutter/material.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/migration_service.dart';

enum MigrationStatus { inProgress, success, error }

class MigrationProgressDialog extends StatefulWidget {
  const MigrationProgressDialog({super.key});

  @override
  State<MigrationProgressDialog> createState() =>
      _MigrationProgressDialogState();
}

class _MigrationProgressDialogState extends State<MigrationProgressDialog> {
  MigrationStatus _status = MigrationStatus.inProgress;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startMigration();
  }

  Future<void> _startMigration() async {
    try {
      await MigrationService().migrate();
      if (mounted) {
        setState(() {
          _status = MigrationStatus.success;
        });
      }
    } catch (e, stacktrace) {
      Logger.error('Database migration failed: $e\n$stacktrace');
      if (mounted) {
        setState(() {
          _status = MigrationStatus.error;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(),
      content: _buildContent(),
      actions: [
        if (_status != MigrationStatus.inProgress)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
      ],
    );
  }

  Widget _buildTitle() {
    switch (_status) {
      case MigrationStatus.inProgress:
        return const Text('Migrating Database');
      case MigrationStatus.success:
        return const Text('Migration Successful');
      case MigrationStatus.error:
        return const Text('Migration Failed');
    }
  }

  Widget _buildContent() {
    switch (_status) {
      case MigrationStatus.inProgress:
        return const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Please wait, copying data...'),
          ],
        );
      case MigrationStatus.success:
        return const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 48),
            SizedBox(height: 16),
            Text('The database has been migrated successfully.'),
          ],
        );
      case MigrationStatus.error:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            const Text(
                'An error occurred during migration. See details below:'),
            const SizedBox(height: 8),
            SingleChildScrollView(
              child: Text(
                _errorMessage ?? 'No error details available.',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        );
    }
  }
}
