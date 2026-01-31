import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/settings_model.dart';

class SettingsPopupMenu extends StatefulWidget {
  final VoidCallback? onInteractionStart;
  final VoidCallback? onInteractionEnd;

  const SettingsPopupMenu({
    super.key,
    this.onInteractionStart,
    this.onInteractionEnd,
  });

  @override
  State<SettingsPopupMenu> createState() => _SettingsPopupMenuState();
}

class _SettingsPopupMenuState extends State<SettingsPopupMenu> {
  @override
  Widget build(BuildContext context) {
    final player = context.read<PlayerModel>();
    final settings = context.read<SettingsModel>();
    return PopupMenuButton(
      icon: const Icon(Icons.settings),
      offset: Offset(0, (-(Theme.of(context).iconTheme.size ?? 24.0)) * 4.0),
      tooltip: "Settings",
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Min/Max Range Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Tooltip(
                        message: "Min/Max Stroke Range",
                        child: Text("Range"),
                      ),
                      Expanded(
                        child: SizedBox(
                          height:
                              (Theme.of(context).iconTheme.size ?? 24.0) * 1.5,
                          child: RangeSlider(
                            values: settings.minMaxRange.watch(context),
                            min: 0,
                            max: 100,
                            divisions: 100,
                            labels: RangeLabels(
                              settings.minMaxRange.value.start
                                  .round()
                                  .toString(),
                              settings.minMaxRange.value.end.round().toString(),
                            ),
                            onChanged: (values) {
                              settings.min.value = values.start.round();
                              settings.max.value = values.end.round();
                            },
                            onChangeStart: (_) =>
                                widget.onInteractionStart?.call(),
                            onChangeEnd: (_) => widget.onInteractionEnd?.call(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Playback Speed Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Tooltip(
                        message: "Playback Speed",
                        child: Text("Speed"),
                      ),
                      Expanded(
                        child: SizedBox(
                          height:
                              (Theme.of(context).iconTheme.size ?? 24.0) * 1.5,
                          child: Slider(
                            value: player.playbackSpeed.watch(context),
                            min: 0.5,
                            max: 2.0,
                            divisions: 15,
                            label:
                                '${player.playbackSpeed.watch(context).toStringAsFixed(1)}x',
                            onChanged: player.paused.watch(context)
                                ? player.setPlaybackSpeed
                                : null,
                            onChangeStart: (_) =>
                                widget.onInteractionStart?.call(),
                            onChangeEnd: (_) => widget.onInteractionEnd?.call(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
