import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/model/app_model.dart';

enum LogLevel { debug, info, warning, error }

class LogEntry {
  final LogLevel level;
  final String message;
  final DateTime timestamp;

  LogEntry(this.level, this.message) : timestamp = DateTime.now();

  @override
  String toString() {
    return '[${level.name.toUpperCase()}] ${timestamp.toIso8601String().substring(11, 23)}: $message';
  }
}

final _logStreamController = StreamController<LogEntry>.broadcast();

class Logger {
  static void debug(dynamic message) => _log(LogLevel.debug, message);
  static void info(dynamic message) => _log(LogLevel.info, message);
  static void warning(dynamic message) => _log(LogLevel.warning, message);
  static void error(dynamic message) => _log(LogLevel.error, message);

  static void _log(LogLevel level, dynamic message) {
    final entry = LogEntry(level, message.toString());
    _logStreamController.add(entry);
    if (kDebugMode) {
      // Also print to console in debug mode for convenience
      print(entry.toString());
    }
  }
}

// Shows the last 20 log messages
class LoggingPanel extends StatefulWidget {
  const LoggingPanel({super.key});

  @override
  State<LoggingPanel> createState() => _LoggingPanelState();
}

class _LoggingPanelState extends State<LoggingPanel> {
  final List<LogEntry> _logMessages = [];

  static const int _maxLogMessages = 20;
  StreamSubscription? _logSubscription;

  @override
  void initState() {
    super.initState();
    // Listen to the global log stream
    _logSubscription = _logStreamController.stream.listen((entry) {
      _addLogMessage(entry);
    });

    // Existing error and notification streams should now use the Logger
    final model = context.read<SyncopathyModel>();
    model.onError.listen((message) {
      Logger.error(message);
    });
    model.onNotification.listen((message) {
      Logger.info(message);
    });
  }

  @override
  void dispose() {
    _logSubscription?.cancel();
    super.dispose();
  }

  void _addLogMessage(LogEntry entry) {
    if (mounted) {
      setState(() {
        _logMessages.insert(0, entry);
        if (_logMessages.length > _maxLogMessages) {
          _logMessages.removeLast();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: Colors.grey, width: 1.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Logging', style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            Expanded(
              child: ListView.builder(
                reverse: true, // Show most recent at the bottom
                itemCount: _logMessages.length,
                itemBuilder: (context, index) {
                  final logEntry = _logMessages[index];

                  Color messageColor = switch (logEntry.level) {
                    LogLevel.debug => Colors.grey,
                    LogLevel.info => Colors.white,
                    LogLevel.warning => Colors.orange,
                    LogLevel.error => Colors.red,
                  };

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: SelectableText.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '[${logEntry.level.name.toUpperCase()}] ${logEntry.timestamp.toIso8601String().substring(11, 23)}: ',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: messageColor),
                          ),
                          TextSpan(
                            text: logEntry.message,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.white,
                                ), // Default color for the message
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
