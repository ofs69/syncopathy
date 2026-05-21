import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

/// A file hash that takes a lot of shortcuts to be as fast as possible
Future<String?> fastFileHash(File file) async {
  if (!await file.exists()) {
    return null;
  }

  try {
    final length = await file.length();
    final raf = await file.open(mode: FileMode.read);

    // 4 KB per chunk
    const int chunkSize = 4 * 1024;
    // Only read start and end
    const int totalNeeded = chunkSize * 2;

    try {
      final List<int> dataToHash = [];

      if (length <= totalNeeded) {
        // File is small enough to read entirely without seeking
        dataToHash.addAll(await raf.read(length));
      } else {
        // Read Start (0 to 4KB)
        dataToHash.addAll(await raf.read(chunkSize));

        // Read End (Jump to length - 4KB)
        await raf.setPosition(length - chunkSize);
        dataToHash.addAll(await raf.read(chunkSize));
      }

      // Append length
      dataToHash.addAll(length.toString().codeUnits);

      return sha256.convert(dataToHash).toString();
    } finally {
      await raf.close();
    }
  } catch (e) {
    debugPrint(e.toString());
    return null;
  }
}
