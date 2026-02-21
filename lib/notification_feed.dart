import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:uuid/uuid.dart';

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/logging.dart';

class NotificationMessage {
  final String id;
  final String message;
  final LogLevel level;
  final StackTrace stackTrace;
  Timer? timer;
  final Signal<double> progressNotifier = signal(1.0);
  int remainingSeconds;
  DateTime? startTime;

  final int totalDurationSeconds;

  NotificationMessage({
    required this.message,
    required this.level,
    required this.stackTrace,
    this.timer,
    int initialSeconds = 5,
  }) : id = const Uuid().v4(),
       remainingSeconds = initialSeconds,
       totalDurationSeconds = initialSeconds;
}

class NotificationFeedManager extends ChangeNotifier {
  final List<NotificationMessage> _notifications = [];
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  List<NotificationMessage> get notifications => _notifications;

  void addNotification(String message, LogLevel level, StackTrace trace) {
    // Ensure only one notification without a removal timer is active.
    // If there's an existing notification whose timer was paused (e.g., by hovering),
    // restart its timer so it eventually gets removed.
    for (final existingNotification in _notifications) {
      if (existingNotification.timer == null) {
        _startRemovalTimer(existingNotification);
      }
    }

    final notification = NotificationMessage(
      message: message,
      level: level,
      stackTrace: trace,
      initialSeconds: 5,
    );
    notification.startTime =
        DateTime.now(); // Set start time for new notification
    _notifications.insert(0, notification);
    listKey.currentState?.insertItem(
      0,
      duration: const Duration(milliseconds: 300),
    );
    _startRemovalTimer(notification);
    notifyListeners();
  }

  void _startRemovalTimer(NotificationMessage notification) {
    notification.timer?.cancel();
    final int totalDurationSeconds = notification.totalDurationSeconds;

    // Calculate the effective start time based on remaining seconds
    notification.startTime = DateTime.now().subtract(
      Duration(
        milliseconds:
            ((totalDurationSeconds - notification.remainingSeconds) * 1000)
                .round(),
      ),
    );

    notification.timer = Timer.periodic(const Duration(milliseconds: 16), (t) {
      // Update every ~16ms for 60fps
      final double elapsedSeconds =
          DateTime.now().difference(notification.startTime!).inMilliseconds /
          1000.0;
      final double remaining = totalDurationSeconds - elapsedSeconds;

      if (remaining > 0) {
        notification.progressNotifier.value = remaining / totalDurationSeconds;
        notification.remainingSeconds = remaining
            .ceil(); // Update remaining seconds for pause/resume
      } else {
        t.cancel();
        removeNotificationById(notification.id);
      }
    });
  }

  void removeNotificationById(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final removedItem = _notifications.removeAt(index);
      removedItem.timer?.cancel();
      removedItem.timer = null; // Ensure timer is nullified on removal
      listKey.currentState?.removeItem(
        index,
        (context, animation) => _buildRemovedItem(removedItem, animation),
        duration: const Duration(milliseconds: 300),
      );
      notifyListeners();
    }
  }

  Widget _buildRemovedItem(
    NotificationMessage notification,
    Animation<double> animation,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeIn)),
      child: NotificationCard(notification: notification),
    );
  }

  void pauseRemovalTimer(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final notification = _notifications[index];
      notification.timer?.cancel();
      notification.timer = null; // Explicitly set to null
    }
  }

  void resumeRemovalTimer(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final notification = _notifications[index];
      _startRemovalTimer(notification);
    }
  }

  static void showSuccessNotification(BuildContext context, String message) {
    Provider.of<NotificationFeedManager>(
      context,
      listen: false,
    ).addNotification(message, LogLevel.info, StackTrace.current);
  }

  static void showErrorNotification(BuildContext context, String message) {
    Provider.of<NotificationFeedManager>(
      context,
      listen: false,
    ).addNotification(message, LogLevel.error, StackTrace.current);
  }
}

class NotificationFeed extends StatelessWidget {
  const NotificationFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationFeedManager>(
      builder: (context, manager, child) {
        return Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: 400,
              child: AnimatedList(
                key: manager.listKey,
                initialItemCount: manager.notifications.length,
                shrinkWrap: true,
                reverse: true,
                itemBuilder: (context, index, animation) {
                  final notification = manager.notifications[index];
                  return _buildAddedItem(notification, animation);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddedItem(
    NotificationMessage notification,
    Animation<double> animation,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
      child: NotificationCard(notification: notification),
    );
  }
}

class NotificationCard extends StatefulWidget {
  final NotificationMessage notification;

  const NotificationCard({super.key, required this.notification});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  bool _isHovering = false;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final manager = Provider.of<NotificationFeedManager>(
      context,
      listen: false,
    );
    final color = switch (widget.notification.level) {
      LogLevel.warning => Colors.orange,
      LogLevel.error => Colors.red,
      _ => Colors.grey,
    };

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovering = true;
        });
        manager.pauseRemovalTimer(widget.notification.id);
      },
      onExit: (_) {
        setState(() {
          _isHovering = false;
        });
        manager.resumeRemovalTimer(widget.notification.id);
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Stack(
          children: [
            Card(
              color: (_isHovering
                  ? const Color.fromRGBO(30, 30, 30, 0.9)
                  : const Color.fromRGBO(0, 0, 0, 0.7)),
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(width: 5, height: 50, color: color),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            widget.notification.message,
                            style: const TextStyle(color: Colors.white),
                            maxLines: _isExpanded ? null : 4,
                            overflow: _isExpanded
                                ? null
                                : TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          manager.removeNotificationById(
                            widget.notification.id,
                          );
                        },
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                  if (_isExpanded)
                    Row(
                      children: [
                        const SizedBox(width: 16),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              widget.notification.stackTrace.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Watch.builder(
                builder: (context) {
                  final progress = widget.notification.progressNotifier.value;
                  return LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
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

class LogNotificationObserver extends StatefulWidget {
  final Widget child;

  const LogNotificationObserver({super.key, required this.child});

  @override
  State<LogNotificationObserver> createState() =>
      _LogNotificationObserverState();
}

class _LogNotificationObserverState extends State<LogNotificationObserver> {
  StreamSubscription? _logSubscription;

  @override
  void initState() {
    super.initState();
    _startLogSubscription();
  }

  void _startLogSubscription() {
    _logSubscription?.cancel(); // Cancel any existing subscription
    final notificationFeedManager = context.read<NotificationFeedManager>();
    final showDebugNotifications = context
        .read<SettingsModel>()
        .showDebugNotifications;
    _logSubscription = logStream.listen((entry) {
      if (entry.level == LogLevel.warning ||
          entry.level == LogLevel.error ||
          showDebugNotifications.value) {
        notificationFeedManager.addNotification(
          entry.message,
          entry.level,
          entry.stackTrace,
        );
      }
    });
  }

  @override
  void dispose() {
    _logSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
