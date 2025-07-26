import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/model/app_model.dart';

// Shows the last 20 log messages
class LoggingPanel extends StatefulWidget {
  const LoggingPanel({super.key});

  @override
  State<LoggingPanel> createState() => _LoggingPanelState();
}

class _LoggingPanelState extends State<LoggingPanel> {
  final List<String> _logMessages = [];
  static const int _maxLogMessages = 20;
  StreamSubscription? _errorSubscription;
  StreamSubscription? _notificationSubscription;

  @override
  void initState() {
    super.initState();
    final model = context.read<SyncopathyModel>();
    _errorSubscription ??= model.onError.listen((message) {
      _addLogMessage("==ERROR==\n$message");
    });
    _notificationSubscription ??= model.onNotification.listen((message) {
      _addLogMessage(message);
    });
  }

  @override
  void dispose() {
    _errorSubscription?.cancel();
    _notificationSubscription?.cancel();
    super.dispose();
  }

  void _addLogMessage(String message) {
    if (mounted) {
      setState(() {
        _logMessages.insert(0, message);
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: SelectableText(
                      _logMessages[index],
                      style: Theme.of(context).textTheme.bodySmall,
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
