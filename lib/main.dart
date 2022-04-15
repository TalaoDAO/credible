import 'package:passbase_flutter/passbase_flutter.dart';
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
  await PassbaseSDK.initialize(
      publishableApiKey:
          'Ww3TIde3B8nh5M3EZ57tkzIbMyAVwzh9YzW8FcwADKgpQ76UfT5bqox2dvdNTDVo');
  runApp(
    AppWidget(),
  );
}
