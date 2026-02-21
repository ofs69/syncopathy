import 'dart:async';
import 'dart:isolate';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/generated/constants.pb.dart';
import 'package:syncopathy/generated/handy_rpc.pb.dart';
import 'package:syncopathy/generated/messages.pb.dart';
import 'package:syncopathy/helper/debouncer.dart';
import 'package:syncopathy/helper/effect_dispose_mixin.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/player/bluetooth_connector.dart';
import 'package:universal_ble/universal_ble.dart';

// Takes care of serializationg and deserialization on two separate isolates
class ProtobufWorker {
  late Isolate _isolateSerialize;
  late Isolate _isolateDeserialize;

  SendPort? _sendSerializePort;
  SendPort? _sendDeserializePort;

  final _resultSerializeController = StreamController<Uint8List>.broadcast();
  Stream<Uint8List> get serializedStream => _resultSerializeController.stream;

  final _resultDeserializeController = StreamController<RpcMessage>.broadcast();
  Stream<RpcMessage> get deserializeStream =>
      _resultDeserializeController.stream;

  Future<void> spawn() async {
    // Serialization isolate
    {
      final receiveSerializePort = ReceivePort();
      _isolateSerialize = await Isolate.spawn(
        _isolateSerializeEntry,
        receiveSerializePort.sendPort,
      );

      Completer<SendPort> serializeCompleter = Completer();
      receiveSerializePort.listen((message) {
        if (message is SendPort) {
          serializeCompleter.complete(message);
        } else if (message is Uint8List) {
          _resultSerializeController.add(message);
        }
      });
      _sendSerializePort = await serializeCompleter.future;
    }

    // Deserialization isolate
    {
      final receiveDeserializePort = ReceivePort();
      _isolateDeserialize = await Isolate.spawn(
        _isolateDeserializeEntry,
        receiveDeserializePort.sendPort,
      );

      Completer<SendPort> deserializeCompleter = Completer();
      receiveDeserializePort.listen((message) {
        if (message is SendPort) {
          deserializeCompleter.complete(message);
        } else if (message is RpcMessage) {
          _resultDeserializeController.add(message);
        }
      });
      _sendDeserializePort = await deserializeCompleter.future;
    }
  }

  Future<void> dispose() async {
    _isolateDeserialize.kill();
    _isolateSerialize.kill();
  }

  void sendToSerialize(RpcMessage message) => _sendSerializePort?.send(message);

  void sendToDeserialize(Uint8List message) =>
      _sendDeserializePort?.send(message);

  // This runs in the separate thread
  static void _isolateSerializeEntry(SendPort mainSendPort) {
    final childReceivePort = ReceivePort();
    mainSendPort.send(childReceivePort.sendPort);

    childReceivePort.listen((message) {
      final Uint8List buffer = message.writeToBuffer();
      mainSendPort.send(buffer);
    });
  }

  // This runs in the separate thread
  static void _isolateDeserializeEntry(SendPort mainSendPort) {
    final childReceivePort = ReceivePort();
    mainSendPort.send(childReceivePort.sendPort);

    childReceivePort.listen((message) {
      final msg = RpcMessage.fromBuffer(message);
      mainSendPort.send(msg);
    });
  }
}

class HandyBle with EffectDispose {
  final BtDevice _device;
  final List<(int, DateTime, Completer<Response>)> _messageCompleters = [];

  int _messageIdCounter = 1;
  int get messageId => _messageIdCounter++;
  static const noCompletionId = 2147483647;

  ReadonlySignal<HspState?> get hspState => _hspState;
  final Signal<HspState?> _hspState = signal(null);

  ReadonlySignal<BatteryState?> get batteryState => _batteryState;
  final Signal<BatteryState?> _batteryState = signal(null);
  Timer? _batteryPolling;

  late final ReadonlySignal<bool> isConnected;

  final Signal<int> _strokeRangeMin;
  final Signal<int> _strokeRangeMax;

  // Called when threshold is reached or starving
  Function(bool)? hspThresholdReached; // bool = starving
  // Called when paused on starving notification is received
  Function()? hspPausedOnStarving;

  late final StreamSubscription _bufferReceivedSubscription;
  late final StreamSubscription _deserializeSubscription;
  late final StreamSubscription _serializeSubscription;
  final ProtobufWorker _worker = ProtobufWorker();

  final _applyStrokeRangeDebouncer = Debouncer(milliseconds: 500);

  int estimatedAverageOffset = 0;

  HandyBle(this._device, this._strokeRangeMin, this._strokeRangeMax) {
    isConnected = _device.device.connectionStream.toSyncSignal(true);
    _bufferReceivedSubscription = _device.rx.onValueReceived.listen(
      _bufferReceived,
    );
    _device.rx.notifications.subscribe();
    _deserializeSubscription = _worker.deserializeStream.listen(
      _rpcMessageReceived,
    );
    _serializeSubscription = _worker.serializedStream.listen(_sendBuffer);

    effectAdd([
      effect(() {
        final min = _strokeRangeMin.value;
        final max = _strokeRangeMax.value;
        _applyStrokeRangeDebouncer.run(() {
          Logger.info("Stroke range set!");
          sliderStrokeSet(min, max);
        });
      }),
    ]);
  }

  // We are the server + estimated BT latency
  int serverTime() =>
      DateTime.now().millisecondsSinceEpoch + estimatedAverageOffset;

  Future<void> init() async {
    await _worker.spawn();
    final range = await sliderStrokeGet();
    if (range != null) {
      _strokeRangeMin.value = range.$1;
      _strokeRangeMax.value = range.$2;
    }

    // Capabilities
    final caps = await getCapabilities();
    if (caps != null) {
      if (caps.battery) {
        final battery = await getBatteryState();
        _batteryState.value = battery;
        _batteryPolling = Timer.periodic(Duration(seconds: 3), (_) async {
          try {
            final battery = await getBatteryState();
            _batteryState.value = battery;
          } catch (_) {
            _batteryPolling?.cancel();
          }
        });
      } else {
        _batteryPolling?.cancel();
        _batteryState.value = null;
      }
    }

    // Sync time
    {
      const syncTries = 10;
      var offsetAggregated = 0.0;
      for (var index = 0; index < syncTries; index += 1) {
        final start = DateTime.now().millisecondsSinceEpoch;
        final _ = await getClockOffset();
        final server = DateTime.now().millisecondsSinceEpoch;
        final end = server;
        final rtd = end - start;
        final offset = (server + (rtd / 2)) - end;
        offsetAggregated += offset;
      }
      estimatedAverageOffset = (offsetAggregated / syncTries).round();
      Logger.debug("Estimated average offset: $estimatedAverageOffset");
      final offset = await getClockOffset();
      final clockOffset = serverTime() - offset!.time;
      await setClockOffset(clockOffset);
    }
  }

  static Future<HandyBle?> startScanning(
    Signal<int> strokeMin,
    Signal<int> strokeMax,
  ) async {
    final device = await BluetoothConnector().scanForDevice(
      "77834d26-40f7-11ee-be56-0242ac120002",
      "77835032-40f7-11ee-be56-0242ac120002",
      "77835410-40f7-11ee-be56-0242ac120002",
    );
    return device == null ? null : HandyBle(device, strokeMin, strokeMax);
  }

  void _bufferReceived(Uint8List buffer) {
    _worker.sendToDeserialize(buffer);
  }

  void _sendBuffer(Uint8List bufferMsg) async {
    try {
      await _device.tx.write(bufferMsg, withResponse: false);
    } catch (_) {
      await _device.device.disconnect();
    }
  }

  void _rpcMessageReceived(RpcMessage message) {
    if (message.type == MessageType.MESSAGE_TYPE_RESPONSE) {
      Response response = message.response;
      if (response.id != noCompletionId) {
        final completer = _messageCompleters.firstWhereOrNull(
          (c) => c.$1 == response.id,
        );
        if (completer != null) {
          _messageCompleters.remove(completer);
          completer.$3.complete(response);
        }
        // remove potentially timed out completers
        _messageCompleters.removeWhere(
          (c) => (DateTime.now().difference(c.$2).inSeconds > 10),
        );
      }
      _resultHandler(response);
    } else if (message.type == MessageType.MESSAGE_TYPE_NOTIFICATION) {
      _notificationHandler(message);
    }
  }

  void _notificationHandler(RpcMessage message) {
    switch (message.notification.whichNotification()) {
      // HSP NOTIFICATIONS
      case Notification_Notification.notificationHspThresholdReached:
        _hspState.value =
            message.notification.notificationHspThresholdReached.state;
        hspThresholdReached?.call(false);
        break;
      case Notification_Notification.notificationHspStateChanged:
        _hspState.value =
            message.notification.notificationHspStateChanged.state;
        break;
      case Notification_Notification.notificationHspLooping:
        _hspState.value = message.notification.notificationHspLooping.state;
        break;
      case Notification_Notification.notificationHspStarving:
        _hspState.value = message.notification.notificationHspStarving.state;
        hspThresholdReached?.call(true);
        break;
      case Notification_Notification.notificationHspResumedOnNonStarving:
        _hspState.value =
            message.notification.notificationHspResumedOnNonStarving.state;
        break;
      case Notification_Notification.notificationHspPausedOnStarving:
        _hspState.value =
            message.notification.notificationHspPausedOnStarving.state;
        hspPausedOnStarving?.call();
        break;

      case Notification_Notification.notificationBatteryChanged:
        _batteryState.value =
            message.notification.notificationBatteryChanged.state;
        break;

      // UNHANDLED NOTIFICATION
      default:
        if (kDebugMode) debugPrint(message.notification.toDebugString());
        break;
    }
  }

  Future<Response?> _sendRequestFuture(Request request) async {
    request.id = messageId;
    final message = RpcMessage(
      type: MessageType.MESSAGE_TYPE_REQUEST,
      request: request,
    );
    final completer = Completer<Response>();
    _messageCompleters.add((request.id, DateTime.now(), completer));
    _worker.sendToSerialize(message);
    return completer.future.timeout(Duration(seconds: 5));
  }

  void _sendRequest(Request request) {
    request.id = noCompletionId;
    final message = RpcMessage(
      type: MessageType.MESSAGE_TYPE_REQUEST,
      request: request,
    );
    _worker.sendToSerialize(message);
  }

  Future<void> dispose() async {
    effectDispose();
    _batteryPolling?.cancel();
    await _bufferReceivedSubscription.cancel();
    await _deserializeSubscription.cancel();
    await _serializeSubscription.cancel();
    await _worker.dispose();
    await _device.device.disconnect();
  }

  Future<(int, int)?> sliderStrokeGet() async {
    final request = RequestSliderStrokeGet();
    final response = await _sendRequestFuture(
      Request(requestSliderStrokeGet: request),
    );
    if (response != null && response.hasResponseSliderStrokeGet()) {
      final get = response.responseSliderStrokeGet;
      final min = (get.min * 100.0).round().clamp(0, 100);
      final max = (get.max * 100.0).round().clamp(0, 100);
      return (min, max);
    }
    return null;
  }

  Future<(int, int)?> sliderStrokeSet(int min, int max) async {
    final request = RequestSliderStrokeSet(
      min: (min / 100.0).clamp(0.0, 1.0),
      max: (max / 100.0).clamp(0.0, 1.0),
    );
    final response = await _sendRequestFuture(
      Request(requestSliderStrokeSet: request),
    );
    if (response != null && response.hasResponseSliderStrokeSet()) {
      final get = response.responseSliderStrokeSet;
      final min = (get.min * 100.0).round().clamp(0, 100);
      final max = (get.max * 100.0).round().clamp(0, 100);
      return (min, max);
    }
    return null;
  }

  Future<HspState?> hspStateGet() async {
    final request = RequestHspStateGet();
    final response = await _sendRequestFuture(
      Request(requestHspStateGet: request),
    );
    if (response != null && response.hasResponseHspStateGet()) {
      final hspState = response.responseHspStateGet.state;
      return hspState;
    }
    return null;
  }

  void positionWithDuration(double relPos, int moveOverTimeMs) {
    final request = RequestHdspXpTSet(
      xp: relPos,
      t: moveOverTimeMs,
      stopOnTarget: true,
    );
    _sendRequest(Request(requestHdspXpTSet: request));
  }

  void _resultHandler(Response response) {
    switch (response.whichResult()) {
      case Response_Result.responseHspStateGet:
        _hspState.value = response.responseHspStateGet.state;
        break;
      case Response_Result.responseHspSetup:
        _hspState.value = response.responseHspSetup.state;
        break;
      case Response_Result.responseHspFlush:
        _hspState.value = response.responseHspFlush.state;
        break;
      case Response_Result.responseHspAdd:
        _hspState.value = response.responseHspAdd.state;
        break;
      case Response_Result.responseHspPlay:
        _hspState.value = response.responseHspPlay.state;
        break;
      case Response_Result.responseHspResume:
        _hspState.value = response.responseHspResume.state;
        break;
      case Response_Result.responseHspPause:
        _hspState.value = response.responseHspPause.state;
        break;
      case Response_Result.responseHspCurrentTimeSet:
        _hspState.value = response.responseHspCurrentTimeSet.state;
        break;
      default:
    }
  }

  void hspSetup({int? streamId}) {
    const int maxInt32 = 2147483647;
    streamId ??= Random().nextInt(maxInt32);
    final request = RequestHspSetup(streamId: streamId);
    _sendRequest(Request(requestHspSetup: request));
  }

  void hspFlush() {
    final requeust = RequestHspFlush();
    _sendRequest(Request(requestHspFlush: requeust));
  }

  void hspAdd(
    List<Point> points, {
    required bool flush,
    required int? tailPointStreamIndex,
    required int? tailPointThreshold,
  }) {
    final request = RequestHspAdd(
      points: points,
      flush: flush,
      tailPointStreamIndex: tailPointStreamIndex,
      tailPointThreshold: tailPointThreshold,
    );
    _sendRequest(Request(requestHspAdd: request));
  }

  void hspPlay({
    required int startTime,
    required double playbackRate,
    required bool loop,
  }) {
    final request = RequestHspPlay(
      startTime: startTime,
      loop: loop,
      pauseOnStarving: false,
      playbackRate: playbackRate,
      serverTime: Int64(serverTime()),
    );
    _sendRequest(Request(requestHspPlay: request));
  }

  void hspResume() {
    final request = RequestHspResume(pickUp: false);
    _sendRequest(Request(requestHspResume: request));
  }

  void hspPause() {
    final request = RequestHspPause();
    _sendRequest(Request(requestHspPause: request));
  }

  void hspCurrentTimeSet({
    required int currentTime,
    required bool forceCurrentTime,
  }) {
    final request = RequestHspCurrentTimeSet(
      currentTime: currentTime,
      serverTime: Int64(serverTime()),
      filter: forceCurrentTime ? 1.0 : 0.6,
    );
    _sendRequest(Request(requestHspCurrentTimeSet: request));
  }

  void hspStop() {
    final request = RequestHspStop();
    _sendRequest(Request(requestHspStop: request));
  }

  Future<ResponseClockOffsetGet?> getClockOffset() async {
    final request = RequestClockOffsetGet();
    final response = await _sendRequestFuture(
      Request(requestClockOffsetGet: request),
    );
    if (response != null && response.hasResponseClockOffsetGet()) {
      final get = response.responseClockOffsetGet;
      return get;
    }
    return null;
  }

  Future<ResponseClockOffsetSet?> setClockOffset(int offset, {int? rtd}) async {
    final request = RequestClockOffsetSet(clockOffset: Int64(offset), rtd: rtd);
    final response = await _sendRequestFuture(
      Request(requestClockOffsetSet: request),
    );
    if (response != null && response.hasResponseClockOffsetSet()) {
      final set = response.responseClockOffsetSet;
      return set;
    }
    return null;
  }

  Future<ResponseCapabilitiesGet?> getCapabilities() async {
    final request = RequestCapabilitiesGet();
    final response = await _sendRequestFuture(
      Request(requestCapabilitiesGet: request),
    );
    if (response != null && response.hasResponseCapabilitiesGet()) {
      final caps = response.responseCapabilitiesGet;
      return caps;
    }
    return null;
  }

  Future<BatteryState?> getBatteryState() async {
    final request = RequestBatteryGet();
    final response = await _sendRequestFuture(
      Request(requestBatteryGet: request),
    );
    if (response != null && response.hasResponseBatteryGet()) {
      final state = response.responseBatteryGet.state;
      return state;
    }
    return null;
  }
}
