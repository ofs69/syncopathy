import 'dart:convert';

class Settings {
  final int id = 0; // Singleton ID
  int min = 0;
  int max = 100;
  int offsetMs;
  List<String> mediaPaths = List.empty(growable: true);
  double? slewMaxRateOfChange;
  double? rdpEpsilon;
  bool remapFullRange;
  bool skipToAction;
  bool embeddedVideoPlayer;
  bool autoSwitchToVideoPlayerTab;
  bool autoPlay;
  bool invert;

  Settings({
    this.min = 0,
    this.max = 100,
    this.offsetMs = 25,
    List<String> mediaPaths = const [],
    this.slewMaxRateOfChange = 400,
    this.rdpEpsilon = 15,
    this.remapFullRange = true,
    this.skipToAction = true,
    this.embeddedVideoPlayer = false,
    this.autoSwitchToVideoPlayerTab = false,
    this.autoPlay = true,
    this.invert = false,
  }) {
    this.mediaPaths.clear();
    this.mediaPaths.addAll(mediaPaths);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'min': min,
      'max': max,
      'offsetMs': offsetMs,
      'mediaPaths': jsonEncode(mediaPaths),
      'slewMaxRateOfChange': slewMaxRateOfChange,
      'rdpEpsilon': rdpEpsilon,
      'remapFullRange': remapFullRange ? 1 : 0,
      'skipToAction': skipToAction ? 1 : 0,
      'embeddedVideoPlayer': embeddedVideoPlayer ? 1 : 0,
      'autoSwitchToVideoPlayerTab': autoSwitchToVideoPlayerTab ? 1 : 0,
      'autoPlay': autoPlay ? 1 : 0,
      'invert': invert ? 1 : 0,
    };
  }

  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      min: map['min'],
      max: map['max'],
      offsetMs: map['offsetMs'],
      mediaPaths: List<String>.from(jsonDecode(map['mediaPaths'])),
      slewMaxRateOfChange: map['slewMaxRateOfChange'],
      rdpEpsilon: map['rdpEpsilon'],
      remapFullRange: map['remapFullRange'] == 1,
      skipToAction: map['skipToAction'] == 1,
      embeddedVideoPlayer: map['embeddedVideoPlayer'] == 1,
      autoSwitchToVideoPlayerTab: map['autoSwitchToVideoPlayerTab'] == 1,
      autoPlay: map['autoPlay'] == 1,
      invert: map['invert'] == 1,
    );
  }
}
