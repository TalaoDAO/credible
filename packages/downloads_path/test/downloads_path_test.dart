import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:downloads_path/downloads_path.dart';

void main() {
  const MethodChannel channel = MethodChannel('downloads_path');

  String androidPath = "/storage/emulated/0/Download";
  String iosPath = "/var/mobile/Containers/Data/Application/3FA7A01C-9474-08D70A12122CC3/Downloads";

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return Platform.isAndroid ? androidPath : iosPath;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatFormDirectory', () async {
    var downloadsDirectory = await DownloadsPath.downloadsDirectory;
    expect(downloadsDirectory!.path, Platform.isAndroid ? androidPath : iosPath);
  });
}
