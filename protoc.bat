protoc --dart_out=lib/generated -Iprotos protos\constants.proto
protoc --dart_out=lib/generated -Iprotos protos\handy_rpc.proto
protoc --dart_out=lib/generated -Iprotos protos\messages.proto
protoc --dart_out=lib/generated -Iprotos protos\notifications.proto

REM dart run libmpv_dart:setup --platform windows