# syncopathy

An offline bluetooth script player for the handy made with flutter.  
There's also a web version deployed over [here](https://ofs69.github.io/syncopathy-web/)

## Dev stuff
```
// how to generate protobuf files if they need updating
protoc --dart_out=lib/generated -Iprotos protos\constants.proto
protoc --dart_out=lib/generated -Iprotos protos\handy_rpc.proto
protoc --dart_out=lib/generated -Iprotos protos\messages.proto
protoc --dart_out=lib/generated -Iprotos protos\notifications.proto

// needs to be run when changing @JsonSerializable classes
dart run build_runner build --delete-conflicting-outputs
```
I forked this library because I needed some changes
[media-kit](https://github.com/ofs69/media-kit)

The project uses sqflite for the database.  

`ffmpeg` is expected to be available for thumbnail generation. So on windows it is best to just include it. On linux just have ffmpeg installed.

