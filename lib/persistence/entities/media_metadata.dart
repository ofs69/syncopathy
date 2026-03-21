import 'package:objectbox/objectbox.dart';

@Entity()
class MediaMetadata {
  @Id()
  int id = 0;

  double duration;
  int? width;
  int? height;
  String? videoCodec;
  String? audioCodec;
  int? bitRate;
  int? rotation;
  String? frameRate;
  int? audioChannels;
  String? pixelFormat;
  String? aspectRatio;
  DateTime? creationTime;

  MediaMetadata({
    required this.duration,
    this.width,
    this.height,
    this.videoCodec,
    this.audioCodec,
    this.bitRate,
    this.rotation,
    this.frameRate,
    this.audioChannels,
    this.pixelFormat,
    this.aspectRatio,
    this.creationTime,
  });
}
