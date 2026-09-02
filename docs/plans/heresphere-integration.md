# HereSphere Streaming and Handy Playback Integration Plan

## Status

Experimental. Phases 1 through 5 are implemented and covered by automated tests.
What remains is the protocol spike (phase 0) and the hardware and headset
verification in phase 4, both of which need a real HereSphere build and a real
device; the code was written against the reference implementations listed at the
end and is unproven against the player itself.

## Objective

Allow HereSphere on Windows or a standalone headset to browse and stream videos from Syncopathy, with funscript playback available through either application.

HereSphere is always the authoritative video player. Which application drives the device is a user choice, made explicitly in settings:

- **Syncopathy drives the device** (default). Syncopathy supplies media and metadata, observes HereSphere's playback clock, resolves the selected media to its local funscript, and drives the configured Handy backend. Syncopathy's own processing - stroke range, intensity, smoothing, inversion - applies, and no script URL is published.
- **HereSphere drives the device.** Syncopathy publishes funscript URLs alongside the video and is a media server and nothing more. HereSphere's synchronized peripherals apply their own settings to the stored script.

Only one of them may command the device at a time. The mode is what makes that explicit rather than something the user has to infer from a stroker behaving oddly.

## Non-goals

- Do not embed or automate HereSphere itself.
- Do not have two players decode the same video and attempt to stay synchronized.
- Do not infer playback position from HTTP download progress.
- Do not let HereSphere and Syncopathy command the same Handy simultaneously. Either may command it; never both, and never implicitly.
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
- A bulk metadata endpoint at `/scan`, describing every entry in one response.
- Publish the `scripts` field only in the mode where HereSphere drives the device. Omitting it is what keeps HereSphere from taking ownership of the funscript.
- Publish `tags` in both modes. They mark the entry as interactive without exposing the script, and they are what the player's own filtering works on.

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

An experimental HereSphere card in settings, holding:

- Enable HereSphere server.
- Listen interface and port.
- The URL to enter in HereSphere, with a copy action, and a *Generate a new
  link* action that invalidates the old one.
- Which application drives the device, as two mutually exclusive options with
  their consequences spelled out - not a toggle, because they are two different
  arrangements rather than one feature with an on and an off.
- HereSphere timestamp host and port, shown only in the mode that uses them.
- Live status for the server, the timestamp channel, and the connected client.
- An opt-in for outbound commands.

Status lines say what the state means for the device, not just what it is:
"connected, but HereSphere has stopped reporting - the device is held" rather
than a red dot. The two failure modes a user cannot see from outside are a
socket that is open but silent, and a device connection that is still live in
the mode where it should not be; both are called out explicitly, the second with
a *Disconnect* action beside it.

When external playback is active the player page is covered by an ownership
panel naming the media, the clock, and whether the device is being driven.
Covering the surface is how the local controls are disabled - they belong to a
player that is not the one playing.

## Security and Privacy

- Default to disabled.
- Require a username and password before anything about the library is revealed.
- Prefer binding to a selected private-network interface instead of every interface.
- Include an unguessable session token in every library, thumbnail, event, and stream URL.
- Resolve only application-issued IDs and reject path traversal or arbitrary file paths.
- Never log tokens, passwords, or complete media paths at normal log levels.
- Limit request headers, request bodies, and range sizes defensively.
- Allow only one active HereSphere client in the first version.
- Document the operating-system firewall prompt and the fact that enabling the server exposes selected media to the local network.
- Stop the server and invalidate sessions when the feature is disabled.

### Authentication

HereSphere's own mechanism, which is the only one the player can drive: the
client posts `username` and `password` to the library endpoint, and the server
answers with an `access` field — `0` to make it prompt, `-1` for a wrong answer,
`1` to hand over the library.

**Two credentials, because there are two kinds of request.** The JSON API can
carry a login; the byte-serving routes cannot. Media, thumbnail, script and
event requests come from the video player as plain GETs with no body, so a
password has nowhere to travel. A session token in the path stands in for one on
those routes, and it is minted only by a successful login — a consequence of
authenticating rather than a replacement for it.

That also removed the worst part of the earlier design. The token used to be
persistent and typed by hand, which is why it had to be short enough to enter on
a headset keyboard. Now the only thing a person types is `http://<address>:<port>`
and then their password when prompted; every tokenised URL is issued by the
server and never read by a human, so tokens are 22 characters of full alphabet
and expire.

Decisions worth recording:

- **The password is stored only as a salted PBKDF2-HMAC-SHA256 hash**
  (120k iterations, `pbkdf2-sha256$<iterations>$<salt>$<key>`). The settings
  file is plain JSON in the application data directory and it travels in bug
  reports; a recovered password would be worth more than the media it guards,
  because people reuse them. The cost is that it cannot be displayed again — a
  forgotten password is replaced, not looked up. The derivation runs on its own
  isolate, because the same event loop is streaming video and a 150ms stall
  would be a visible hitch.

- **No password set means nobody gets in, not everybody.** The server still
  binds — not binding would read as the feature being broken — and refuses every
  login, with the settings panel saying so plainly.

- **Failed logins are rate-limited per address**: five wrong answers and that
  address is refused for a minute, right answer included. A local network is not
  a safe place to leave an unlimited password oracle; anything on it can guess as
  fast as the server will answer. The blank login HereSphere sends *before* it
  prompts is not counted as a failure, or a player that asks twice would spend
  the user's budget before they had typed anything.

- **Changing the password signs every device out.** A session token issued
  against the old credentials would otherwise outlive them, and a password
  change that leaves existing access intact is not a password change.

- **A stale token on a JSON route answers `access: 0`, not `404`.** That sends
  HereSphere back to log in; a 404 would leave it holding a dead library with
  nothing to act on. The byte routes still answer 404, since a video decoder has
  no use for an access field.

- Both the password and the username are compared in constant time, and a wrong
  username still pays the full derivation, so neither the timing nor the latency
  says which half was wrong.

- **A generated password is three words, not sixteen random characters.**
  `river-gold-lamp`. The first version drew sixteen characters from an
  unambiguous alphabet, about eighty bits — and optimised the wrong thing. This
  password is typed once, on a headset keyboard, from a string read off a
  monitor across the room; transcription is the hard part and entropy per
  character is not. Three words from a 344-word list is roughly twenty-five
  bits, tens of millions of combinations. Against a lockout that answers five
  wrong guesses per address per minute, that is already unreachable — the
  lockout, not the password, is what makes guessing pointless, and it was doing
  that job at eighty bits too. Nothing stops a user typing whatever they like
  instead; this is only what the generator suggests.

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

- [x] Define `PlaybackSession` and capability flags.
- [x] Adapt the existing media-kit player without changing current behavior.
- [x] Change `TimesourceModel` and `PlayerModel` to depend on the session boundary.
- [x] Make skip-to-first-stroke conditional on remote-seek capability.
- [x] Add unit tests covering the session boundary.

Exit criterion: all existing tests pass and local playback behavior is unchanged.

Three things landed differently than written above:

- **Capabilities are a signal, not a fixed set.** An external session gains and
  loses the right to be commanded as its connection comes and goes, so
  `capabilities` is a `ReadonlySignal<Set<PlaybackCapability>>` and UI can
  disable a control reactively.
- **Sessions are reached through `ActivePlaybackSession`.** Had `TimesourceModel`
  captured one player's signal instances, handing the clock to HereSphere would
  mean rebuilding the timesource and, through it, every `PlayerBackend` — which
  drops a live Handy connection on every handover. Instead the timesource is
  built from `computed`s over `ActivePlaybackSession.session`, so a handover is a
  single assignment that the backends never see. `TimesourceModel.paused` also
  folds in `connected`, so a session that loses its heartbeat reads as paused
  rather than letting an uncorrected extrapolated clock keep driving the device.
- **`TimesourceModel.volume` is gone.** No backend read it, and audio volume is a
  local-player control an externally owned session has no answer for. It stays on
  `VideoPlayer`.

The abstraction is two layers, not one. `PlaybackSession` is the clock, the media
identity, and the capability-gated transport — all the funscript/device pipeline
needs. `VideoPlayer extends PlaybackSession` adds the local-playback surface
(volume, playlist, shuffle, screenshot, and a `buildVideoSurface()` that keeps
the `media_kit_video` widget private to the implementation). The video UI still
talks to `VideoPlayer`; making it session-agnostic belongs with the ownership
indicators in Phase 4.

Unit tests cover the boundary itself — capability gating, the derived position
signals, handover, and the connection-loss fail-safe — driven by a
`FakePlaybackSession` in `test/playback_session_test.dart`. The media-kit adapter
is not unit tested: it needs a live libmpv, so it stays covered by the manual
test matrix below.

### Phase 2: Single-video streaming server

- [x] Add native server lifecycle management.
- [x] Implement tokenized single-video metadata, thumbnail, event, and stream endpoints.
- [x] Implement standards-compliant byte-range handling.
- [x] Add a minimal settings/status panel.
- [ ] Test sustained throughput and seeking without excessive memory growth.

Exit criterion: HereSphere can open, seek, and play one Syncopathy-selected video over localhost and LAN.

Everything lives under `lib/heresphere/`. `HereSphereServer` is a plain
`dart:io` `HttpServer` — no `shelf` dependency, because the whole surface is
five routes and the one part that needs care is the `Range` header, which a
framework would not have helped with. `HereSphereController` owns its lifecycle
from settings; the server itself has no opinion about persistence, so a test can
bind one directly.

The library is reached through a `HereSphereLibrary` interface rather than
ObjectBox. `MediaLibraryHereSphereSource` implements it over `MediaService` and
`ThumbnailGenerator`; the request handling is tested against a fake and never
holds a database handle.

Four things landed differently than written above:

- **The URL a person types carries no secret.** An earlier version put a
  persistent token in it, which forced the token to be short enough to enter on
  a headset keyboard. Authentication replaced that: the typed URL is just
  `http://<address>:<port>`, the password is prompted for by the player, and the
  tokens in every other URL are issued by the server. See **Authentication**
  above. The generated password is the one thing still entered by hand, and it
  is generated accordingly.

- **URLs are derived from the request's own `Host` header, not from a
  configured advertised base.** A headset reaching the LAN address and a browser
  reaching loopback then both get URLs that work, without the user having to
  declare which address to advertise. The header is client-controlled, so it is
  validated and falls back to the bound address; it is only ever reflected to
  the client that sent it. The settings panel enumerates interfaces for display
  only, and lists just the bound address when one interface is selected — an
  address the server is not listening on would be a link that silently fails.

- **Projection, stereo layout, and `fov` are omitted rather than guessed.**
  Syncopathy cannot yet determine them, and sending a wrong value overrides
  HereSphere's own filename-based detection. Publishing nothing leaves that
  detection in charge. Adding them is a phase 5 item.

- **The event endpoint exists but nothing consumes it.** Payloads are parsed
  into `HereSphereEvent` and published on `HereSphereServer.events`; the session
  that turns them into a clock is phase 3. It answers `200` even to a malformed
  body — a rejection tells the player nothing useful, and an endpoint that looks
  broken risks it giving up on events altogether.

Two decisions worth recording:

- **`scripts` is absent from every response, and that is asserted in a test.**
  It is the one field that would let HereSphere drive the device. The entry is
  still marked with an `Interactive` tag, which says a script exists without
  handing it over.

- **One client at a time, keyed on remote address.** `ClientClaim` holds the
  session for ten minutes past the last request — long enough to outlast the
  quiet stretch between a library scan and opening a video. All loopback
  addresses collapse to one key, since a local client arrives as `127.0.0.1` or
  `::1` from one request to the next and treating those as rivals would lock the
  user out of their own server. (Narrowed in phase 5 to the event route alone —
  see *The claim guards the clock, not the library*.)

Byte-range handling follows RFC 9110: open-ended, closed, and suffix forms;
`206` with `Content-Range`; `416` with `bytes */<length>` for a range past the
end; and a header that is invalid, in an unknown unit, or asking for more than
one range is *ignored* rather than rejected, which means serving the full
representation. `resolveRange` is pure and holds every one of those rules, so
they are decided in one place and tested without a socket. The file is never
read into memory — `openRead` yields chunks and `addStream` pauses it when the
socket buffer fills — and a client hanging up mid-response is treated as
routine, because that is exactly what a seek is.

Still open at the end of this phase, and deliberately so:

- Sustained-throughput and memory behaviour under a real multi-hour 8K file
  needs measuring against real HereSphere; it stays in the manual matrix below.
- The refuse-a-second-driver path is covered end to end by injecting a claim
  already held by another address, since both ends of a loopback test key as
  the same client and cannot otherwise be told apart.
- Sections are `Interactive` and `Other Videos`, each capped at 500 entries. A
  larger library silently publishes only its first 500 per section until phase 5
  carves it up properly.

### Phase 3: HereSphere playback session

- [x] Parse and validate event-server messages.
- [x] Implement the TCP timestamp client and keepalive.
- [x] Resolve the current API media ID to `MediaFile` and its selected funscript.
- [x] Produce raw and smooth position signals.
- [x] Implement seek/discontinuity detection and connection-loss fail-safe behavior.
- [x] Drive a fake backend through the full playback-state matrix.

Exit criterion: fake-device playback stays aligned through play, pause, seek, speed change, and disconnect.

`HereSpherePlaybackSession` is fed by both channels and reuses
`SmoothVideoSignals` for extrapolation, so its clock behaves like the local
player's rather than being a second implementation of the same idea.
`HereSphereTimestampClient` owns the socket; the framing it speaks is pure and
lives in `timestamp_protocol.dart`, tested without one.

Four things are worth recording:

- **Stall detection has to run before seek detection.** Once the prediction has
  run a second ahead of a frozen clock, a stall and a jump backwards look
  identical - both arrive as a large negative drift. What separates them is not
  the distance from the *prediction* but the distance from the *previous
  report*: a stalled clock has barely moved, a seek has moved a long way. The
  first draft checked seeks first and so never detected a stall at all. The rule
  now is: if the clock advanced by less than a tenth of what was predicted, over
  an interval long enough to judge, it is stalled.

- **A lost heartbeat does not hand ownership back.** The obvious design - own
  the clock only while connected - makes a brief dropout bounce playback to the
  local player, which unloads the funscript and reloads it on reconnect.
  Ownership is keyed on resolved media instead; a dropped channel leaves
  HereSphere in charge with `connected` false, which `TimesourceModel` folds
  into `paused`. Same fail-safe, no churn.

- **`setChannelHealthy` reads its own signal untracked.** It is called from an
  effect watching the channel's health, and its `if (current == next) return`
  guard made that effect depend on the signal it was about to write - so the
  effect re-ran and immediately undid itself. Caught by the ownership tests,
  which is the only reason it is not a silent "the device never starts" bug.

- **An unknown player state counts as paused.** Both on the timestamp channel
  and in the event decoder. Guessing "playing" for a value this build does not
  understand would keep a device running on an unverified clock.

Media resolution is ordered: the `id` from an event first, then the identifier
carved out of a streamed `resource` URL, then - only for a file HereSphere
opened by itself - a filename match, and only when exactly one entry matches.
An ambiguous filename resolves to nothing, because the wrong script driving a
device is worse than no script.

### Phase 4: Handy integration

- [x] Add explicit external-session ownership indicators and warnings.
- [ ] Exercise command, Bluetooth HSP, and Web HSP backends.
- [ ] Verify buffer rebuilds for seeks inside and outside the current HSP window.
- [ ] Measure steady-state and post-seek clock deltas.
- [ ] Confirm pause and disconnect stop device movement promptly.

Exit criterion: the Handy is driven only by Syncopathy and remains acceptably synchronized during normal playback and recovery cases.

The backends needed no changes: they consume `TimesourceModel`, and the session
boundary from phase 1 means they cannot tell which player is behind it. The seek
pulse is shaped to match what the HSP mixin expects - `seeking` raised, the new
position written, then `seeking` cleared - because the mixin rebuilds its buffer
on the falling edge and would otherwise rebuild around the old position.

The player tab reports whether the device is actually being driven, since a
stroker that is not moving looks the same whether that is deliberate or a
connection failure. It sits where the volume slider does, which is free
precisely because the local player - whose volume that is - is not the one
playing.

In the other mode the settings panel warns when Syncopathy still holds a device
connection, and offers to drop it. Syncopathy cannot see what HereSphere is
connected to, so it reports the half it does know rather than leaving the user
to work out why the strokes are fighting.

The remaining boxes need real hardware and a real headset, and belong to the
manual pass.

### Phase 5: Library browsing and polish

- [x] Publish useful Syncopathy categories or bounded library sections.
- [x] Publish the whole library, with bulk metadata and tags for the player's own search.
- [x] Include cached thumbnails and known media metadata.
- [x] Draw the media library's badges and a funscript heatmap onto published thumbnails.
- [x] Report HereSphere's state from every tab, not only the player page.
- [x] Add projection/stereo metadata where Syncopathy can determine it safely.
- [x] Add reconnect diagnostics and actionable error messages.
- [x] Consider outbound open/seek/play commands as a separate opt-in capability.
- [x] Open the library with shelves, and publish the user's saved filter presets as sections.

Sections are, in order: the shelves `Recently Added`, `Unwatched Interactive`,
`Favourites` and `Random Interactive`; one per saved filter preset; then
`Interactive`, `Other Videos`, and one per user category.

**The order is by the question each section answers.** The shelves and the saved
presets answer "what do I watch now", which is what a headset gets opened with.
The complete lists answer "where is that file" — a question the player's own
search over `/scan` answers better than a list of several thousand entries can,
which is why they sit below rather than above.

**Nothing is capped.** A shelf is an ordering and a question, not a sample: the
point of `Unwatched Interactive` is that it is everything unwatched, and one that
quietly showed the first forty would be a section that lied about its own name.
The same reasoning that removed the five-hundred section cap applies — the index
carries nothing per entry but a URL, so length was never what made it expensive.
What each shelf contributes is its order and its predicate, and both survive
being complete.

`Random Interactive` is reshuffled on every index request. Scrolling a long grid
in a headset is slow enough that "show me something" is a real way to browse, and
what makes this shelf that is the reshuffle rather than any cut: the front of the
row is different every time it is opened, and the rest is still all there.

**Saved filter presets become sections, evaluated by the desktop's own code.**
`MediaFilterLogic.filterAndSort` is a pure function over `List<MediaFile>` and
`MediaFilterSnapshot` restores a preset without any UI, so a preset means the
same thing in the headset as it does on the monitor. Nothing here invents a
taxonomy: these are the questions the user already decided were worth keeping,
under the names they gave them. The desktop's visibility toggles are left out,
being view state rather than part of what was saved.

A preset that throws is skipped with a warning and costs only its own section. A
filter can reach for state the server has no business depending on — `Playlist`
reads the locally loaded playlist through GetIt — and a headset with no library
at all is a far worse outcome than one missing a section.

Section names are made unique, first claim winning and case ignored, since a
preset or a category can be called anything, including what a shelf is already
called, and a name is all a section has in the headset.

**The section cap was removed.** It was set at five hundred on the theory that a
headset should not be handed an enormous index, and the first real library ran
straight into it: 506 entries published out of considerably more, with the
missing ones indistinguishable from media that had failed to index. The trade
was wrong in both directions — the index carries nothing per entry but a URL, so
the response was never the expensive part, and silently dropping half a library
is a far worse failure than a large response.

**The claim guards the clock, not the library.** One player drives at a time —
two reporting playback would leave Syncopathy unable to say which the device
should follow — but that is a statement about `/event`, and it used to be
enforced in front of every route. Reading the library confuses no clock, so the
cost was paid for nothing: a second device could not so much as list the library,
and, since the claim key is the address a request arrived from, a headset that
woke on a new DHCP lease was refused by its own stale claim for ten minutes. The
check now sits on the event route alone.

Two things that rode on it are now separate. `connectedClient` answers "has
anything reached me" and follows any authenticated request, which is the question
the status panel is asking. `clientAddress` decides where the timestamp channel
dials, so it follows whoever is driving — with the client doing the asking as the
only candidate before anyone is, which is what brings the channel up while a
headset is still browsing rather than a beat late at the first video it opens.

**Bulk metadata goes over `/scan`.** The index gives the player URLs and nothing
else, so without this it learns an entry's title only by fetching that entry's
own metadata — thousands of round trips for a large library, and a search that
covers only what has already been pulled. `/scan` answers with every title,
date, duration, rating and tag at once, which is what makes the player's own
search, sort and filter work across the whole library rather than across the
part of it that happens to be loaded.

HereSphere reaches it by appending `/scan` to the library URL it was given, so it
arrives with no session token and authenticates with credentials in the body,
exactly as the index does. If a player build does not send credentials there, it
gets `access: 0` and the library still works entry by entry — the endpoint is an
optimisation, and a failure of it must never be a failure of the library.

**Tags are the search surface.** The player groups them by the part before the
colon and offers each group as a filter, so the groups published are the
questions this library actually gets browsed with: `Category` (the user's own),
`Interactive`, `Speed` and `Range` bands read off the script, `Resolution`,
`Watched`, `Rating`, and `Script` for AI-generated and multi-axis. Bands rather
than raw numbers, because a filter needs values that repeat across entries — an
exact average speed is unique to each one and would give a filter list as long
as the library.

**Thumbnails carry the library's badges and a heatmap strip.** The same badges
the media grid draws, from the same settings, plus a strip of the funscript along
the bottom edge — so an entry can be told apart in the headset the same way it
can on the desktop, which matters more there because reading a title in VR is
slower. Decorated thumbnails are re-encoded as PNG and cached, keyed on
everything that changes how one is drawn, so a rating or a play count going up
invalidates the picture rather than leaving a stale badge on it. Drawing failure
degrades to the plain thumbnail; a decoration bug must never cost the library its
pictures. Off in one setting for anyone who wants a clean frame.

**Projection metadata is read off the filename, and only off the filename.**
Nothing is inferred from resolution or aspect ratio. HereSphere applies the same
naming convention itself and trusts the API over its own detection when the API
speaks - so a guess would actively make things worse, while a marker the file
already carries cannot. It is worth publishing at all only because Syncopathy
serves media under an opaque identifier, so the player never sees the filename;
reading it here keeps a correctly named file working after the entry has been
renamed in the library. Markers must stand alone as tokens, so `1800s` is not a
180 and `outdoors` is not an over-under.

**The timestamp host is discovered, not typed.** The channel runs opposite to
everything else here - HereSphere listens and Syncopathy dials out - and the
first version asked the user for that address. That was the wrong answer to a
question the server can already answer: the player making these requests is the
player to connect back to, so its address is taken from the connection it
already opened. Only an authenticated request sets it, because it decides where
Syncopathy opens an outbound connection and a stranger must not be able to aim
that. A typed host remains, for the case where what connects is not what plays,
behind a switch that defaults to automatic.

**HereSphere has no player UI of its own; it drives the player tab.** The first
version covered the player page with a `HereSpherePlaybackOverlay` that
restated the title, the clock and the heatmap over a scrim. That was a second
player UI maintained beside the real one, and it answered a question the real
one could answer itself. The controls are now aimed at whichever session owns
playback: the seek bar follows its clock, play/pause and the speed slider
command it, and the funscript graph scrolls on it. A marker travelling across
the heatmap is the funscript pipeline visibly running on HereSphere's clock,
which a title and a clock alone cannot show - and it is the same heatmap the
local player uses, not a copy of it.

Commands are gated on capability rather than hidden behind a cover: a session
that will not accept a seek gets a bar that shows the playhead and takes no
clicks, and one that will not accept play/pause gets a disabled button that
says where the control is. Only the genuinely local controls - volume, the
playlist, the close button, the frame grab - go away, because an external
session has no answer for them at all.

**The local player refuses to start while it is not the one playing.** The
first version handed the clock over and left every local control live, so
clicking a video in the library opened it in mpv underneath a headset that was
already playing - two videos, two soundtracks, and a funscript following
whichever reported last. The guard is one check in the local player's two open
methods rather than one per button, so a call site added later cannot quietly
reintroduce it, and it says which session is in charge rather than failing
silently. Handing the clock to HereSphere also pauses the local player, since
handing over ownership does not by itself stop anything that was running.

Local controls that command the local player are hidden or aimed elsewhere
while an external session owns playback: the close button, the playlist
controls, the frame-grab thumbnail, and the pause shortcut - which now targets
whichever session owns playback instead of always the local one. Fullscreen
needs no special case: it builds the same `VideoWidget`, so it carries the same
session-aimed controls.

`VideoWidget` still takes the local `VideoPlayer` for the surface it renders,
the volume and the playlist, which is what that argument is for. Everything
clock-bound in it - the seek bar, the transport buttons, the timestamp and the
scrolling graph - reads `ActivePlaybackSession` instead.

**Outbound commands are opt-in and separately gated.** Observing a player and
steering it are different permissions.
`HereSphereTimestampClient.sendCommand` refuses unless enabled, and the session
advertises `seek`, `playPause` and `setSpeed` capabilities only while a command
sink is attached - so the UI disables those controls rather than offering ones
that quietly do nothing.

## Test Matrix

Cover at least:

- Windows HereSphere and standalone headset HereSphere.
- Same-machine localhost and headset-to-PC LAN connections.
- MP4 and MKV, short and multi-hour media, and high-bitrate 8K media.
- Initial play, pause/resume, repeated scrub seeks, large seeks, playback speed changes, natural end, and looping.
- Buffering or Wi-Fi interruption, timestamp disconnect, HTTP disconnect, headset sleep, Syncopathy restart, and Handy reconnect.
- Every local control while a headset is playing: library click, playlist play-all, wheel of fortune, keyboard shortcuts, fullscreen, close, and the playlist buttons.
- Bluetooth HSP, Web HSP, and command backends.
- Both device-owner modes, including switching between them mid-session.
- Invalid ranges, malformed JSON, stale tokens, unknown IDs, and simultaneous-client attempts — including a second device browsing the library while a headset plays, which must be allowed, and a second player posting events, which must not.
- A headset that sleeps and returns on a different address: it should reach the library at once and take the clock back at its next event, not wait out the previous claim.
- A library large enough to have been truncated by the old cap, browsed end to end in the headset.
- The player's own search and tag filters against the published `/scan` data.
- The shelves and preset sections in a real headset: that the order reads as a landing page rather than a filing cabinet, that `Random Interactive` really does redraw, and that a preset returns in the headset what it returns on the desktop.
- Decorated thumbnails: badges legible at headset distance, heatmap readable over a bright frame, and the picture still correct after a rating or play count changes.
- The login handshake on a real player: first prompt, wrong password, correct password, a password changed while a headset is connected, and a session left idle overnight.

Automated coverage already spans the byte-range rules, the API response shapes
in both modes, the TCP framing (including split reads, coalesced frames and a
desynchronised stream), the timestamp client against a real socket (reconnect,
keepalive, staleness), the clock rules (seek, stall, loop, fail-safe), media
resolution, projection detection, and clock handover. What the manual pass has
to add is everything involving a real HereSphere build, a real headset, real
media, and a real device: the protocol semantics this was written to, sustained
throughput and memory on multi-hour 8K files, measured latency, and the
refuse-a-second-driver path against two real players, which loopback can only
approximate by injecting the claim.

## Acceptance Criteria

- HereSphere can browse at least one Syncopathy library section and stream indexed media with working seek.
- Syncopathy selects the correct `MediaFile` and funscript by opaque identifier, without relying on the client filesystem path.
- Steady playback uses a smoothly advancing clock and periodic authoritative correction.
- Play, pause, seek, and speed changes propagate to the Handy within measured and documented bounds.
- A lost or stale HereSphere session stops Handy playback safely.
- In the default mode HereSphere receives no funscript URL and does not control the Handy; in the other mode it receives script URLs and Syncopathy commands nothing.
- Switching the mode takes effect on the next request, and script URLs issued in the other mode stop resolving at once.
- Existing local playback remains unchanged when the experiment is disabled.
- The server is off by default and does not expose arbitrary files.
- Nothing about the library is revealed before a successful login, and no route but the login endpoint answers without a session token.

## Risks and Open Questions

- Complete HereSphere API documentation is distributed through its Discord, so current event semantics must be validated against real builds.
- Event behavior during buffering, looping, and seeking may require conservative inference.
- One-second timestamp snapshots are insufficient for prompt pause handling by themselves; event callbacks must prove reliable.
- HereSphere codec support varies by platform. Direct streaming cannot repair unsupported encodings.
- `/scan` duration is published in seconds while `videoData` publishes
  milliseconds. That asymmetry mirrors the reference implementation, which has
  sent it that way for years, but it has not been checked against a real player:
  if durations read wrong while browsing and right once an entry opens, this
  scale is why.
- Whether HereSphere sends credentials to `/scan` at all is unverified. If it
  does not, the endpoint is inert and the library falls back to per-entry
  metadata.
- The timestamp host is discovered rather than configured, with a typed host as the fallback. The port has its own setting, defaulting to HereSphere's 23554.

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

