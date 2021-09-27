import 'dart:convert';

import 'package:talao/app/interop/chapi/chapi.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/pages/credentials/blocs/scan.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:talao/app/shared/widget/brand.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // initDynamicLinks();
    Future.delayed(
      const Duration(
        milliseconds: kIsWeb ? 25 : 1000,
      ),
      () async {
        final key = await SecureStorageProvider.instance.get('key') ?? '';

        if (key.isEmpty) {
          await Modular.to.pushReplacementNamed('/on-boarding');
          return;
        }

        CHAPIProvider.instance.init(
          get: (json, done) async {
            final data = jsonDecode(json);
            final url = Uri.parse(data['origin']);

            Modular.get<ScanBloc>().add(ScanEventShowPreview({}));

            await Modular.to.pushReplacementNamed(
              '/credentials/chapi-present',
              arguments: <String, dynamic>{
                'url': url,
                'data': data['event'],
                'done': done,
              },
            );
          },
          store: (json, done) async {
            final data = jsonDecode(json);
            final url = Uri.parse(data['origin']);

            Modular.get<ScanBloc>().add(ScanEventShowPreview({
              'credentialPreview': data['event'],
            }));

            await Modular.to.pushReplacementNamed(
              '/credentials/chapi-receive',
              arguments: <String, dynamic>{
                'url': url,
                'data': data['event'],
                'done': done,
              },
            );
          },
        );

        CHAPIProvider.instance.emitReady();

        await Modular.to.pushReplacementNamed('/credentials');
      },
    );
  }

  @override
  Widget build(BuildContext context) => BasePage(
        backgroundGradient: UiKit.palette.splashBackground,
        scrollView: false,
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(24.0),
          child: BrandMinimal(),
        ),
      );

  // void initDynamicLinks() async {
  //   FirebaseDynamicLinks.instance.onLink(
  //       onSuccess: (PendingDynamicLinkData? dynamicLink) async {
  //     if (dynamicLink != null) {
  //       final Uri deepLink = dynamicLink.link;
  //       if (deepLink != null) {
  //         await Modular.to.pushReplacementNamed(deepLink.path);
  //       }
  //     }
  //   }, onError: (OnLinkErrorException e) async {
  //     print('onLinkError');
  //     print(e.message);
  //   });
  //
  //   final PendingDynamicLinkData? data =
  //       await FirebaseDynamicLinks.instance.getInitialLink();
  //   if (data != null) {
  //     final Uri deepLink = data.link;
  //     await Modular.to.pushReplacementNamed(deepLink.path);
  //   }
  // }
}
