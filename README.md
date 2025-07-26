# syncopathy

An offline bluetooth script player for the handy.

## Dev stuff
```
// how to generate protobuf files if they need updating
protoc --dart_out=lib/generated -Iprotos protos\constants.proto
protoc --dart_out=lib/generated -Iprotos protos\handy_rpc.proto
protoc --dart_out=lib/generated -Iprotos protos\messages.proto
protoc --dart_out=lib/generated -Iprotos protos\notifications.proto

// fetch the dlls for mpv
// on linux you have to install it via your package manager sudo apt install libmpv-dart
dart run libmpv_dart:setup --platform windows 
```
I forked this library because I needed some changes
https://github.com/ofs69/libmpv_dart

The project uses https://github.com/isar/isar for the database.  
To update the models `dart run build_runner build` needs to be executed.  
It throws some errors because the generator goes into the protobuf directory. no idea how to prevent that but it works nonetheless.

`ffmpeg` is expected to be available for thumbnail generation. So on windows it is best to just include it. On linux just have ffmpeg installed.

