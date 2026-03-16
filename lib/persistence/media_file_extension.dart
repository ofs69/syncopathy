import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/media_library/media_metadata_retriever.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

extension MediaFileExtension on MediaFile {
  Future<double?> retrieveDuration() async {
    if (duration != null) return duration;
    final fetch = oBox.mediaService.getById(id);
    if (fetch?.duration != null) return fetch?.duration;

    final metadataRequest = MetadataRequest.fromMediaFile(this);
    final metadata = await MediaMetadataRetriever.addRequest(metadataRequest);
    duration = metadata?.mediaDuration;
    oBox.mediaService.save(this);
    return duration;
  }
}
