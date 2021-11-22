import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/app_module.dart';
import 'package:talao/app/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logging/logging.dart';
import 'package:talao/app/pages/credentials/blocs/scan.dart';
import 'package:talao/app/pages/qr_code/bloc/qrcode.dart';
import 'package:talao/deep_link/cubit/deep_link.dart';

Future<void> main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.toString()}');
  });

  WidgetsFlutterBinding.ensureInitialized();

  runApp(ModularApp(
    module: AppModule(),
    child: BlocProvider<DeepLinkCubit>(
      create: (context) => DeepLinkCubit(),
      child: BlocProvider<ScanBloc>(
        create: (context) => ScanBloc(Dio()),
        child: BlocProvider<QRCodeBloc>(
          create: (context) => QRCodeBloc(Dio(), context.read<ScanBloc>()),
          child: AppWidget(),
        ),
      ),
    ),
  ));
}
