import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:syncopathy/main.dart';

part 'settings.g.dart';

@collection
class SettingsEntity {
  // Use a fixed ID for the single settings object
  Id id = 0;

  int min = 0;
  int max = 100;
  int offsetMs = 25;
  List<String> mediaPaths = [];
  double? slewMaxRateOfChange = 400;
  double? rdpEpsilon = 15;
  bool remapFullRange = true;
}

class Settings extends ChangeNotifier {
  late SettingsEntity _entity;

  int get min => _entity.min;
  int get max => _entity.max;
  int get offsetMs => _entity.offsetMs;
  List<String> get mediaPaths => _entity.mediaPaths;
  double? get slewMaxRateOfChange => _entity.slewMaxRateOfChange;
  double? get rdpEpsilon => _entity.rdpEpsilon;
  bool get remapFullRange => _entity.remapFullRange;


  Settings();

  Future<void> load() async {
    _entity = await isar.settingsEntitys.get(0) ?? SettingsEntity();
    // by default isar lists are not growable... 
    // this fixes an issue where only one path could be added
    _entity.mediaPaths = _entity.mediaPaths.toList();
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    await isar.writeTxn(() async {
      await isar.settingsEntitys.put(_entity);
    });
  }

  Future<void> setRdpEpsilon(double? value) async {
    _entity.rdpEpsilon = value;
    await _save();
    notifyListeners();
  }

  Future<void> setSlewMaxRateOfChange(double? maxRateOfChange) async {
    _entity.slewMaxRateOfChange = maxRateOfChange;
    await _save();
    notifyListeners();
  }

  Future<void> setMinMax(int min, int max) async {
    _entity.min = min;
    _entity.max = max;
    await _save();
    notifyListeners();
  }

  Future<void> setOffsetMs(int offsetMs) async {
    _entity.offsetMs = offsetMs;
    await _save();
    notifyListeners();
  }

  Future<void> setPaths(List<String> paths) async {
    _entity.mediaPaths = paths;
    await _save();
    notifyListeners();
  }

  Future<void> addPath(String path) async {
    if (_entity.mediaPaths.contains(path)) return;
    _entity.mediaPaths.add(path);
    await _save();
    notifyListeners();
  }

  Future<void> removePath(String path) async {
    _entity.mediaPaths.remove(path);
    await _save();
    notifyListeners();
  }

  Future<void> setRemapFullRange(bool value) async {
    _entity.remapFullRange = value;
    await _save();
    notifyListeners();
  }
}
