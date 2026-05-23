import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

enum LogLevel { debug, info, warning, error }

class LogEntry {
  final LogLevel level;
  final String message;
  final DateTime timestamp;
  final StackTrace? stackTrace;
  final dynamic error;

  LogEntry(this.level, this.message, {this.error, this.stackTrace})
    : timestamp = DateTime.now();

  @override
  String toString() {
    final errStr = error != null ? '\nError: $error' : '';
    final stackStr = stackTrace != null ? '\nStacktrace: $stackTrace' : '';
    return '[${level.name.toUpperCase()}] ${timestamp.toIso8601String().substring(11, 23)}: $message$errStr$stackStr';
  }
}

abstract class LogSink {
  void log(LogEntry entry);
  Future<void> dispose() async {}
}

class ConsoleSink extends LogSink {
  @override
  void log(LogEntry entry) {
    if (kDebugMode) {
      print(entry.toString());
    }
  }
}

class RollingFileSink extends LogSink {
  final Directory directory;
  final String fileName;
  final int maxFileSize;
  final int maxFiles;

  File get logFile => File(path.join(directory.path, fileName));

  RollingFileSink({
    required this.directory,
    this.fileName = 'syncopathy.log',
    this.maxFileSize = 1024 * 1024 * 5, // 5MB
    this.maxFiles = 3,
  });

  @override
  void log(LogEntry entry) {
    _writeLog(entry.toString());
  }

  Future<void> _writeLog(String message) async {
    try {
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final file = logFile;
      if (await file.exists() && await file.length() > maxFileSize) {
        await _rollFiles();
      }

      await file.writeAsString(
        '$message\n',
        mode: FileMode.append,
        flush: true,
      );
    } catch (e) {
      debugPrint('Error writing to log file: $e');
    }
  }

  Future<void> _rollFiles() async {
    try {
      for (int i = maxFiles - 1; i >= 1; i--) {
        final oldFile = File(path.join(directory.path, '$fileName.$i'));
        if (await oldFile.exists()) {
          final nextFile = File(
            path.join(directory.path, '$fileName.${i + 1}'),
          );
          if (await nextFile.exists()) {
            await nextFile.delete();
          }
          await oldFile.rename(nextFile.path);
        }
      }
      final currentFile = logFile;
      if (await currentFile.exists()) {
        await currentFile.rename(path.join(directory.path, '$fileName.1'));
      }
    } catch (e) {
      debugPrint('Error rolling log files: $e');
    }
  }
}

final _logStreamController = StreamController<LogEntry>.broadcast();

Stream<LogEntry> get logStream => _logStreamController.stream;

class Logger {
  static final List<LogSink> _sinks = [ConsoleSink()];

  static void addSink(LogSink sink) {
    _sinks.add(sink);
  }

  static String? get logFilePath {
    final sink = _sinks.whereType<RollingFileSink>().firstOrNull;
    return sink?.logFile.path;
  }

  static void debug(dynamic message) => _log(LogLevel.debug, message);
  static void info(dynamic message) => _log(LogLevel.info, message);
  static void warning(dynamic message) => _log(LogLevel.warning, message);
  static void error(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _log(LogLevel.error, message, error: error, stackTrace: stackTrace);

  static void _log(
    LogLevel level,
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    final entry = LogEntry(
      level,
      "$message",
      error: error,
      stackTrace:
          stackTrace ?? (level == LogLevel.error ? StackTrace.current : null),
    );
    _logStreamController.add(entry);
    for (var sink in _sinks) {
      sink.log(entry);
    }
  }
}
