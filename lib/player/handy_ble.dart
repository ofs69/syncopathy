import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:syncopathy/helper/throttler.dart';
import 'package:syncopathy/helper/debouncer.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/player/funscript_stream_controller.dart';
import 'package:syncopathy/generated/constants.pb.dart';
import 'package:syncopathy/generated/handy_rpc.pb.dart';
import 'package:syncopathy/generated/messages.pb.dart';
import 'package:universal_ble/universal_ble.dart';
import "package:async_locks/async_locks.dart";
import 'package:syncopathy/logging.dart';

class HandyBle extends FunscriptDevice {
  BleDevice? _device;
  BleCharacteristic? _tx;
  BleCharacteristic? _rx;
  Timer? _connectionCheckTimer;
  StreamSubscription? _rxSubscription;

  final ValueNotifier<bool> _isConnected = ValueNotifier(false);
  ValueNotifier<bool> get isConnected => _isConnected;
  final ValueNotifier<bool> _isScanning = ValueNotifier(false);
  ValueNotifier<bool> get isScanning => _isScanning;

  final ValueNotifier<double> _sliderMin = ValueNotifier(0.0);
  ValueNotifier<double> get sliderMin => _sliderMin;
  final ValueNotifier<double> _sliderMax = ValueNotifier(0.0);
  ValueNotifier<double> get sliderMax => _sliderMax;

  double _initMin = 0.0;
  double _initMax = 1.0;

  int _nextRequestId = 1;
  int get nextRequestId => _nextRequestId++;
  final _pendingRequests = <int, Completer<RpcMessage>>{};

  int _currentStreamId = 0;
  int _lastPosition = -1;
  int _lastPosDelta = -1;
  final Debouncer _syncTimeDebouncer = Debouncer(milliseconds: 300);
  final Throttler _syncTimeThrottler = Throttler(milliseconds: 2000);

  bool _isPaused = true;

  static final _connectSemaphore = Semaphore(1);

  HandyBle() {
    _startConnectionCheckTimer();
    UniversalBle.onScanResult = _handleScanResults;
  }

  void dispose() {
    _connectionCheckTimer?.cancel();
    _rxSubscription?.cancel();
    if (_device != null) {
      UniversalBle.disconnect(_device!.deviceId);
    }
  }

  void _startConnectionCheckTimer() {
    _connectionCheckTimer?.cancel();
    _connectionCheckTimer = Timer.periodic(const Duration(seconds: 2), (
      timer,
    ) async {
      if (_device != null) {
        try {
          final state = await _device!.connectionState;
          final isCurrentlyConnected = state == BleConnectionState.connected;
          if (_isConnected.value != isCurrentlyConnected) {
            _isConnected.value = isCurrentlyConnected;
            if (!isCurrentlyConnected) {
              Logger.info("Device disconnected.");
            }
          }
        } catch (e) {
          if (_isConnected.value) {
            _isConnected.value = false;
            Logger.error("Connection check failed: $e");
          }
        }
      } else if (_isConnected.value) {
        await _disconnected();
      }
    });
  }

  Future<void> _disconnected() async {
    _rxSubscription?.cancel();
    _isConnected.value = false;
    _device = null;
    _tx = null;
    _rx = null;
    _isConnected.value = false;
  }

  void startScan(double minPos, double maxPos) async {
    _isScanning.value = true;
    _initMin = minPos;
    _initMax = maxPos;

    final bluetoothAvailabilityState =
        await UniversalBle.getBluetoothAvailabilityState();

    if (bluetoothAvailabilityState != AvailabilityState.poweredOn) {
      Logger.error("NO BLUETOOTH AVAILABLE!");
      _isScanning.value = false;
      return;
    }

    if (_device != null) {
      if (await _device!.connectionState == BleConnectionState.connected) {
        await _rx?.notifications.unsubscribe();
        _rxSubscription?.cancel();
        await _device?.disconnect();
      }
    }

    await _disconnected();

    UniversalBle.startScan(
      scanFilter: ScanFilter(
        withServices: ["77834d26-40f7-11ee-be56-0242ac120002"],
      ),
    );
  }

  /*
    Service: 77834d26-40f7-11ee-be56-0242ac120002
    TX characteristics: 77835032-40f7-11ee-be56-0242ac120002
    RX characteristics: 77835410-40f7-11ee-be56-0242ac120002
  */
  void _handleScanResults(BleDevice device) async {
    await _connectSemaphore.acquire();
    if (isConnected.value) return;

    try {
      await device.connect();
      _device = device;

      await Future.delayed(Duration(milliseconds: 500));

      _tx = await device.getCharacteristic(
        "77835032-40f7-11ee-be56-0242ac120002",
        service: "77834d26-40f7-11ee-be56-0242ac120002",
      );
      _rx = await device.getCharacteristic(
        "77835410-40f7-11ee-be56-0242ac120002",
        service: "77834d26-40f7-11ee-be56-0242ac120002",
      );
      if (_tx != null && _rx != null) {
        _pendingRequests.clear();
        _rxSubscription = _rx!.onValueReceived.listen(_rpcMessageReceived);
        await _rx!.notifications.subscribe();
        _isConnected.value = true;
        await UniversalBle.stopScan();
        _isScanning.value = false;

        await _setupDevice();
        await _loadSettings();
      }
    } catch (e) {
      await UniversalBle.stopScan();
      _isScanning.value = false;
      await _device?.disconnect();
      Logger.error(e.toString());
    } finally {
      _connectSemaphore.release();
    }
  }

  @override
  Future<void> bufferBatch(
    List<FunscriptAction> batch,
    int tailActionIndex,
    bool flush,
  ) async {
    var pointBatch = List<Point>.empty(growable: true);

    for (var action in batch) {
      var point = Point(t: action.at, x: action.pos);
      pointBatch.add(point);
    }

    await _bufferPoints(
      pointBatch,
      tailActionIndex,
      tailActionIndex - (batch.length ~/ 2),
      flush,
    );

    if (flush && !_isPaused) {
      await stopPlayback();
      await startPlayback(pointBatch.first.t, 1.0);
    }
  }

  @override
  Future<void> initStream() async {
    await _createStream();
  }

  @override
  Future<void> positionUpdate(
    int positionMs,
    bool paused,
    double playbackRate,
  ) async {
    var posDelta = (positionMs - _lastPosition).abs();
    var largeSkip = posDelta > (_lastPosDelta * 3);
    _lastPosDelta = posDelta;
    var backSkip = positionMs < _lastPosition;
    _lastPosition = positionMs;

    if ((largeSkip || backSkip) && !_isPaused) {
      await stopPlayback();
      await startPlayback(positionMs, playbackRate);
    }
    await _syncTime(positionMs, paused);
  }

  @override
  Future<void> startPlayback(int positionMs, double playbackRate) async {
    await _startPlayback(positionMs, playbackRate);
  }

  @override
  Future<void> stopPlayback() async {
    await _stopPlayback();
  }

  @override
  Future<void> deinitStream() async {
    _lastPosition = -1;
    _lastPosDelta = -1;
    await stopPlayback();
  }

  Future<void> _txWrite(Uint8List buffer) async {
    if (_tx == null) return;
    return await _tx!.write(buffer).catchError((error) {
      Logger.error(error.toString());
      _disconnected();
    });
  }

  void _rpcMessageReceived(Uint8List value) {
    var message = RpcMessage.fromBuffer(value.toList());
    if (message.type == MessageType.MESSAGE_TYPE_RESPONSE) {
      if (message.response.hasError()) {
        var error = message.response.error;
        Logger.error(error.toString());
      } else {
        _pendingRequests[message.response.id]?.complete(message);

        Logger.info(
          message.response.toString().replaceAll(RegExp(r'\s+'), ' '),
        );
      }
      _pendingRequests.remove(message.response.id);
    } else if (message.type == MessageType.MESSAGE_TYPE_NOTIFICATION) {
      Logger.info(
        message.notification.toString().replaceAll(RegExp(r'\s+'), ' '),
      );
    } else {
      throw Exception("Unknown message type: ${message.type}");
    }
  }

  Future<void> _loadSettings() async {
    var requestId = nextRequestId;
    var message = RpcMessage(
      type: MessageType.MESSAGE_TYPE_REQUEST,
      request: Request(
        id: requestId,
        requestSliderStrokeGet: RequestSliderStrokeGet(),
      ),
    );
    var completer = Completer<RpcMessage>();
    _pendingRequests[requestId] = completer;

    var response = completer.future.then((value) {
      var response = value.response;
      if (response.hasResponseSliderStrokeGet()) {
        var get = response.responseSliderStrokeGet;
        sliderMin.value = get.min;
        sliderMax.value = get.max;
      }
    });

    _txWrite(message.writeToBuffer());
    await response;
  }

  Future<void> setSettings(double min, double max) async {
    if (_tx == null) return;
    var requestId = nextRequestId;
    var message = RpcMessage(
      type: MessageType.MESSAGE_TYPE_REQUEST,
      request: Request(
        id: requestId,
        requestSliderStrokeSet: RequestSliderStrokeSet(min: min, max: max),
      ),
    );

    var completer = Completer<RpcMessage>();
    _pendingRequests[requestId] = completer;
    var response = completer.future.then((value) {
      var response = value.response;
      if (response.hasResponseSliderStrokeSet()) {
        var set = response.responseSliderStrokeSet;
        sliderMin.value = set.min;
        sliderMax.value = set.max;
      }
    });

    _txWrite(message.writeToBuffer());
    await response;
  }

  Future<void> _createStream() async {
    if (_tx == null) return;

    _currentStreamId = Random(
      DateTime.now().millisecondsSinceEpoch,
    ).nextInt(999999999);

    var requestId = nextRequestId;
    var message = RpcMessage(
      type: MessageType.MESSAGE_TYPE_REQUEST,
      request: Request(
        id: requestId,
        requestHspSetup: RequestHspSetup(streamId: _currentStreamId),
      ),
    );

    var completer = Completer<RpcMessage>();
    _pendingRequests[requestId] = completer;
    var response = completer.future.then((value) {
      var response = value.response;
      if (response.hasResponseHspSetup()) {
        var setup = response.responseHspSetup;
        var state = setup.state;
        return state;
      }
    });
    _txWrite(message.writeToBuffer());

    var state = (await response)!;
    var _ = state.maxPoints;
  }

  Future<void> _bufferPoints(
    List<Point> points,
    int tailPointIndex,
    int tailPointThreshold,
    bool flush,
  ) async {
    if (_tx == null) return;
    var requestId = nextRequestId;
    var message = RpcMessage(
      type: MessageType.MESSAGE_TYPE_REQUEST,
      request: Request(
        id: requestId,
        requestHspAdd: RequestHspAdd(
          flush: flush,
          points: points,
          tailPointStreamIndex: tailPointIndex,
          tailPointThreshold: tailPointThreshold,
        ),
      ),
    );

    var completer = Completer<RpcMessage>();
    _pendingRequests[requestId] = completer;
    var response = completer.future.then((value) {
      var response = value.response;
      if (response.hasResponseHspAdd()) {
        var _ = response.responseHspAdd;
      }
    });

    _txWrite(message.writeToBuffer());
    await response;
  }

  Future<void> _syncTime(int currentTimeMs, bool isPaused) async {
    Future<void> syncTimeInternal(int currentTimeMs, bool isPaused) async {
      if (_tx == null) return;
      Logger.info("sync time! $currentTimeMs");
      var requestId = nextRequestId;
      var message = RpcMessage(
        type: MessageType.MESSAGE_TYPE_REQUEST,
        request: Request(
          id: requestId,
          requestHspCurrentTimeSet: RequestHspCurrentTimeSet(
            currentTime: currentTimeMs,
            serverTime: Int64(DateTime.now().millisecondsSinceEpoch),
            filter: 0.5,
          ),
        ),
      );

      var completer = Completer<RpcMessage>();
      _pendingRequests[requestId] = completer;
      var response = completer.future.then((value) {
        var response = value.response;
        if (response.hasResponseHspCurrentTimeSet()) {
          var _ = response.responseHspCurrentTimeSet;
        }
      });
      _txWrite(message.writeToBuffer());
      await response;
    }

    if (isPaused) {
      _syncTimeDebouncer.run(() async {
        await syncTimeInternal(currentTimeMs, isPaused);
      });
    } else {
      _syncTimeThrottler.run(() async {
        await syncTimeInternal(currentTimeMs, isPaused);
      });
    }
  }

  Future<void> _startPlayback(int startTimeMs, double playbackRate) async {
    if (_tx == null) return;
    Logger.info("start playback!");
    _isPaused = false;

    var requestId = nextRequestId;
    var message = RpcMessage(
      type: MessageType.MESSAGE_TYPE_REQUEST,
      request: Request(
        id: requestId,
        requestHspPlay: RequestHspPlay(
          startTime: startTimeMs,
          loop: false,
          playbackRate: playbackRate,
          pauseOnStarving: false,
          serverTime: Int64(DateTime.now().millisecondsSinceEpoch),
        ),
      ),
    );

    var completer = Completer<RpcMessage>();
    _pendingRequests[requestId] = completer;
    var response = completer.future.then((value) {
      var response = value.response;
      if (response.hasResponseHspStop()) {
        var _ = response.responseHspStop;
      }
    });
    _txWrite(message.writeToBuffer());
    await response;
  }

  Future<void> _stopPlayback() async {
    if (_tx == null) return;
    _isPaused = true;
    Logger.info("stop playback!");

    var requestId = nextRequestId;
    var message = RpcMessage(
      type: MessageType.MESSAGE_TYPE_REQUEST,
      request: Request(id: requestId, requestHspStop: RequestHspStop()),
    );

    var completer = Completer<RpcMessage>();
    _pendingRequests[requestId] = completer;
    var response = completer.future.then((value) {
      var response = value.response;
      if (response.hasResponseHspStop()) {
        var _ = response.responseHspStop;
      }
    });
    _txWrite(message.writeToBuffer());
    await response;
  }

  Future<void> _setupDevice() async {
    ResponseClockOffsetGet clock;
    {
      var requestId = nextRequestId;
      var message = RpcMessage(
        type: MessageType.MESSAGE_TYPE_REQUEST,
        request: Request(
          id: requestId,
          requestClockOffsetGet: RequestClockOffsetGet(),
        ),
      );

      var completer = Completer<RpcMessage>();
      _pendingRequests[requestId] = completer;
      var response = completer.future.then((value) {
        var response = value.response;
        if (response.hasResponseClockOffsetGet()) {
          var clock = response.responseClockOffsetGet;
          return clock;
        }
      });
      _txWrite(message.writeToBuffer());
      clock = (await response)!;
      await _createStream();
    }

    var serverTime = DateTime.now().millisecondsSinceEpoch;
    var clockOffset = serverTime - clock.time;

    var requestId = nextRequestId;
    var message = RpcMessage(
      type: MessageType.MESSAGE_TYPE_REQUEST,
      request: Request(
        id: requestId,
        requestClockOffsetSet: RequestClockOffsetSet(
          clockOffset: Int64(clockOffset),
          rtd: 0,
        ),
      ),
    );

    var completer = Completer<RpcMessage>();
    _pendingRequests[requestId] = completer;
    var response = completer.future.then((value) {
      var response = value.response;
      if (response.hasResponseClockOffsetSet()) {
        var clock = response.responseClockOffsetSet;
        return clock;
      }
    });
    _txWrite(message.writeToBuffer());

    var _ = await response;

    await setSettings(_initMin.toDouble(), _initMax.toDouble());
  }
}
