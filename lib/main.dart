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
          'pW3isq9daL3WPKIZMu2rUiNb7S6laFJqo3h75ZL3Uf8bCIJnwd4fcRlmAMnB50xc');
  runApp(
    AppWidget(),
  );
}
