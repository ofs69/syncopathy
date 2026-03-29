import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

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

  String toFileString() {
    return '${timestamp.toIso8601String()} [${level.name.toUpperCase()}] $message\n${stackTrace.toString()}\n';
  }
}

final _logStreamController = StreamController<LogEntry>.broadcast();

Stream<LogEntry> get logStream => _logStreamController.stream;

class Logger {
  static File? _logFile;
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    try {
      final dir = await getApplicationSupportDirectory();
      _logFile = File(p.join(dir.path, 'syncopathy.log'));
      
      // Clear log if it gets too large (5MB)
      if (await _logFile!.exists() && await _logFile!.length() > 5 * 1024 * 1024) {
        await _logFile!.writeAsString('');
      }
      
      _initialized = true;
      info('Logging initialized at ${_logFile!.path}');
    } catch (e) {
      debugPrint('Failed to initialize file logging: $e');
    }
  }

  static void debug(dynamic message) => _log(LogLevel.debug, message);
  static void info(dynamic message) => _log(LogLevel.info, message);
  static void warning(dynamic message) => _log(LogLevel.warning, message);
  static void error(dynamic message, [dynamic error, StackTrace? stack]) =>
      _log(LogLevel.error, error != null ? "$message: $error" : message, stack);

  static void _log(LogLevel level, dynamic message, [StackTrace? stack]) {
    final entry = LogEntry(level, "$message", stack ?? StackTrace.current);
    _logStreamController.add(entry);
    
    if (kDebugMode) {
      // Also print to console in debug mode for convenience
      print(entry.toString());
    }

    _logToFile(entry);
  }

  static void _logToFile(LogEntry entry) async {
    if (!_initialized || _logFile == null) return;
    try {
      await _logFile!.writeAsString(
        entry.toFileString(),
        mode: FileMode.append,
        flush: true,
      );
    } catch (e) {
      debugPrint('Error writing to log file: $e');
    }
  }

  static Future<String?> getLogPath() async {
    if (!_initialized) await init();
    return _logFile?.path;
  }
}
