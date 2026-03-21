import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/media_library/media_metadata_retriever.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/persistence/entities/media_metadata.dart';

extension MediaFileExtension on MediaFile {
  Future<MediaMetadata?> retrieveMetadata() async {
    var meta = metadata.target;
    if (meta != null) return meta;
    final fetch = oBox.mediaService.getById(id);
    if (fetch?.metadata.target != null) return fetch?.metadata.target;

    final metadataRequest = MetadataRequest.fromMediaFile(this);
    final metadataRetrieved = await MediaMetadataRetriever().addRequest(
      metadataRequest,
    );
    if (metadataRetrieved == null) return null;
    metadata.target = MediaMetadata(
      duration: metadataRetrieved.duration,
      aspectRatio: metadataRetrieved.aspectRatio,
      audioChannels: metadataRetrieved.audioChannels,
      audioCodec: metadataRetrieved.audioCodec,
      bitRate: metadataRetrieved.bitRate,
      creationTime: metadataRetrieved.creationTime,
      frameRate: metadataRetrieved.frameRate,
      height: metadataRetrieved.height,
      width: metadataRetrieved.width,
      pixelFormat: metadataRetrieved.pixelFormat,
      rotation: metadataRetrieved.rotation,
      videoCodec: metadataRetrieved.videoCodec,
    );
    oBox.mediaService.save(this);
    return metadata.target;
  }
}
