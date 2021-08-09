import 'package:credible/app/app_module.dart';
import 'package:credible/app/app_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logging/logging.dart';

Future<void> main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.toString()}');
  });

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(ModularApp(
    module: AppModule(),
    child: AppWidget(),
  ));
}
