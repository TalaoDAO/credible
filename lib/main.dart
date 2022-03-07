import 'package:downloads_path/downloads_path.dart';
import 'package:talao/app/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:talao/app/interop/local_notification/local_notification.dart';

Future<void> main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.toString()}');
  });

  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotification().init();
  var data =  await DownloadsPath.downloadsDirectory;
  print(data!.path);
  print("#############################################");
  runApp(
    AppWidget(),
  );
}
