import 'package:google_fonts/google_fonts.dart';
import 'package:signals/signals_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/logging.dart';
import 'package:uuid/uuid.dart';

class AlertMessage {
  final String id;
  final String message;
  final LogLevel level;
  final StackTrace stackTrace;
  final DateTime timestamp;
  bool isRead;

  AlertMessage({
    required this.message,
    required this.level,
    required this.stackTrace,
  }) : id = const Uuid().v4(),
       timestamp = DateTime.now(),
       isRead = false;
}

class AlertManager extends ChangeNotifier {
  static const int _maxAlerts = 50;
  final List<AlertMessage> _alerts = [];
  final Signal<int> unreadCount = signal(0);

  List<AlertMessage> get alerts => _alerts;

  void addAlert(String message, LogLevel level, [StackTrace? trace]) {
    switch (level) {
      case LogLevel.error:
        Logger.error(message, null, trace);
      case LogLevel.warning:
        Logger.warning(message);
      case LogLevel.info:
        Logger.info(message);
      case LogLevel.debug:
        Logger.debug(message);
    }

    final alert = AlertMessage(
      message: message,
      level: level,
      stackTrace: trace ?? StackTrace.empty,
    );

    if (_alerts.length >= _maxAlerts) {
      _alerts.removeLast();
    }

    _alerts.insert(0, alert);
    _updateUnreadCount();
    notifyListeners();
  }

  void markAsRead(String id) {
    final index = _alerts.indexWhere((a) => a.id == id);
    if (index != -1 && !_alerts[index].isRead) {
      _alerts[index].isRead = true;
      _updateUnreadCount();
      notifyListeners();
    }
  }

  void removeAlert(String id) {
    _alerts.removeWhere((a) => a.id == id);
    _updateUnreadCount();
    notifyListeners();
  }

  void clearAll() {
    _alerts.clear();
    _updateUnreadCount();
    notifyListeners();
  }

  void _updateUnreadCount() {
    unreadCount.value = _alerts.where((a) => !a.isRead).length;
  }

  static void showSuccess(String message) {
    try {
      final manager = getIt<AlertManager>();
      manager.addAlert(message, LogLevel.info);
    } catch (e) {
      debugPrint('AlertManager not yet registered: $e');
    }
  }

  static void showError(String message, [StackTrace? trace]) {
    try {
      final manager = getIt<AlertManager>();
      manager.addAlert(message, LogLevel.error, trace);
    } catch (e) {
      debugPrint('AlertManager not yet registered: $e');
    }
  }
}

class AlertPanel extends StatelessWidget {
  const AlertPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AlertManager>(
      builder: (context, manager, child) {
        return Drawer(
          width: 400,
          child: Column(
            children: [
              AppBar(
                title: const Text('Alerts'),
                automaticallyImplyLeading: false,
                actions: [
                  if (manager.alerts.isNotEmpty)
                    TextButton(
                      onPressed: manager.clearAll,
                      child: const Text('Clear All'),
                    ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              Expanded(
                child: manager.alerts.isEmpty
                    ? const Center(child: Text('No alerts'))
                    : ListView.builder(
                        itemCount: manager.alerts.length,
                        itemBuilder: (context, index) {
                          final alert = manager.alerts[index];
                          return AlertItem(alert: alert);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AlertItem extends StatefulWidget {
  final AlertMessage alert;

  const AlertItem({super.key, required this.alert});

  @override
  State<AlertItem> createState() => _AlertItemState();
}

class _AlertItemState extends State<AlertItem> {
  bool _isExpanded = false;

  /// Shows just the time for today's alerts, and includes the date otherwise so
  /// alerts spanning multiple days aren't ambiguous.
  String _formatTimestamp(DateTime ts) {
    final now = DateTime.now();
    final hh = ts.hour.toString().padLeft(2, '0');
    final mm = ts.minute.toString().padLeft(2, '0');
    final isToday =
        ts.year == now.year && ts.month == now.month && ts.day == now.day;
    if (isToday) return '$hh:$mm';
    final mo = ts.month.toString().padLeft(2, '0');
    final da = ts.day.toString().padLeft(2, '0');
    return '${ts.year}-$mo-$da $hh:$mm';
  }

  @override
  Widget build(BuildContext context) {
    final manager = Provider.of<AlertManager>(context, listen: false);
    final scheme = Theme.of(context).colorScheme;
    // Error maps to the theme's error role; warning/info/debug keep conventional
    // severity colors (Material has no theme role for these).
    final color = switch (widget.alert.level) {
      LogLevel.warning => Colors.orange,
      LogLevel.error => scheme.error,
      LogLevel.info => Colors.blue,
      LogLevel.debug => Colors.grey,
    };

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: widget.alert.isRead ? null : scheme.primaryContainer,
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              widget.alert.level == LogLevel.error
                  ? Icons.error_outline
                  : Icons.info_outline,
              color: color,
            ),
            title: Text(
              widget.alert.message,
              maxLines: _isExpanded ? null : 2,
              overflow: _isExpanded ? null : TextOverflow.ellipsis,
            ),
            subtitle: Text(_formatTimestamp(widget.alert.timestamp)),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: () => manager.removeAlert(widget.alert.id),
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
              if (!widget.alert.isRead) {
                manager.markAsRead(widget.alert.id);
              }
            },
          ),
          if (_isExpanded && widget.alert.stackTrace.toString().isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SelectableText(
                widget.alert.stackTrace.toString(),
                style: GoogleFonts.robotoMono(fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
