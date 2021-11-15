import 'package:talao/app/app_module.dart';
import 'package:talao/app/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logging/logging.dart';

Future<void> main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.toString()}');
  });

  WidgetsFlutterBinding.ensureInitialized();


  runApp(ModularApp(
    module: AppModule(),
    child: AppWidget(),
  ));
}
