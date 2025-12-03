import 'dart:io';

import 'package:flutter/material.dart';

import 'package:syncopathy/logging.dart';
import 'package:syncopathy/migration_service.dart';

enum MigrationResult { success, error, skipped }
enum MigrationStatus { pending, inProgress, success, error }

class MigrationScreen extends StatefulWidget {
  final ValueChanged<MigrationResult> onMigrationComplete;

  const MigrationScreen({super.key, required this.onMigrationComplete});

  @override
  State<MigrationScreen> createState() => _MigrationScreenState();
}

class _MigrationScreenState extends State<MigrationScreen> {
  MigrationStatus _status = MigrationStatus.pending;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Do not start migration automatically. Wait for user input.
  }

  Future<void> _startMigration() async {
    if (!mounted) return;
    setState(() {
      _status = MigrationStatus.inProgress;
    });

    try {
      await MigrationService().migrate();
      if (mounted) {
        setState(() {
          _status = MigrationStatus.success;
        });
        widget.onMigrationComplete(MigrationResult.success);
      }
    } catch (e, stacktrace) {
      Logger.error('Database migration failed: $e\n$stacktrace');
      if (mounted) {
        setState(() {
          _status = MigrationStatus.error;
          _errorMessage = e.toString();
        });
        widget.onMigrationComplete(MigrationResult.error);
      }
    }
  }

  void _skipMigration() {
    Logger.info('User skipped database migration.');
    widget.onMigrationComplete(MigrationResult.skipped);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTitle(),
              const SizedBox(height: 32),
              _buildContent(),
              const SizedBox(height: 32),
              if (_status == MigrationStatus.pending)
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: _startMigration,
                      child: const Text('Start Migration'),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: _skipMigration,
                      child: const Text('Skip Migration (Start with Clean Database)'),
                    ),
                  ],
                ),
              if (_status == MigrationStatus.error)
                ElevatedButton(
                  onPressed: () => exit(0),
                  child: const Text('Exit Application'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    switch (_status) {
      case MigrationStatus.pending:
        return const Text(
          'Database Migration Required',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        );
      case MigrationStatus.inProgress:
        return const Text(
          'Migrating Database',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        );
      case MigrationStatus.success:
        return const Text(
          'Migration Successful',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
        );
      case MigrationStatus.error:
        return const Text(
          'Migration Failed',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
        );
    }
  }

  Widget _buildContent() {
    switch (_status) {
      case MigrationStatus.pending:
        return const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'An older database format was detected. Would you like to migrate your existing data to the new format, or start with a fresh, empty database?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Note: If you want to migrate again after skipping or if you encounter issues, you will need to manually delete the "syncopathyDB.sqlite" database file. You can find the application data directory by going to the settings page and clicking "Open App Data Directory".',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        );
      case MigrationStatus.inProgress:
        return const Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Please wait, copying data from old database format...',
              textAlign: TextAlign.center,
            ),
          ],
        );
      case MigrationStatus.success:
        return const Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 64),
            SizedBox(height: 16),
            Text(
              'The database has been migrated successfully. The application will now restart.',
              textAlign: TextAlign.center,
            ),
          ],
        );
      case MigrationStatus.error:
        return Column(
          children: [
            const Icon(Icons.error, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            const Text(
              'An error occurred during migration. Please check the logs.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              child: Text(
                _errorMessage ?? 'No error details available.',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
    }
  }
}
