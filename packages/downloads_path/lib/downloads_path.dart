import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class DownloadsPath {
  static const MethodChannel _channel = MethodChannel('downloads_path');

  static Future<Directory?> get downloadsDirectory async {
    final String? path = await _channel.invokeMethod('getDownloadsDirectory');
    if (path == null) {
      return null;
    }
    return Directory(path);
  }
}
