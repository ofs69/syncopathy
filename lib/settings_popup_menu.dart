import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/model/app_model.dart';
import 'package:syncopathy/helper/debouncer.dart';

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
  RangeValues minMax = RangeValues(0, 100);
  final _debouncer = Debouncer(milliseconds: 500);
  late final SyncopathyModel _model;

  @override
  void initState() {
    _model = context.read<SyncopathyModel>();
    minMax = RangeValues(
      _model.settings.min.value.toDouble(),
      _model.settings.max.value.toDouble(),
    );

    _model.settings.min.addListener(_handleMinMaxValueChange);
    _model.settings.max.addListener(_handleMinMaxValueChange);

    super.initState();
  }

  void _handleMinMaxValueChange() {
    if (mounted) {
      setState(() {
        minMax = RangeValues(
          _model.settings.min.value.toDouble(),
          _model.settings.max.value.toDouble(),
        );
      });
    }
  }

  @override
  void dispose() {
    _model.settings.min.removeListener(_handleMinMaxValueChange);
    _model.settings.max.removeListener(_handleMinMaxValueChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final player = _model.player;
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
                            values: minMax,
                            min: 0,
                            max: 100,
                            divisions: 100,
                            labels: RangeLabels(
                              minMax.start.round().toString(),
                              minMax.end.round().toString(),
                            ),
                            onChanged: (values) {
                              setState(() {
                                minMax = values;
                                _debouncer.run(() {
                                  _model.settings.setMinMax(
                                    values.start.round(),
                                    values.end.round(),
                                  );
                                });
                              });
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
                  ValueListenableBuilder<bool>(
                    valueListenable: player.paused,
                    builder: (context, isPaused, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Tooltip(
                            message: "Playback Speed",
                            child: Text("Speed"),
                          ),
                          Expanded(
                            child: ValueListenableBuilder<double>(
                              valueListenable: player.playbackSpeed,
                              builder: (context, speed, child) {
                                return SizedBox(
                                  height:
                                      (Theme.of(context).iconTheme.size ??
                                          24.0) *
                                      1.5,
                                  child: Slider(
                                    value: speed,
                                    min: 0.5,
                                    max: 2.0,
                                    divisions: 15,
                                    label: '${speed.toStringAsFixed(1)}x',
                                    onChanged: isPaused
                                        ? player.setPlaybackSpeed
                                        : null,
                                    onChangeStart: (_) =>
                                        widget.onInteractionStart?.call(),
                                    onChangeEnd: (_) =>
                                        widget.onInteractionEnd?.call(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
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
