import 'package:syncopathy/main.dart';
import 'package:syncopathy/objectbox.g.dart';
import 'package:syncopathy/persistence/entities/funscript_file.dart';
import 'package:syncopathy/persistence/entities/key_value.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/persistence/entities/media_list.dart';
import 'package:syncopathy/sqlite/sqlite_helper.dart';

class MigrationService {
  Future<void> migrate() async {
    final videos = await SQLiteHelper().getAllVideos();
    final categories = await SQLiteHelper().getAllUserCategories();
    final keyValues = await SQLiteHelper().getAllKeyValues();

    await oBox.store.runInTransactionAsync(TxMode.write, (store, parameter) {
      final kvBox = store.box<KeyValue>();
      for (final kv in keyValues) {
        kvBox.put(KeyValue(key: kv.id!, value: kv.value));
      }

      // CategoryId -> MediaList
      Map<int, MediaList> categoryMap = {};
      final listBox = store.box<MediaList>();
      for (final category in categories) {
        final list = MediaList(
          name: category.name,
          description: category.description,
          sortOrder: category.sortOrder,
        );
        final _ = listBox.put(list);
        categoryMap[category.id!] = list;
      }

      final funscriptBox = store.box<FunscriptFile>();
      final mediaBox = store.box<MediaFile>();
      for (final video in videos) {
        final funscript = FunscriptFile(
          path: video.funscriptPath,
          averageMax: video.averageMax,
          averageMin: video.averageMin,
          averageSpeed: video.averageSpeed,
          metadata: video.funscriptMetadata,
        );
        funscriptBox.put(funscript);

        final rating = switch ((video.isFavorite, video.isDislike)) {
          (true, false) => MediaRating.like,
          (false, true) => MediaRating.dislike,
          (_, _) => MediaRating.noRating,
        };
        final media = MediaFile(
          duration: video.duration,
          mediaPath: video.videoPath,
          name: video.title,
          playCount: video.playCount,
          rating: rating,
          type: MediaType.video,
        );
        media.funscripts.add(funscript);
        mediaBox.put(media);

        for (final category in video.categories) {
          final list = categoryMap[category.id!];
          list!.entries.add(media);
          listBox.put(list);
        }
      }
    }, null);
  }
}
