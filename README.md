# syncopathy

An offline Bluetooth script player for the Handy, built with Flutter. Reads `.funscript` files and synchronizes them with video playback. Includes a full media library with thumbnail generation, powerful filtering, and a lightweight simple mode (`--simple`) for single-file playback.

Web version: https://ofs69.github.io/syncopathy-web/

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart ≥ 3.8.1)
- **FFmpeg** on `PATH` — required for thumbnail generation. On Windows, place the binary alongside the app or add it to PATH; on Linux, `apt install ffmpeg`.
- **Handy Web API backend only**: a `config.json` at the project root containing a Handy application ID:
  ```json
  { "HANDY_APPLICATION_ID": "<your-id>" }
  ```

## Getting started

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

The second command regenerates code for `@JsonSerializable`, `@freezed`, and ObjectBox entities. Re-run it whenever you modify any annotated class.

## Run

```bash
flutter run
```

## Build (Windows release)

```bash
# Without Handy Web API support
flutter build windows --release

# With Handy Web API support (requires config.json)
flutter build windows --release --dart-define-from-file=config.json
```

## Notes

- **media_kit** is a [custom fork](https://github.com/ofs69/media-kit) — `flutter pub get` fetches it from Git automatically.
- **ObjectBox** is native-only; the web build uses LocalStorage instead.
- **Protobuf** — only regenerate when `.proto` files under `protos/` actually change:
  ```bash
  protoc --dart_out=lib/generated -Iprotos protos/*.proto
  ```
  Requires `protoc` and the Dart plugin (`dart pub global activate protoc_plugin`).
