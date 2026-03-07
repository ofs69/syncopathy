import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:pool/pool.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/debouncer.dart';
import 'package:syncopathy/helper/effect_dispose_mixin.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/model/json/handyV3/handy_event.dart';
import 'package:syncopathy/model/json/handyV3/handy_request.dart';
import 'package:syncopathy/model/json/handyV3/handy_response.dart';
import 'package:syncopathy/player/handy_native_hsp_mixin.dart';

class RatelimitMiddleware extends InterceptorContract {
  @override
  FutureOr<BaseRequest> interceptRequest({required BaseRequest request}) {
    if (kDebugMode) {
      debugPrint(request.url.toString());
    }
    return request;
  }

  @override
  FutureOr<BaseResponse> interceptResponse({required BaseResponse response}) {
    final headers = response.headers;

    // Look for common Rate Limit headers
    final limit = headers['x-ratelimit-limit'];
    final remaining = headers['x-ratelimit-remaining'];
    final reset = headers['x-ratelimit-reset'];

    if (limit != null && remaining != null) {
      final used = int.parse(limit) - int.parse(remaining);

      // Parse reset time only if it exists
      String resetInfo = "";
      if (reset != null) {
        final resetTime = DateTime.fromMillisecondsSinceEpoch(
          int.parse(reset) * 1000,
          isUtc: true,
        ).toLocal();
        resetInfo = "\nResets at: ${resetTime.toIso8601String()}";
      }

      Logger.debug(
        '--- 📊 Rate Limit Update ---\n'
        'Used: $used / $limit\n'
        'Remaining: $remaining\n'
        '$resetInfo',
      );
    }

    // Special handling for the 429 status code
    if (response.statusCode == 429) {
      final retryAfter = headers['retry-after'];
      Logger.error(
        'Rate limit hit! Retry after: ${retryAfter ?? "unknown"} seconds.',
      );
    }

    return response;
  }
}

class ApiQueue {
  final _requestPool = Pool(1);
  late final InterceptedClient _clientInternal;

  final RatelimitMiddleware rateLimits = RatelimitMiddleware();

  ApiQueue() {
    _clientInternal = InterceptedClient.build(
      interceptors: [rateLimits],
      requestTimeout: Duration(seconds: 5),
    );
  }

  Future<T> makeRequest<T>(Future<T> Function(http.Client) request) {
    return _requestPool.withResource(() => request(_clientInternal));
  }

  Future<void> dispose() async {
    _clientInternal.close();
    await _requestPool.close();
  }
}

class HandyWeb with EffectDispose {
  String _connectionKey = "";
  String _applicationKey = "";
  Map<String, String> _defaultHeaders = {};

  static final Uri baseApiUrl = Uri.parse(
    "https://www.handyfeeling.com/api/handy-rest/v3/",
  );

  ApiQueue _apiQueue = ApiQueue();

  StreamSubscription<String>? sseSubscription;

  ReadonlySignal<bool> get connected => _connected;
  final Signal<bool> _connected = signal(false);

  final Signal<HandyHspState?> _hspState = signal(null);
  late final ReadonlySignal<HspStateAdapter?> hspStateAdapter;

  final Signal<int> _strokeRangeMin;
  final Signal<int> _strokeRangeMax;
  final _applyStrokeRangeDebouncer = Debouncer(milliseconds: 500);

  HandyWeb(this._strokeRangeMin, this._strokeRangeMax) {
    effectAdd([
      effect(() {
        final min = (_strokeRangeMin.value / 100.0).clamp(0.0, 1.0);
        final max = (_strokeRangeMax.value / 100.0).clamp(0.0, 1.0);
        _applyStrokeRangeDebouncer.run(() {
          Logger.info("Stroke range set!");
          setSliderStroke(min, max);
        });
      }),
    ]);

    hspStateAdapter = computed(() {
      final state = _hspState.value;
      if (state == null) return null;
      final playState = switch (state.playState) {
        0 => HspStateAdapterPlayState.hspStateNotInitialized,
        1 => HspStateAdapterPlayState.hspStatePlaying,
        2 => HspStateAdapterPlayState.hspStateStopped,
        3 => HspStateAdapterPlayState.hspStatePaused,
        4 => HspStateAdapterPlayState.hspStateStarving,
        _ => throw UnimplementedError("Unknown playState"),
      };
      return HspStateAdapter(
        playState: playState,
        firstPointTime: state.firstPointTime,
        lastPointTime: state.lastPointTime,
        currentTime: state.currentTime,
        points: state.points,
        currentPoint: state.currentPoint,
        loop: state.loop,
        maxPoints: state.maxPoints,
        pauseOnStarving: state.pauseOnStarving,
        playbackRate: state.playbackRate,
        streamId: state.streamId,
        tailPointStreamIndex: state.tailPointStreamIndex,
        tailPointStreamIndexThreshold: state.tailPointStreamIndexThreshold,
      );
    });
  }

  // ReadonlySignal<bool> get connected => _connected;
  int estimatedAverageOffset = 0;
  Function(bool)? hspThresholdReached;
  Function()? hspLooped;

  int estimatedServerTime() =>
      DateTime.now().millisecondsSinceEpoch + estimatedAverageOffset;

  Future<bool> connect(String connectionKey, String applicationKey) async {
    _connectionKey = connectionKey;
    _applicationKey = applicationKey;
    _defaultHeaders = {
      "X-Connection-Key": _connectionKey,
      "X-Api-Key": _applicationKey,
    };

    _connected.value = false;
    await _apiQueue.dispose();
    _apiQueue = ApiQueue();

    final info = await getInfo();
    // if this doesn't return a result we are not connected
    if (!info.isResult) return false;

    // Sync time
    {
      const syncTries = 10;
      var offsetAggregated = 0.0;
      for (var index = 0; index < syncTries; index += 1) {
        final start = DateTime.now().millisecondsSinceEpoch;
        final server = (await getServerTime())!;
        final end = DateTime.now().millisecondsSinceEpoch;
        final rtd = end - start;
        final offset = (server + (rtd / 2.0)) - end;

        Logger.debug('RTD: $rtd\tOffset: $offset');

        offsetAggregated += offset;
        await Future.delayed(Duration(milliseconds: 300));
      }
      estimatedAverageOffset = (offsetAggregated / syncTries).round();
      Logger.debug("Estimated average offset: $estimatedAverageOffset");
      // I think this takes care of the clock offset??
      await htspClockSync();
    }

    sseSubscription = await subscribeToSse();
    if (sseSubscription == null) {
      _connected.value = false;
      return false;
    }
    _connected.value = true;

    // Retrieve stroke from device
    final stroke = await getSliderStroke();
    if (stroke.isResult) {
      final min = (stroke.result!.min * 100.0).round().clamp(0, 100);
      final max = (stroke.result!.max * 100.0).round().clamp(0, 100);
      _strokeRangeMin.value = min;
      _strokeRangeMax.value = max;
    }

    // TODO: handle battery??

    return _connected.value;
  }

  Future<void> disconnect() async {
    _connected.value = false;
    await sseSubscription?.cancel();
    sseSubscription = null;
    await _apiQueue.dispose();
  }

  Future<StreamSubscription<String>?> subscribeToSse() async {
    final url = baseApiUrl
        .resolve('sse')
        .replace(
          queryParameters: {'ck': _connectionKey, 'apikey': _applicationKey},
        );

    final request = http.Request("GET", url);
    request.headers['Cache-Control'] = 'no-cache';
    request.headers['Accept'] = 'text/event-stream';

    try {
      final response = await _apiQueue.makeRequest(
        (client) => client.send(request),
      );

      // Temp variables to hold parts of the event as they arrive
      String? currentId;
      String? currentEvent;
      String currentData = "";

      return response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
            (line) {
              if (line.isEmpty) {
                // An empty line indicates the end of an event block
                if (currentData.isNotEmpty) {
                  final event = HandySseEvent(
                    id: currentId,
                    event: currentEvent,
                    data: currentData.trim(),
                  );

                  _handleSseEvent(event); // Your logic here

                  // Reset for the next event
                  currentId = null;
                  currentEvent = null;
                  currentData = "";
                }
                return;
              }

              // Parse the line based on SSE spec "key: value"
              if (line.startsWith('id:')) {
                currentId = line.substring(3).trim();
              } else if (line.startsWith('event:')) {
                currentEvent = line.substring(6).trim();
              } else if (line.startsWith('data:')) {
                currentData += line.substring(5);
              }
            },
            onError: (e) => Logger.error("Stream Error: $e"),
            cancelOnError: true,
          );
    } catch (e) {
      Logger.error("Connection Error: $e");
    }
    return null;
  }

  void _handleSseEvent(HandySseEvent event) {
    final json = jsonDecode(event.data);
    debugPrint("sse event: ${event.event}");
    switch (event.event) {
      case "device_status": // Received when starting the SSE connection.
        final ev = HandyDeviceStatus.fromJson(json);
        _handleDeviceStatus(ev);
        break;
      case "device_disconnected": // Received when the device disconnects.
        disconnect();
        break;
      case "hsp_threshold_reached": // Received when the HSP data threshold is reached.
        final ev = HandyHspStatusEvent.fromJson(json);
        _hspState.value = ev.data;
        hspThresholdReached?.call(false);
        break;
      case "hsp_starving": // Received when the HSP is starving (no more data to play). Only sent if pause_on_starving is disabled.
        final ev = HandyHspStatusEvent.fromJson(json);
        _hspState.value = ev.data;
        hspThresholdReached?.call(true);
        break;
      case "hsp_looping": // Received when the HSP starts a new loop.
        final ev = HandyHspStatusEvent.fromJson(json);
        _hspState.value = ev.data;
        hspLooped?.call();
        break;
      case "hsp_state_changed": // Received when the HSP state have changed.
        final ev = HandyHspStatusEvent.fromJson(json);
        _hspState.value = ev.data;
        break;
      case "hsp_paused_on_starving": // Received when the HSP is paused due to starvation. Only sent if pause_on_starving is enabled.
        final ev = HandyHspStatusEvent.fromJson(json);
        _hspState.value = ev.data;
        break;
      case "hsp_resumed_on_not_starving": // Received when the HSP is resumed after starvation and playable data is available. Only sent if pause_on_starving is enabled.
        final ev = HandyHspStatusEvent.fromJson(json);
        _hspState.value = ev.data;
        break;

      case "battery_changed": // Received when the battery status have changed.
      case "ble_status_changed": // Received when the BLE status have changed.
      case "button_event": // Received in case of an unhandled button event. Eg. the user uses a device button in a way ignored by the current device mode.
      case "device_clock_synchronized": // Received when the device clock have finished synchronization with the server clock.
      case "device_connected": // Received when the device connects.
      case "device_error": // Received when a device error occurs.
      case "hamp_state_changed": // Received when the HAMP state have changed.
      case "hrpp_state_changed": // Received when the HRPP state have changed.
      case "hdsp_state_changed": // Received when the HDSP state have changed.
      case "stream_end_reached": // Received when the end of a closed stream have been reached. This includes scripts played with the HSSP protocol or closed streams played with STREAM protocol.
      case "hvp_state_changed": // Received when the HVP state changes.
      case "low_memory_error": // Received when the device failed to handle some command due to memory limitations.
      case "low_memory_warning": // Received when the device's available free memory is critically low.
      case "mode_changed": // Received when the device mode have changed.
      case "ota_progress": // Received when the OTA progress have changed.
      case "slider_blocked": // Received when the slider is blocked.
      case "slider_unblocked": // Received when the slider is unblocked.
      case "stroke_changed": // Received when the stroke region have changed.
      case "temp_high": // Received when the device temperature is high.
      case "temp_ok": // Received when the device temperature is back to normal.
      case "wifi_scan_complete": // Received when a device wifi scan have completed.
      case "wifi_status_changed": // Received when the wifi status have changed.
      default:
        debugPrint(event.data);
        debugPrint("Unhandled or unknown event ${event.event}");
        break;
    }
  }

  void _handleDeviceStatus(HandyDeviceStatus handyDeviceStatus) {}

  void _handleStateResponse(HandyResponse<HandyHspState> state) {
    if (state.isError) {
      Logger.error(state.error!.message);
    }
    _hspState.value = state.result;
  }

  Future<int?> getServerTime() async {
    // may be used when _connected.value == false
    final url = baseApiUrl.resolve('servertime');
    final response = await _apiQueue.makeRequest(
      (client) => client.get(url, headers: _defaultHeaders),
    );

    if (response.statusCode == 200) {
      var data = HandyServertime.fromJson(jsonDecode(response.body));
      return data.serverTime;
    }
    return null;
  }

  Future<HandyResponse<HandyConnected>> isConnected() async {
    // may be used when _connected.value == false
    final url = baseApiUrl.resolve('connected');
    final response = await _apiQueue.makeRequest(
      (client) => client.get(url, headers: _defaultHeaders),
    );

    if (response.statusCode == 200) {
      var data = HandyResponse<HandyConnected>.fromJson(
        jsonDecode(response.body),
        (json) => HandyConnected.fromJson(json as Map<String, dynamic>),
      );
      return data;
    }

    return HandyResponse.empty();
  }

  Future<HandyResponse<HandyInfo>> getInfo() async {
    // may be used when _connected.value == false
    final url = baseApiUrl.resolve('info');
    final response = await _apiQueue.makeRequest(
      (client) => client.get(url, headers: _defaultHeaders),
    );

    if (response.statusCode == 200) {
      var data = HandyResponse<HandyInfo>.fromJson(
        jsonDecode(response.body),
        (json) => HandyInfo.fromJson(json as Map<String, dynamic>),
      );
      return data;
    }
    return HandyResponse.empty();
  }

  Future<HandyResponse<HandyStrokeSettings>> getSliderStroke() async {
    if (!_connected.value) return HandyResponse.empty();
    final url = baseApiUrl.resolve('slider/stroke');
    final response = await _apiQueue.makeRequest(
      (client) => client.get(url, headers: _defaultHeaders),
    );

    if (response.statusCode == 200) {
      var data = HandyResponse<HandyStrokeSettings>.fromJson(
        jsonDecode(response.body),
        (json) => HandyStrokeSettings.fromJson(json as Map<String, dynamic>),
      );
      return data;
    }
    return HandyResponse.empty();
  }

  Future<HandyResponse<HandyStrokeSettings>> setSliderStroke(
    double min,
    double max,
  ) async {
    if (!_connected.value) return HandyResponse.empty();
    final request = HandyStrokeSet(min: min, max: max);
    final url = baseApiUrl.resolve('slider/stroke');
    final response = await _apiQueue.makeRequest(
      (client) => client.put(
        url,
        headers: _defaultHeaders,
        body: jsonEncode(request.toJson()),
      ),
    );

    if (response.statusCode == 200) {
      var data = HandyResponse<HandyStrokeSettings>.fromJson(
        jsonDecode(response.body),
        (json) => HandyStrokeSettings.fromJson(json as Map<String, dynamic>),
      );
      return data;
    }
    return HandyResponse.empty();
  }

  void hspSetup({int? streamId}) {
    if (!_connected.value) return;
    const int maxInt32 = 2147483647;
    streamId ??= Random().nextInt(maxInt32);
    final request = HspSetup(streamId: streamId);
    final url = baseApiUrl.resolve('hsp/setup');

    _apiQueue.makeRequest(
      (client) => client
          .put(
            url,
            headers: _defaultHeaders,
            body: jsonEncode(request.toJson()),
          )
          .then((response) {
            if (response.statusCode == 200) {
              var state = HandyResponse<HandyHspState>.fromJson(
                jsonDecode(response.body),
                (json) => HandyHspState.fromJson(json as Map<String, dynamic>),
              );
              _handleStateResponse(state);
            }
          }),
    );
  }

  void hspAdd(
    List<FunscriptAction> points, {
    required bool flush,
    required int? tailPointStreamIndex,
    required int? tailPointThreshold,
  }) {
    if (!_connected.value) return;
    final request = HspAdd(
      points: points.map((a) => HspAddPoint(t: a.at, x: a.pos)).toList(),
      flush: flush,
      tailPointStreamIndex: tailPointStreamIndex,
      tailPointThreshold: tailPointThreshold,
    );

    {
      final url = baseApiUrl.resolve('hsp/add');
      _apiQueue.makeRequest(
        (client) => client
            .put(
              url,
              headers: _defaultHeaders,
              body: jsonEncode(request.toJson()),
            )
            .then((response) {
              if (response.statusCode == 200) {
                var state = HandyResponse<HandyHspState>.fromJson(
                  jsonDecode(response.body),
                  (json) =>
                      HandyHspState.fromJson(json as Map<String, dynamic>),
                );
                _handleStateResponse(state);
              }
            }),
      );

      if (tailPointThreshold != null) {
        // manually set the threshold
        final request = HspThreshold(tailPointThreshold: tailPointThreshold);
        final url = baseApiUrl.resolve('hsp/threshold');
        _apiQueue.makeRequest(
          (client) => client
              .put(
                url,
                headers: _defaultHeaders,
                body: jsonEncode(request.toJson()),
              )
              .then((response) {
                if (response.statusCode == 200) {
                  var state = HandyResponse<HandyHspState>.fromJson(
                    jsonDecode(response.body),
                    (json) =>
                        HandyHspState.fromJson(json as Map<String, dynamic>),
                  );
                  _handleStateResponse(state);
                }
              }),
        );
      }
    }
  }

  void hspCurrentTimeSet({required int currentTime, required double filter}) {
    if (!_connected.value) return;
    final request = HspSynctime(
      currentTime: currentTime,
      serverTime: estimatedServerTime(),
      filter: filter,
    );
    final url = baseApiUrl.resolve('hsp/synctime');
    _apiQueue.makeRequest(
      (client) => client
          .put(
            url,
            headers: _defaultHeaders,
            body: jsonEncode(request.toJson()),
          )
          .then((response) {
            if (response.statusCode == 200) {
              var state = HandyResponse<HandyHspState>.fromJson(
                jsonDecode(response.body),
                (json) => HandyHspState.fromJson(json as Map<String, dynamic>),
              );
              _handleStateResponse(state);
            }
          }),
    );
  }

  void hspFlush() {
    if (!_connected.value) return;
    final url = baseApiUrl.resolve('hsp/flush');
    _apiQueue.makeRequest(
      (client) => client.put(url, headers: _defaultHeaders, body: null).then((
        response,
      ) {
        if (response.statusCode == 200) {
          var state = HandyResponse<HandyHspState>.fromJson(
            jsonDecode(response.body),
            (json) => HandyHspState.fromJson(json as Map<String, dynamic>),
          );
          _handleStateResponse(state);
        }
      }),
    );
  }

  void hspPause() {
    if (!_connected.value) return;
    final url = baseApiUrl.resolve('hsp/pause');
    _apiQueue.makeRequest(
      (client) => client.put(url, headers: _defaultHeaders, body: null).then((
        response,
      ) {
        if (response.statusCode == 200) {
          var state = HandyResponse<HandyHspState>.fromJson(
            jsonDecode(response.body),
            (json) => HandyHspState.fromJson(json as Map<String, dynamic>),
          );
          _handleStateResponse(state);
        }
      }),
    );
  }

  void hspPlay({
    required int startTime,
    required double playbackRate,
    required bool loop,
    required bool pauseOnStarving,
  }) {
    if (!_connected.value) return;
    final request = HspPlay(
      startTime: startTime,
      serverTime: estimatedServerTime(),
      playbackRate: playbackRate,
      pauseOnStarving: pauseOnStarving,
      loop: loop,
    );
    final url = baseApiUrl.resolve('hsp/play');
    _apiQueue.makeRequest(
      (client) => client
          .put(
            url,
            headers: _defaultHeaders,
            body: jsonEncode(request.toJson()),
          )
          .then((response) {
            if (response.statusCode == 200) {
              var state = HandyResponse<HandyHspState>.fromJson(
                jsonDecode(response.body),
                (json) => HandyHspState.fromJson(json as Map<String, dynamic>),
              );
              _handleStateResponse(state);
            }
          }),
    );
  }

  void hspResume() {
    if (!_connected.value) return;
    final request = HspResume(pickUp: true);
    final url = baseApiUrl.resolve('hsp/resume');
    _apiQueue.makeRequest(
      (client) => client
          .put(
            url,
            headers: _defaultHeaders,
            body: jsonEncode(request.toJson()),
          )
          .then((response) {
            if (response.statusCode == 200) {
              var state = HandyResponse<HandyHspState>.fromJson(
                jsonDecode(response.body),
                (json) => HandyHspState.fromJson(json as Map<String, dynamic>),
              );
              _handleStateResponse(state);
            }
          }),
    );
  }

  void hspStop() {
    if (!_connected.value) return;
    final url = baseApiUrl.resolve('hsp/stop');
    _apiQueue.makeRequest(
      (client) => client.put(url, headers: _defaultHeaders, body: null).then((
        response,
      ) {
        if (response.statusCode == 200) {
          var state = HandyResponse<HandyHspState>.fromJson(
            jsonDecode(response.body),
            (json) => HandyHspState.fromJson(json as Map<String, dynamic>),
          );
          _handleStateResponse(state);
        }
      }),
    );
  }

  void hspLoop(bool loop) {
    if (!_connected.value) return;
    final request = HspLoop(loop: loop);
    final url = baseApiUrl.resolve('hsp/loop');
    _apiQueue.makeRequest(
      (client) => client
          .put(
            url,
            headers: _defaultHeaders,
            body: jsonEncode(request.toJson()),
          )
          .then((response) {
            if (response.statusCode == 200) {
              var state = HandyResponse<HandyHspState>.fromJson(
                jsonDecode(response.body),
                (json) => HandyHspState.fromJson(json as Map<String, dynamic>),
              );
              _handleStateResponse(state);
            }
          }),
    );
  }

  void hspPauseOnStarving(bool pauseOnStarving) {
    if (!_connected.value) return;
    final request = HspPauseOnStarving(pauseOnStarving: pauseOnStarving);
    final url = baseApiUrl.resolve('hsp/pause/onstarving');
    _apiQueue.makeRequest(
      (client) => client
          .put(
            url,
            headers: _defaultHeaders,
            body: jsonEncode(request.toJson()),
          )
          .then((response) {
            if (response.statusCode == 200) {
              var state = HandyResponse<HandyHspState>.fromJson(
                jsonDecode(response.body),
                (json) => HandyHspState.fromJson(json as Map<String, dynamic>),
              );
              _handleStateResponse(state);
            }
          }),
    );
  }

  void positionWithDuration(double relPos, int moveOverTimeMs) {
    if (!_connected.value) return;
    final request = HdspXpt(
      xp: relPos.clamp(0, 1.0),
      t: moveOverTimeMs,
      stopOnTarget: true,
      immediateRsp: false,
    );
    final url = baseApiUrl.resolve('hdsp/xpt');
    _apiQueue.makeRequest(
      (client) => client
          .put(
            url,
            headers: _defaultHeaders,
            body: jsonEncode(request.toJson()),
          )
          .then((response) {
            if (response.statusCode == 200) {
              // responds with {"result": "ok"}
            }
          }),
    );
  }

  Future<HandyClock?> htspClockSync() async {
    if (!_connected.value) return null;
    final url = baseApiUrl
        .resolve('hstp/clocksync')
        .replace(queryParameters: {'s': "true"});

    final response = await _apiQueue.makeRequest(
      (client) => client.get(url, headers: _defaultHeaders),
    );
    if (response.statusCode == 200) {
      var clock = HandyResponse<HandyClock>.fromJson(
        jsonDecode(response.body),
        (json) => HandyClock.fromJson(json as Map<String, dynamic>),
      );
      return clock.result;
    }
    return null;
  }
}
