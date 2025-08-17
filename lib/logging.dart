import 'dart:async';
import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

class LogEntry {
  final LogLevel level;
  final String message;
  final DateTime timestamp;
  final StackTrace stackTrace;

  LogEntry(this.level, this.message, this.stackTrace)
    : timestamp = DateTime.now();

  @override
  String toString() {
    return '[${level.name.toUpperCase()}] ${timestamp.toIso8601String().substring(11, 23)}: $message';
  }
}

final _logStreamController = StreamController<LogEntry>.broadcast();

Stream<LogEntry> get logStream => _logStreamController.stream;

class Logger {
  static void debug(dynamic message) => _log(LogLevel.debug, message);
  static void info(dynamic message) => _log(LogLevel.info, message);
  static void warning(dynamic message) => _log(LogLevel.warning, message);
  static void error(dynamic message) => _log(LogLevel.error, message);

  static void _log(LogLevel level, dynamic message) {
    final entry = LogEntry(level, "$message", StackTrace.current);
    _logStreamController.add(entry);
    if (kDebugMode) {
      // Also print to console in debug mode for convenience
      print(entry.toString());
    }
  }
}
