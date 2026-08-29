# HereSphere Streaming and Handy Playback Integration Plan

## Status

Proposed advanced experimental feature.

## Objective

Allow HereSphere on Windows or a standalone headset to browse and stream videos from Syncopathy while Syncopathy remains the sole owner of funscript processing and Handy playback.

HereSphere is the authoritative video player. Syncopathy supplies media and metadata, observes HereSphere's playback clock, resolves the selected media to its local funscript, and drives the configured Handy backend.

## Non-goals

- Do not embed or automate HereSphere itself.
- Do not have two players decode the same video and attempt to stay synchronized.
- Do not infer playback position from HTTP download progress.
- Do not let HereSphere and Syncopathy command the same Handy simultaneously.
- Do not add transcoding in the first version.
- Do not support this feature in the Syncopathy web build.
- Do not support multiple concurrent HereSphere sessions in the first version.

## Current Architecture Impact

The device side is already close to what this feature needs:

- `TimesourceModel` exposes position, pause state, playback speed, seeking, duration, loop state, and related signals.
- Handy HSP backends consume that timesource and already handle buffering actions, pause/resume, seeks, and periodic clock correction.
- `MediaFile` already provides a stable media hash, path, funscript relations, and video metadata.

The coupling that must be removed is at application initialization and in `PlayerModel`:

- `TimesourceModel` is always created from `VideoPlayer`.
- `PlayerModel` also reads `VideoPlayer.currentMedia`, duration, speed, and seek methods directly.
- Skip-to-first-stroke assumes the local player owns seeking.

The implementation should introduce a playback-session boundary instead of adding HereSphere-specific branches throughout these classes.

## Target Architecture

```text
Syncopathy                         HereSphere
-----------                       ----------
HereSphere JSON API  -----------> Native media library UI
HTTP Range streamer  -----------> Video decoder
Playback event API    <----------- open/play/pause/close events
Timestamp client      <----------> TCP state/control protocol
        |
        v
HereSpherePlaybackSession
        |
        v
TimesourceModel -> PlayerModel -> Funscript processing -> Handy backend
```

## Protocol Strategy

Use three complementary channels.

### 1. HereSphere JSON web API

Expose a small library API with the `HereSphere-JSON-Version: 1` response header:

- Library endpoint containing sections and per-video metadata URLs.
- Per-video endpoint containing title, duration, dimensions, projection data when known, thumbnail URL, media source URL, and `eventServer` URL.
- Initially omit the `scripts` field so HereSphere cannot take ownership of the funscript.
- An `Interactive` display tag may be included without exposing the script.

Use opaque media identifiers derived from stable application state. Never put a filesystem path in a route or trust a path supplied by the client.

### 2. HTTP byte-range streaming

Serve local media through an endpoint that supports:

- `GET` and `HEAD`.
- Open-ended and suffix `Range` requests.
- `206 Partial Content` and correct `Content-Range` headers.
- `416 Range Not Satisfiable` for invalid ranges.
- `Accept-Ranges: bytes`, content length, and a suitable content type.
- Backpressure and request cancellation without loading the file into memory.
- Multiple sequential seek requests against very large files.

The route must resolve an opaque ID to an indexed `MediaFile`; it must never accept an arbitrary local path.

### 3. Playback state and clock synchronization

Use both HereSphere mechanisms:

- The per-video `eventServer` receives prompt `open`, `play`, `pause`, and `close` transitions with media time, playback speed, and UTC time.
- The DeoVR-compatible TCP timestamp server, normally on port `23554`, supplies periodic authoritative state and acts as a heartbeat. It can also receive seek, speed, play/pause, and path commands if Syncopathy controls are enabled later.

Events handle low-latency state changes. TCP snapshots detect seeks and correct drift. Loss of the timestamp heartbeat must stop Handy playback rather than allow an extrapolated clock to continue unattended.

## Proposed Components

### `PlaybackSession`

Introduce an interface representing the player that owns the media clock:

- Signals: current media, duration, paused, buffering, seeking, raw position, smooth position, playback speed, looping, width, height, and connection health.
- Optional commands: open media, close, seek, play/pause, set speed, and loop.
- Capability flags for commands not supported by every implementation.

Implement:

- `MediaKitPlaybackSession`, adapting the current `VideoPlayer`.
- `HereSpherePlaybackSession`, adapting event and TCP state.

`TimesourceModel` should be built from `PlaybackSession`. `PlayerModel` should depend on the session for current media and optional seek operations.

### `HereSphereServer`

A native-only service responsible for:

- Binding an explicitly configured interface and port.
- Generating the advertised base URL.
- Serving JSON API, thumbnails, events, and media ranges.
- Tracking one active client/session.
- Enforcing session tokens and request limits.
- Clean shutdown when the feature or application stops.

### `HereSphereTimestampClient`

A client for the length-prefixed JSON TCP protocol:

- Connect to a configured HereSphere address and port.
- Decode `resource` or `path`, duration, current time, speed, and player state.
- Send an empty keepalive packet at the required interval.
- Detect disconnects and reconnect with bounded backoff.
- Optionally send commands only when the corresponding UI capability is enabled.

### `HereSphereMediaResolver`

Map API identifiers, event identifiers, and streamed resource URLs to `MediaFile` by stable ID or hash. Filename fallback should only exist for externally opened files and must never outrank an exact API identifier.

## Playback-State Rules

- Treat HereSphere as authoritative whenever the external session is active.
- Extrapolate smooth position from the latest authoritative media time, playback speed, event UTC, and local monotonic time.
- Correct extrapolated position on every timestamp packet.
- Detect a seek when the new position differs materially from the predicted position; pulse `seeking` and let HSP rebuild its buffer.
- Treat a backward jump near the end/start boundary as a possible loop; confirm behavior during the protocol spike.
- Treat explicit pause, close, timeout, TCP disconnect, or media-identity loss as paused and stop/pause HSP immediately.
- Do not infer player buffering from HTTP reads. Determine whether HereSphere reports a pause/stall event; otherwise add a conservative stalled-clock detector.
- Apply the current Syncopathy offset after resolving HereSphere media time, as existing backends do.

## User Experience

Add an experimental HereSphere section to settings:

- Enable HereSphere server.
- Listen interface and port.
- Display the URL to enter in HereSphere, with copy action.
- HereSphere timestamp host and port.
- Connection status for API client, timestamp channel, and Handy.
- Test connection action.
- Optional `Open selected media in HereSphere` capability after outbound commands are proven.
- Clear warning that HereSphere synchronized peripherals must remain disabled when Syncopathy owns the Handy.

When external playback is active, the regular player page should clearly indicate that HereSphere owns video controls. Unsupported local controls should be disabled rather than silently doing nothing.

## Security and Privacy

- Default to disabled.
- Prefer binding to a selected private-network interface instead of every interface.
- Include an unguessable session token in every library, thumbnail, event, and stream URL.
- Resolve only application-issued IDs and reject path traversal or arbitrary file paths.
- Never log tokens or complete media paths at normal log levels.
- Limit request headers and range sizes defensively.
- Allow only one active HereSphere client in the first version.
- Document the operating-system firewall prompt and the fact that enabling the server exposes selected media to the local network.
- Stop the server and invalidate tokens when the feature is disabled.

## Implementation Phases

### Phase 0: Protocol spike

- [ ] Verify current Windows HereSphere and standalone headset behavior.
- [ ] Capture event sequences for open, play, pause, seek, speed change, loop, end, buffering, headset sleep, and application close.
- [ ] Confirm event time and UTC units and whether seeks emit immediate events.
- [ ] Confirm TCP packet framing, cadence, state values, keepalive timeout, and `resource`/`identifier` behavior.
- [ ] Verify direct HTTP streaming and seeking for MP4, MKV, and a large 8K file.
- [ ] Decide which signals can be reported directly and which need inference.

Exit criterion: a small harness can identify a streamed media item and maintain a measured clock through play, pause, and seek without controlling a real device.

### Phase 1: Playback-session refactor

- [ ] Define `PlaybackSession` and capability flags.
- [ ] Adapt the existing media-kit player without changing current behavior.
- [ ] Change `TimesourceModel` and `PlayerModel` to depend on the session boundary.
- [ ] Make skip-to-first-stroke conditional on remote-seek capability.
- [ ] Add unit tests proving the media-kit adapter preserves current signals and commands.

Exit criterion: all existing tests pass and local playback behavior is unchanged.

### Phase 2: Single-video streaming server

- [ ] Add native server lifecycle management.
- [ ] Implement tokenized single-video metadata, thumbnail, event, and stream endpoints.
- [ ] Implement standards-compliant byte-range handling.
- [ ] Add a minimal settings/status panel.
- [ ] Test sustained throughput and seeking without excessive memory growth.

Exit criterion: HereSphere can open, seek, and play one Syncopathy-selected video over localhost and LAN.

### Phase 3: HereSphere playback session

- [ ] Parse and validate event-server messages.
- [ ] Implement the TCP timestamp client and keepalive.
- [ ] Resolve the current API media ID to `MediaFile` and its selected funscript.
- [ ] Produce raw and smooth position signals.
- [ ] Implement seek/discontinuity detection and connection-loss fail-safe behavior.
- [ ] Drive a fake backend through the full playback-state matrix.

Exit criterion: fake-device playback stays aligned through play, pause, seek, speed change, and disconnect.

### Phase 4: Handy integration

- [ ] Exercise command, Bluetooth HSP, and Web HSP backends.
- [ ] Verify buffer rebuilds for seeks inside and outside the current HSP window.
- [ ] Measure steady-state and post-seek clock deltas.
- [ ] Confirm pause and disconnect stop device movement promptly.
- [ ] Add explicit external-session ownership indicators and warnings.

Exit criterion: the Handy is driven only by Syncopathy and remains acceptably synchronized during normal playback and recovery cases.

### Phase 5: Library browsing and polish

- [ ] Publish useful Syncopathy categories or bounded library sections.
- [ ] Include cached JPEG thumbnails and known media metadata.
- [ ] Add projection/stereo metadata where Syncopathy can determine it safely.
- [ ] Add reconnect diagnostics and actionable error messages.
- [ ] Consider outbound open/seek/play commands as a separate opt-in capability.

## Test Matrix

Cover at least:

- Windows HereSphere and standalone headset HereSphere.
- Same-machine localhost and headset-to-PC LAN connections.
- MP4 and MKV, short and multi-hour media, and high-bitrate 8K media.
- Initial play, pause/resume, repeated scrub seeks, large seeks, playback speed changes, natural end, and looping.
- Buffering or Wi-Fi interruption, timestamp disconnect, HTTP disconnect, headset sleep, Syncopathy restart, and Handy reconnect.
- Bluetooth HSP, Web HSP, and command backends.
- Invalid ranges, malformed JSON, stale tokens, unknown IDs, and simultaneous-client attempts.

## Acceptance Criteria

- HereSphere can browse at least one Syncopathy library section and stream indexed media with working seek.
- Syncopathy selects the correct `MediaFile` and funscript by opaque identifier, without relying on the client filesystem path.
- Steady playback uses a smoothly advancing clock and periodic authoritative correction.
- Play, pause, seek, and speed changes propagate to the Handy within measured and documented bounds.
- A lost or stale HereSphere session stops Handy playback safely.
- HereSphere receives no funscript URL and does not control the Handy.
- Existing local playback remains unchanged when the experiment is disabled.
- The server is off by default and does not expose arbitrary files.

## Risks and Open Questions

- Complete HereSphere API documentation is distributed through its Discord, so current event semantics must be validated against real builds.
- Event behavior during buffering, looping, and seeking may require conservative inference.
- One-second timestamp snapshots are insufficient for prompt pause handling by themselves; event callbacks must prove reliable.
- HereSphere codec support varies by platform. Direct streaming cannot repair unsupported encodings.
- Very large libraries may need pagination-like sections or explicit limits.
- If timestamp-server configuration cannot be discovered reliably, headset address and port will require manual setup.

## Rough Effort

- Protocol proof of concept: 2-4 developer days.
- Single-client MVP: 1-2 weeks.
- Production-quality settings, security, recovery, library browsing, and platform coverage: 2-4 weeks total.

## References

- [HereSphere FAQ](https://heresphere.com/faq/)
- [HereSphere event-server release notes](https://steamdb.info/patchnotes/10273519/)
- [Current Stash-VR HereSphere API model](https://raw.githubusercontent.com/o-fl0w/stash-vr/master/internal/api/heresphere/videodata.go)
- [Current Stash-VR event payload](https://raw.githubusercontent.com/o-fl0w/stash-vr/master/internal/api/heresphere/event.go)
- [Current XBVR HereSphere API implementation](https://raw.githubusercontent.com/xbapps/xbvr/master/pkg/api/heresphere.go)
- [Current MultiFunPlayer HereSphere timestamp client](https://raw.githubusercontent.com/Yoooi0/MultiFunPlayer/master/Source/MultiFunPlayer/MediaSource/ViewModels/HereSphereMediaSource.cs)
- [DeoVR remote-control protocol](https://deovr.com/documentation#remote-control)

