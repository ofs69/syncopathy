import 'dart:io';
import 'package:crypto/crypto.dart';


// Future<String?> fastFileHash(String path) async {
//   final file = File(path);

//   if (!await file.exists()) {
//     return null;
//   }

//   try {
//     final length = await file.length();
//     final raf = await file.open(mode: FileMode.read);

//     // 4 kb
//     const int maxBytes = 4 * 1024;
//     try {
//       final List<int> dataToHash = [];

//       if (length <= maxBytes) {
//         // File is small. Read the whole thing.
//         dataToHash.addAll(await raf.read(length));
//       } else {
//         // Read Start
//         dataToHash.addAll(await raf.read(maxBytes));
//       }

//       // Append file size as a string
//       dataToHash.addAll(length.toString().codeUnits);

//       return sha256.convert(dataToHash).toString();
//     } finally {
//       await raf.close();
//     }
//   } catch (e) {
//     // Return null on I/O errors (permissions, locked files, etc.)
//     return null;
//   }
// }


/// A file hash that takes a lot of shortcuts to be as fast as possible
Future<String?> fastFileHash(String path) async {
  final file = File(path);

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
    return null;
  }
}