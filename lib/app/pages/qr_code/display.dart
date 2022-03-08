import 'package:talao/app/shared/model/credential_model/credential_model.dart';

import 'package:talao/app/shared/widget/back_leading_button.dart';
import 'package:talao/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeDisplayPage extends StatelessWidget {
  final String name;
  final CredentialModel data;

  const QrCodeDisplayPage({
    Key? key,
    required this.name,
    required this.data,
  }) : super(key: key);

  static Route route(String name, CredentialModel data) => MaterialPageRoute(
        builder: (context) => QrCodeDisplayPage(
          name: name,
          data: data,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: ' ',
      titleLeading: BackLeadingButton(),
      scrollView: false,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(32.0),
                child: QrImage(
                  data: data.shareLink,
                  version: QrVersions.auto,
                  foregroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
