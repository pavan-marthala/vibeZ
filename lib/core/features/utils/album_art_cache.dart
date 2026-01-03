import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

class AlbumArtCache {
  static Future<String?> save(Uint8List? bytes, String trackId) async {
    if (bytes == null) return null;

    final dir = await getApplicationSupportDirectory();
    final file = File('${dir.path}/art_$trackId.jpg');

    if (await file.exists()) return file.path;

    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }
}
