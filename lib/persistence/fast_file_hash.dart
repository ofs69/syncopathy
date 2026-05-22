import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:syncopathy/persistence/entities/fast_hash_cache.dart';
import 'package:syncopathy/persistence/service/fast_hash_cache_service.dart';

/// A file hash that takes a lot of shortcuts to be as fast as possible
/// If [cacheService] is provided, it will check the cache first and update it after hashing.
Future<String?> fastFileHash(
  File file, {
  FastHashCacheService? cacheService,
}) async {
  if (!await file.exists()) {
    return null;
  }

  final stat = await file.stat();
  final mtime = stat.modified.millisecondsSinceEpoch;
  final size = stat.size;

  if (cacheService != null) {
    final cached = cacheService.getByPath(file.path);
    if (cached != null && cached.mtime == mtime && cached.size == size) {
      return cached.hash;
    }
  }

  try {
    final raf = await file.open(mode: FileMode.read);

    // 4 KB per chunk
    const int chunkSize = 4 * 1024;
    // Only read start and end
    const int totalNeeded = chunkSize * 2;

    try {
      final List<int> dataToHash = [];

      if (size <= totalNeeded) {
        // File is small enough to read entirely without seeking
        dataToHash.addAll(await raf.read(size));
      } else {
        // Read Start (0 to 4KB)
        dataToHash.addAll(await raf.read(chunkSize));

        // Read End (Jump to length - 4KB)
        await raf.setPosition(size - chunkSize);
        dataToHash.addAll(await raf.read(chunkSize));
      }

      // Append length
      dataToHash.addAll(size.toString().codeUnits);

      final hash = sha256.convert(dataToHash).toString();

      if (cacheService != null) {
        cacheService.put(
          FastHashCache(path: file.path, mtime: mtime, size: size, hash: hash),
        );
      }

      return hash;
    } finally {
      await raf.close();
    }
  } catch (e) {
    debugPrint(e.toString());
    return null;
  }
}
